<?php
session_start();

const ADMIN_USER = 'admin';
const ADMIN_PASS = 'senhaSegura123';
const DATA_DIR   = __DIR__ . '/data';
const TFA_FILE   = DATA_DIR . '/2fa-config.json';
const LOG_FILE   = DATA_DIR . '/notifications.log';
if (!isset($_SERVER['SERVER_NAME']) || $_SERVER['SERVER_NAME'] === '127.0.0.1') {
    file_put_contents(__DIR__ . '/data/notifications.log', '');
}
const MAIL_CFG   = __DIR__ . '/config/mail.json';

if (!is_dir(DATA_DIR)) {
    mkdir(DATA_DIR, 0775, true);
}

function loadTwofaConfig(): array {
    if (!file_exists(TFA_FILE)) {
        return ['enabled' => false, 'provider' => null, 'secret_hash' => null, 'contact' => null];
    }
    $json = file_get_contents(TFA_FILE);
    $data = json_decode($json, true);
    if (!is_array($data)) return ['enabled' => false, 'provider' => null, 'secret_hash' => null, 'contact' => null];
    return array_merge(['enabled' => false, 'provider' => null, 'secret_hash' => null, 'contact' => null], $data);
}

function saveTwofaConfig(array $cfg): bool {
    $payload = json_encode($cfg, JSON_PRETTY_PRINT);
    return (bool) file_put_contents(TFA_FILE, $payload);
}

function loadMailConfig(): array {
    if (!file_exists(MAIL_CFG)) {
        return [
            'mode' => 'log',
            'from' => 'no-reply@example.com',
            'from_name' => 'Construtora Alianca'
        ];
    }

    $json = file_get_contents(MAIL_CFG);
    $data = json_decode($json, true);
    if (!is_array($data)) $data = ['mode' => 'log'];

    // ----- PRIORIDADE: variável de ambiente -----
    // Exemplo: export MAIL_SENHA="minhaSenha"
    $envPass = getenv('MAIL_SENHA');

    if (!empty($envPass)) {
        $data['password'] = $envPass;
    } else {
        // Mantém a password do mail.json se variável não existir
        $data['password'] = $data['password'] ?? '';
    }

    return $data;
}


function sendEmailSimple(string $to, string $subject, string $body): array {
    $cfg = loadMailConfig();
    if (($cfg['mode'] ?? 'log') === 'log') {
        logNotification('email', $to, $subject . ' | ' . $body, true);
        return ['ok'=>true];
    }
    if (($cfg['mode'] ?? '') === 'smtp') {
        return smtpSend($cfg, $to, $subject, $body);
    }
    // sendmail fallback: basic mail() with headers
    $from = $cfg['from'] ?? 'no-reply@example.com';
    $fromName = $cfg['from_name'] ?? 'Construtora Alianca';
    $headers = "From: {$fromName} <{$from}>\r\n";
    $headers .= "Reply-To: {$from}\r\n";
    $headers .= "Content-Type: text/plain; charset=utf-8\r\n";
    $ok = @mail($to, $subject, $body, $headers);
    return $ok ? ['ok'=>true] : ['ok'=>false,'msg'=>'mail_function_failed'];
}


function smtpSend(array $cfg, string $to, string $subject, string $body): array {
    $host     = $cfg['host']     ?? '';
    $port     = (int)($cfg['port'] ?? 25);
    $user     = $cfg['username'] ?? '';
    $pass     = $cfg['password'] ?? '';
    $security = strtolower($cfg['security'] ?? 'none'); // ssl, tls, none
    $from     = $cfg['from']     ?? $user;
    $fromName = $cfg['from_name'] ?? 'Construtora Alianca';

    if (!$host || !$port || !$user || !$pass) {
        return ['ok' => false, 'msg' => 'missing_smtp_config'];
    }

    // ----- DEFINIÇÃO DO TRANSPORTE -----
    if ($security === 'ssl') {
        $remote = 'ssl://' . $host . ':' . $port;
    } else {
        $remote = 'tcp://' . $host . ':' . $port;
    }

    $contextOptions['ssl'] = [
        'verify_peer'       => false,
        'verify_peer_name'  => false,
        'allow_self_signed' => true,
        'crypto_method'     =>
            STREAM_CRYPTO_METHOD_TLSv1_2_CLIENT |
            STREAM_CRYPTO_METHOD_TLSv1_3_CLIENT
    ];

    $context = stream_context_create($contextOptions);

    $errno  = 0;
    $errstr = '';

    $fp = @stream_socket_client(
        $remote,
        $errno,
        $errstr,
        15,
        STREAM_CLIENT_CONNECT,
        $context
    );

    if (!$fp) {
        logNotification('email-error', (string)$to, 'connect_fail ' . $errno . ' ' . $errstr, true);
        return ['ok' => false, 'msg' => 'connect_fail', 'detail' => $errstr];
    }

    stream_set_timeout($fp, 15);

    $read = function() use ($fp) {
        return fgets($fp, 512);
    };
    $write = function($cmd) use ($fp) {
        fwrite($fp, $cmd . "\r\n");
    };
    $expect = function($prefix) use ($read) {
        $resp = '';
        do {
            $line = $read();
            if ($line === false) {
                break;
            }
            if ($resp === '') {
                $resp = $line;
            }
            $more = isset($line[3]) && $line[3] === '-';
        } while ($more);
        if ($resp === '' || strpos($resp, $prefix) !== 0) {
            return ['ok' => false, 'msg' => 'smtp_resp_' . $prefix, 'detail' => $resp];
        }
        return true;
    };

    // ===== Banner 220 (multi-linha) =====
    $bannerResp = '';
    do {
        $line = $read();
        if ($line === false) {
            break;
        }
        if ($bannerResp === '') {
            $bannerResp = $line;
        }
        $more = isset($line[3]) && $line[3] === '-'; // 220-... / 220 ...
    } while ($more);

    if ($bannerResp === '' || strpos($bannerResp, '220') !== 0) {
        fclose($fp);
        logNotification('email-error', (string)$to, 'no_banner ' . trim($bannerResp), true);
        return ['ok' => false, 'msg' => 'no_banner', 'detail' => $bannerResp];
    }
    logNotification('smtp-banner', (string)$to, trim($bannerResp), true);

    // ===== EHLO com fallback =====
    $write('EHLO localhost');
    $ehlo = $expect('250');

    if ($ehlo !== true) {
        logNotification('smtp-ehlo-fallback', (string)$to, 'localhost_failed', true);
        $write('EHLO construtoraalianca.com.br');
        $ehlo = $expect('250');
        if ($ehlo !== true) {
            fclose($fp);
            logNotification('email-error', (string)$to, 'ehlo_fail_after_fallback', true);
            return $ehlo;
        }
    }

    // ===== STARTTLS se security = "tls" =====
    if ($security === 'tls') {
        $write('STARTTLS');
        $st = $expect('220');
        if ($st !== true) {
            fclose($fp);
            logNotification('email-error', (string)$to, 'starttls_fail', true);
            return $st;
        }

        $cryptoOk = stream_socket_enable_crypto(
            $fp,
            true,
            STREAM_CRYPTO_METHOD_TLSv1_2_CLIENT | STREAM_CRYPTO_METHOD_TLSv1_3_CLIENT
        );

        if (!$cryptoOk) {
            fclose($fp);
            logNotification('email-error', (string)$to, 'enable_crypto_fail', true);
            return ['ok' => false, 'msg' => 'enable_crypto_fail'];
        }

        // EHLO novamente após STARTTLS
        $write('EHLO localhost');
        $eh2 = $expect('250');
        if ($eh2 !== true) {
            logNotification('smtp-ehlo2-fallback', (string)$to, 'localhost_failed', true);
            $write('EHLO construtoraalianca.com.br');
            $eh2 = $expect('250');
            if ($eh2 !== true) {
                fclose($fp);
                logNotification('email-error', (string)$to, 'ehlo_after_starttls_fail', true);
                return $eh2;
            }
        }
    }

    // ===== AUTH LOGIN =====
    $write('AUTH LOGIN');

    // Lê resposta bruta do servidor para log
    $raw = $read();
    logNotification('smtp-auth-raw', (string)$to, trim($raw), true);

    if (strpos($raw, '334') !== 0) {
        fclose($fp);
        logNotification('email-error', (string)$to, 'auth_login_step1_fail ' . trim($raw), true);
        return ['ok' => false, 'msg' => 'auth_login_step1_fail', 'detail' => $raw];
    }

    // Envia usuário (base64)
    $write(base64_encode($user));
    $a2 = $expect('334');
    if ($a2 !== true) {
        fclose($fp);
        logNotification('email-error', (string)$to, 'auth_login_step2_fail', true);
        return $a2;
    }

    // Envia senha (base64)
    $write(base64_encode($pass));
    $a3 = $expect('235');
    if ($a3 !== true) {
        fclose($fp);
        logNotification('email-error', (string)$to, 'auth_login_fail', true);
        return $a3;
    }

    // ===== MAIL/RCPT/DATA =====
    $write('MAIL FROM:<' . $from . '>');
    $mf = $expect('250');
    if ($mf !== true) { fclose($fp); logNotification('email-error', (string)$to, 'mail_from_fail', true); return $mf; }

    $write('RCPT TO:<' . $to . '>');
    $rt = $expect('250');
    if ($rt !== true) { fclose($fp); logNotification('email-error', (string)$to, 'rcpt_to_fail', true); return $rt; }

    $write('DATA');
    $d1 = $expect('354');
    if ($d1 !== true) { fclose($fp); logNotification('email-error', (string)$to, 'data_cmd_fail', true); return $d1; }

    $headers = [];
    $headers[] = 'From: ' . $fromName . ' <' . $from . '>';
    $headers[] = 'To: ' . $to;
    $headers[] = 'Subject: ' . $subject;
    $headers[] = 'Content-Type: text/plain; charset=utf-8';
    $headers[] = 'MIME-Version: 1.0';

    $msg  = implode("\r\n", $headers);
    $msg .= "\r\n\r\n" . $body . "\r\n.\r\n";

    $write($msg);
    $d2 = $expect('250');
    if ($d2 !== true) { fclose($fp); logNotification('email-error', (string)$to, 'data_body_fail', true); return $d2; }

    $write('QUIT');
    fclose($fp);

    return ['ok' => true];
}


function twofaRequired(array $cfg): bool {
    if (empty($cfg['enabled']) || empty($cfg['provider'])) return false;
    if ($cfg['provider'] === 'totp') {
        return !empty($cfg['secret_hash']);
    }
    if ($cfg['provider'] === 'email') {
        return !empty($cfg['contact']);
    }
    return false;
}

function verifyTwofaCode(array $cfg, string $code): bool {
    if (!twofaRequired($cfg)) return true;
    if ($code === '') return false;
    // App autenticador: compara hash simples (placeholder)
    if ($cfg['provider'] === 'totp') {
        $hash = hash('sha256', $code);
        return hash_equals($cfg['secret_hash'], $hash);
    }
    // e-mail: valida contra codigo pendente em sessao
    if ($cfg['provider'] === 'email') {
        $pending = $_SESSION['twofa_pending'] ?? null;
        if (!$pending || empty($pending['code'])) return false;
        if (time() - ($pending['ts'] ?? 0) > 300) return false; // 5 min
        return hash_equals((string)$pending['code'], (string)$code);
    }
    return false;
}
function logNotification(string $type, string $contact, string $code, bool $test=false): void {
    $line = sprintf("[%s] %s %s code=%s contact=%s\n", date('c'), $test ? 'TEST' : 'SEND', strtoupper($type), $code, $contact);
    file_put_contents(LOG_FILE, $line, FILE_APPEND);
}

function sendTwofaCode(array $cfg, bool $test=false): array {
    if ($cfg['provider'] !== 'email') {
        return ['ok'=>false,'msg'=>'provider_not_supported'];
    }
    $code = random_int(100000, 999999);
    $_SESSION['twofa_pending'] = [
        'code' => $code,
        'ts' => time(),
        'provider' => $cfg['provider'],
        'contact' => $cfg['contact']
    ];
    $resp = sendEmailSimple((string)$cfg['contact'], 'Codigo de verificacao', "Seu codigo e: {$code}");
    if (empty($resp['ok'])) {
        return ['ok'=>false,'msg'=>'email_send_failed', 'detail'=>$resp['msg'] ?? ''];
    }
    logNotification($cfg['provider'], (string)$cfg['contact'], (string)$code, $test);
    return ['ok'=>true, 'sent'=>true];
}
$method = $_SERVER['REQUEST_METHOD'] ?? 'GET';
$action = $_GET['action'] ?? null;
$cfg = loadTwofaConfig();

function ensureAdmin(){
    if (empty($_SESSION['is_admin'])) {
        http_response_code(401);
        exit(json_encode(['error'=>'unauthorized']));
    }
}

function jsonResponse($data, int $code = 200){
    http_response_code($code);
    header('Content-Type: application/json');
    echo json_encode($data);
    exit;
}

// Status
if ($method === 'GET' && $action === 'status') {
    if (empty($_SESSION['is_admin'])) {
        jsonResponse(['authenticated' => false], 401);
    }
    $twofaRequired = twofaRequired($GLOBALS['cfg']);
    $twofaValid = !$twofaRequired || !empty($_SESSION['twofa_valid']);
    jsonResponse([
        'authenticated' => true,
        'twofa_required' => $twofaRequired,
        'twofa_valid' => $twofaValid,
        'provider' => $GLOBALS['cfg']['provider']
    ]);
}

// Obtem config (sem revelar secreto)
if ($method === 'GET' && $action === 'config') {
    ensureAdmin();
    $safe = [
        'enabled' => twofaRequired($cfg),
        'provider' => $cfg['provider'],
        'contact' => $cfg['contact']
    ];
    jsonResponse($safe);
}

// Verifica sessao basica (legacy)
if ($method === 'GET') {
    if (!empty($_SESSION['is_admin'])) {
        http_response_code(200);
        exit('ok');
    }
    http_response_code(401);
    exit('unauthorized');
}

// Login (sem action)
if ($method === 'POST' && !$action) {
    $user = $_POST['user'] ?? '';
    $pass = $_POST['pass'] ?? '';

    if ($user === ADMIN_USER && $pass === ADMIN_PASS) {
        $_SESSION['is_admin'] = true;
        $_SESSION['twofa_valid'] = twofaRequired($cfg) ? false : true; // 2FA será validado na tela do admin
        if (twofaRequired($cfg) && $cfg['provider'] === 'email') {
            sendTwofaCode($cfg, false);
        }
        http_response_code(200);
        exit('ok');
    }

    http_response_code(401);
    exit('invalid');
}

// Verifica 2FA pós-login
if ($method === 'POST' && $action === 'verify2fa') {
    ensureAdmin();
    $twofa = $_POST['twofa'] ?? '';
    if (!twofaRequired($cfg)) {
        $_SESSION['twofa_valid'] = true;
        jsonResponse(['ok'=>true, 'required'=>false]);
    }
    if (verifyTwofaCode($cfg, (string)$twofa)) {
        $_SESSION['twofa_valid'] = true;
        jsonResponse(['ok'=>true, 'required'=>true]);
    }
    jsonResponse(['error'=>'invalid_2fa'], 401);
}

// Configurar 2FA
if ($method === 'PUT') {
    ensureAdmin();
    $body = json_decode(file_get_contents('php://input'), true);
    if (!is_array($body)) {
        jsonResponse(['error'=>'invalid_body'], 400);
    }
    $provider = isset($body['provider']) ? (string)$body['provider'] : 'totp';
    $secret   = isset($body['secret']) ? (string)$body['secret'] : '';
    $enabled  = !empty($body['enabled']);
    $current  = isset($body['currentCode']) ? (string)$body['currentCode'] : '';
    $contact  = isset($body['contact']) ? (string)$body['contact'] : '';

    // Se já estiver habilitado, exigir código atual para alterar
    if (twofaRequired($cfg)) {
        if (!verifyTwofaCode($cfg, $current)) {
            jsonResponse(['error'=>'invalid_current_2fa'], 401);
        }
    }

    if ($enabled) {
        if ($provider === 'totp' && $secret === '') {
            jsonResponse(['error'=>'secret_required'], 400);
        }
        if ($provider === 'email' && $contact === '') {
            jsonResponse(['error'=>'contact_required'], 400);
        }
    }

    $newCfg = [
        'enabled' => $enabled,
        'provider' => $provider,
        'secret_hash' => ($enabled && $provider === 'totp' && $secret !== '') ? hash('sha256', $secret) : null,
        'contact' => ($enabled && $provider === 'email') ? $contact : null
    ];

    saveTwofaConfig($newCfg);
    // ao alterar, obrigar nova validação 2FA
    unset($_SESSION['twofa_valid']);
    jsonResponse(['ok'=>true, 'enabled'=>$newCfg['enabled']]);
}

// Enviar teste (SMS/Email)
if ($method === 'POST' && $action === 'sendTest') {
    ensureAdmin();
    $provider = $_POST['provider'] ?? '';
    $contact = $_POST['contact'] ?? '';
    if ($provider !== 'email' || $contact === '') {
        jsonResponse(['error'=>'invalid_params'], 400);
    }
    $tmpCfg = ['provider'=>$provider, 'contact'=>$contact];
    $sent = sendTwofaCode($tmpCfg, true);
    if ($sent['ok']) {
        jsonResponse(['ok'=>true]);
    }
    jsonResponse(['error'=>'send_failed'], 500);
}

// Logout
if ($method === 'DELETE') {
    session_destroy();
    exit('bye');
}

http_response_code(405);
exit('method not allowed');









