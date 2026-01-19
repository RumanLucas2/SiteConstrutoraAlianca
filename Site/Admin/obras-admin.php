<?php
declare(strict_types=1);

// ================= ESCUDO JSON (debug sem HTML) =================
ob_start();
header('Content-Type: application/json; charset=utf-8');

register_shutdown_function(function () {
    $err = error_get_last();
    if ($err) {
        http_response_code(500);
        header('Content-Type: application/json; charset=utf-8');
        echo json_encode([
            'ok' => false,
            'error' => 'fatal',
            'message' => $err['message'] ?? '',
            'file' => $err['file'] ?? '',
            'line' => $err['line'] ?? 0,
        ], JSON_UNESCAPED_UNICODE);
    }
});
set_error_handler(function($severity, $message, $file, $line){
    http_response_code(500);
    header('Content-Type: application/json; charset=utf-8');
    echo json_encode([
        'ok'=>false,
        'error'=>'php',
        'message'=>$message,
        'file'=>$file,
        'line'=>$line
    ], JSON_UNESCAPED_UNICODE);
    exit;
});

// ================= CONFIG =================
session_start();

define('ROOT_DIR', dirname(__DIR__));
define('DATA_DIR', ROOT_DIR . '/data');
define('TFA_FILE', DATA_DIR . '/2fa-config.json');
define('ORDER_FILE', DATA_DIR . '/obras-order.json');
define('META_FILE', DATA_DIR . '/obras-meta.json');

require_once ROOT_DIR . '/Pages/Auxiliares/obras-data.php';

$categories = [
    'Casas'      => [
        'imagesDir' => ROOT_DIR . '/images/Obras/Casas',
        'pagesDir'  => ROOT_DIR . '/Pages/Casas',
        'linkBase'  => 'Pages/Casas',
    ],
    'Industrias' => [
        // imagens em Industriais, páginas em Industrias
        'imagesDir' => ROOT_DIR . '/images/Obras/Industriais',
        'pagesDir'  => ROOT_DIR . '/Pages/Industrias',
        'linkBase'  => 'Pages/Industrias',
    ],
    'Outros'     => [
        'imagesDir' => ROOT_DIR . '/images/Obras/Outros',
        'pagesDir'  => ROOT_DIR . '/Pages/Outros',
        'linkBase'  => 'Pages/Outros',
    ],
    'Predios'    => [
        'imagesDir' => ROOT_DIR . '/images/Obras/Predios',
        'pagesDir'  => ROOT_DIR . '/Pages/Predios',
        'linkBase'  => 'Pages/Predios',
    ],
];

$method = $_SERVER['REQUEST_METHOD'] ?? 'GET';
$action = $_GET['action'] ?? '';

if (!isAdminWithTwofa()) {
    jsonResponse(['ok'=>false,'error' => 'unauthorized'], 401);
}

// ================= ROUTES =================

// LIST
if ($method === 'GET' && $action === 'list') {
    $order = loadOrder();
    $data = [];
    foreach ($categories as $cat => $paths) {
        $data[$cat] = listWorks($cat, $paths, $order[$cat] ?? []);
    }
    jsonResponse(['ok' => true, 'categories' => $data]);
}

// POST actions
if ($method === 'POST') {
    $input = json_decode(file_get_contents('php://input'), true);
    if (!is_array($input)) {
        jsonResponse(['ok'=>false,'error' => 'invalid_body'], 400);
    }

    $tipo = isset($input['tipo']) ? (string) $input['tipo'] : '';
    if ($tipo === '' || !isset($categories[$tipo])) {
        jsonResponse(['ok'=>false,'error' => 'invalid_tipo'], 400);
    }

    $paths = $categories[$tipo];

    switch ($action) {
        case 'delete': {
            $slug = isset($input['slug']) ? (string) $input['slug'] : '';
            if ($slug === '') jsonResponse(['ok'=>false,'error' => 'invalid_slug'], 400);

            deleteWork($slug, $paths);
            removeFromOrder($tipo, $slug);
            deleteWorkTitle($tipo, $slug);

            jsonResponse(['ok' => true]);
        }

        case 'rename': {
            $slug = isset($input['slug']) ? (string) $input['slug'] : '';
            $newName = isset($input['name']) ? trim((string)$input['name']) : '';
            if ($slug === '' || $newName === '') jsonResponse(['ok'=>false,'error' => 'invalid_params'], 400);

            $newSlug = renameWork($tipo, $slug, $newName, $paths);

            updateOrderSlug($tipo, $slug, $newSlug);

            // guarda title com acento
            setWorkTitle($tipo, $newSlug, $newName);
            if ($newSlug !== $slug) {
                // se existia meta no slug antigo, move (não perde)
                moveWorkTitle($tipo, $slug, $newSlug);
            }

            jsonResponse(['ok' => true, 'slug' => $newSlug, 'name' => $newName]);
        }

        case 'reorder': {
            $orderArr = isset($input['order']) && is_array($input['order']) ? $input['order'] : [];
            saveOrderForCategory($tipo, $orderArr);
            jsonResponse(['ok' => true]);
        }

        case 'move': {
            $from = $tipo;
            $to = isset($input['to']) ? (string)$input['to'] : '';
            $slug = isset($input['slug']) ? (string)$input['slug'] : '';

            if ($slug === '' || $to === '' || !isset($categories[$to])) {
                jsonResponse(['ok'=>false,'error' => 'invalid_params'], 400);
            }

            $oldTitle = getWorkTitle($from, $slug);

            $newSlug = moveWork($from, $to, $slug, $categories[$from], $categories[$to]);

            removeFromOrder($from, $slug);
            addToOrder($to, $newSlug);

            // transfere title meta de categoria
            if ($oldTitle !== null) {
                deleteWorkTitle($from, $slug);
                setWorkTitle($to, $newSlug, $oldTitle);
            }

            jsonResponse(['ok' => true, 'slug' => $newSlug]);
        }

        default:
            jsonResponse(['ok'=>false,'error' => 'invalid_action'], 400);
    }
}

http_response_code(405);
echo json_encode(['ok'=>false,'error'=>'method_not_allowed'], JSON_UNESCAPED_UNICODE);
exit;

// ================= HELPERS =================

function jsonResponse(array $data, int $code = 200): void
{
    http_response_code($code);
    header('Content-Type: application/json; charset=utf-8');
    echo json_encode($data, JSON_UNESCAPED_UNICODE);
    exit;
}

function loadTwofaConfig(): array
{
    if (!file_exists(TFA_FILE)) {
        return ['enabled' => false, 'provider' => null, 'secret_hash' => null, 'contact' => null];
    }
    $data = json_decode((string) file_get_contents(TFA_FILE), true);
    if (!is_array($data)) {
        return ['enabled' => false, 'provider' => null, 'secret_hash' => null, 'contact' => null];
    }
    return array_merge(['enabled' => false, 'provider' => null, 'secret_hash' => null, 'contact' => null], $data);
}

function twofaRequiredLocal(array $cfg): bool
{
    if (empty($cfg['enabled']) || empty($cfg['provider'])) return false;
    if ($cfg['provider'] === 'totp') return !empty($cfg['secret_hash']);
    if ($cfg['provider'] === 'email') return !empty($cfg['contact']);
    return false;
}

function isAdminWithTwofa(): bool
{
    if (empty($_SESSION['is_admin'])) return false;
    $cfg = loadTwofaConfig();
    if (twofaRequiredLocal($cfg) && empty($_SESSION['twofa_valid'])) return false;
    return true;
}

// ---------- slugify (para pasta/arquivo/url) ----------
function slugify(string $value): string
{
    $value = trim($value);

    if (function_exists('iconv')) {
        $converted = @iconv('UTF-8', 'ASCII//TRANSLIT//IGNORE', $value);
        if ($converted !== false && $converted !== null) {
            $value = $converted;
        }
    }

    $value = preg_replace('/[^A-Za-z0-9]+/', '_', (string)$value);
    $value = preg_replace('/_+/', '_', (string)$value);
    $value = trim((string)$value, '_');

    return $value !== '' ? $value : 'obra';
}

// ---------- META (título com acento) ----------
function loadMeta(): array
{
    if (!file_exists(META_FILE)) return [];
    $data = json_decode((string) file_get_contents(META_FILE), true);
    return is_array($data) ? $data : [];
}

function saveMeta(array $meta): void
{
    if (!is_dir(DATA_DIR)) {
        mkdir(DATA_DIR, 0775, true);
    }
    file_put_contents(META_FILE, json_encode($meta, JSON_PRETTY_PRINT | JSON_UNESCAPED_UNICODE));
}

function getWorkTitle(string $tipo, string $slug): ?string
{
    $meta = loadMeta();
    if (!isset($meta[$tipo]) || !is_array($meta[$tipo])) return null;
    return isset($meta[$tipo][$slug]) ? (string)$meta[$tipo][$slug] : null;
}

function setWorkTitle(string $tipo, string $slug, string $title): void
{
    $meta = loadMeta();
    if (!isset($meta[$tipo]) || !is_array($meta[$tipo])) $meta[$tipo] = [];
    $meta[$tipo][$slug] = $title; // mantém acentos
    saveMeta($meta);
}

function moveWorkTitle(string $tipo, string $oldSlug, string $newSlug): void
{
    $meta = loadMeta();
    if (!isset($meta[$tipo]) || !is_array($meta[$tipo])) return;
    if (!isset($meta[$tipo][$oldSlug])) return;
    $meta[$tipo][$newSlug] = $meta[$tipo][$oldSlug];
    unset($meta[$tipo][$oldSlug]);
    saveMeta($meta);
}

function deleteWorkTitle(string $tipo, string $slug): void
{
    $meta = loadMeta();
    if (!isset($meta[$tipo]) || !is_array($meta[$tipo])) return;
    unset($meta[$tipo][$slug]);
    saveMeta($meta);
}

// ---------- ORDER ----------
function loadOrder(): array
{
    if (!file_exists(ORDER_FILE)) return [];
    $data = json_decode((string) file_get_contents(ORDER_FILE), true);
    return is_array($data) ? $data : [];
}

function saveOrder(array $order): void
{
    if (!is_dir(DATA_DIR)) mkdir(DATA_DIR, 0775, true);
    file_put_contents(ORDER_FILE, json_encode($order, JSON_PRETTY_PRINT | JSON_UNESCAPED_UNICODE));
}

function saveOrderForCategory(string $tipo, array $order): void
{
    $all = loadOrder();
    $all[$tipo] = array_values(array_unique(array_map('strval', $order)));
    saveOrder($all);
}

function removeFromOrder(string $tipo, string $slug): void
{
    $all = loadOrder();
    if (!isset($all[$tipo])) return;
    $all[$tipo] = array_values(array_filter($all[$tipo], static fn($s) => $s !== $slug));
    saveOrder($all);
}

function updateOrderSlug(string $tipo, string $old, string $new): void
{
    $all = loadOrder();
    if (!isset($all[$tipo])) return;
    $all[$tipo] = array_values(array_map(static fn($s) => $s === $old ? $new : $s, $all[$tipo]));
    saveOrder($all);
}

function addToOrder(string $tipo, string $slug): void
{
    $all = loadOrder();
    if (!isset($all[$tipo])) $all[$tipo] = [];
    $all[$tipo][] = $slug;
    $all[$tipo] = array_values(array_unique($all[$tipo]));
    saveOrder($all);
}

// ---------- LIST ----------
function listWorks(string $category, array $paths, array $order): array
{
    $imagesDir = $paths['imagesDir'];
    $pagesDir  = $paths['pagesDir'];
    $linkBase  = $paths['linkBase'];

    $works = loadWorksFromImages($imagesDir, $pagesDir, $linkBase . "/");

    $meta = loadMeta();
    $titles = (isset($meta[$category]) && is_array($meta[$category])) ? $meta[$category] : [];

    $bySlug = [];
    foreach ($works as $w) {
        $slug = basename($w['link'], '.html');

        $title = $titles[$slug] ?? ($w['title'] ?? $slug);

        $bySlug[$slug] = [
            'slug'  => $slug,
            'title' => $title,
            'page'  => $w['link'],
        ];
    }

    $sorted = [];
    foreach ($order as $s) {
        if (isset($bySlug[$s])) {
            $sorted[] = $bySlug[$s];
            unset($bySlug[$s]);
        }
    }

    if ($bySlug) {
        uasort($bySlug, static fn($a, $b) => strcasecmp($a['title'], $b['title']));
        $sorted = array_merge($sorted, array_values($bySlug));
    }

    return $sorted;
}

// ---------- FILE OPS ----------
function deleteDir(string $dir): void
{
    if (!is_dir($dir)) return;
    $items = array_diff(scandir($dir), ['.', '..']);
    foreach ($items as $item) {
        $path = $dir . DIRECTORY_SEPARATOR . $item;
        if (is_dir($path)) deleteDir($path);
        else @unlink($path);
    }
    @rmdir($dir);
}

function deleteWork(string $slug, array $paths): void
{
    $folder = rtrim($paths['imagesDir'], DIRECTORY_SEPARATOR) . DIRECTORY_SEPARATOR . $slug;
    $page   = rtrim($paths['pagesDir'], DIRECTORY_SEPARATOR) . DIRECTORY_SEPARATOR . $slug . '.html';
    if (is_dir($folder)) deleteDir($folder);
    if (file_exists($page)) @unlink($page);
}

// RENAME: slug muda, mas title permanece com acento (salvo no META)
function renameWork(string $tipo, string $slug, string $newName, array $paths): string
{
    $newSlug = slugify($newName);

    $folder = rtrim($paths['imagesDir'], DIRECTORY_SEPARATOR) . DIRECTORY_SEPARATOR . $slug;
    $page   = rtrim($paths['pagesDir'], DIRECTORY_SEPARATOR) . DIRECTORY_SEPARATOR . $slug . '.html';

    $newFolder = rtrim($paths['imagesDir'], DIRECTORY_SEPARATOR) . DIRECTORY_SEPARATOR . $newSlug;
    $newPage   = rtrim($paths['pagesDir'], DIRECTORY_SEPARATOR) . DIRECTORY_SEPARATOR . $newSlug . '.html';

    $counter = 1;
    $base = $newSlug;
    while (($newFolder !== $folder && is_dir($newFolder)) || ($newPage !== $page && file_exists($newPage))) {
        $newSlug = $base . '-' . $counter;
        $newFolder = rtrim($paths['imagesDir'], DIRECTORY_SEPARATOR) . DIRECTORY_SEPARATOR . $newSlug;
        $newPage   = rtrim($paths['pagesDir'], DIRECTORY_SEPARATOR) . DIRECTORY_SEPARATOR . $newSlug . '.html';
        $counter++;
    }

    if (is_dir($folder)) @rename($folder, $newFolder);
    if (file_exists($page)) @rename($page, $newPage);

    // Regenera HTML mantendo o nome com acento
    $images = collectImages($newFolder);
    $html = buildPageHtml($newName, $tipo, $newSlug, $images);
    file_put_contents($newPage, $html);

    return $newSlug;
}

// MOVE: mantém slug se possível; título vem do META (se existir)
function copyDir(string $src, string $dst): bool
{
    if (!is_dir($src)) return false;
    if (!is_dir($dst) && !mkdir($dst, 0775, true)) return false;

    $items = array_diff(scandir($src), ['.', '..']);
    foreach ($items as $item) {
        $from = $src . DIRECTORY_SEPARATOR . $item;
        $to   = $dst . DIRECTORY_SEPARATOR . $item;
        if (is_dir($from)) {
            if (!copyDir($from, $to)) return false;
        } else {
            if (!copy($from, $to)) return false;
        }
    }
    return true;
}

function moveWork(string $fromTipo, string $toTipo, string $slug, array $fromPaths, array $toPaths): string
{
    $fromFolder = rtrim($fromPaths['imagesDir'], DIRECTORY_SEPARATOR) . DIRECTORY_SEPARATOR . $slug;
    $fromPage   = rtrim($fromPaths['pagesDir'], DIRECTORY_SEPARATOR) . DIRECTORY_SEPARATOR . $slug . '.html';

    // título: primeiro tenta META
    $title = getWorkTitle($fromTipo, $slug);
    if ($title === null) {
        $title = humanizeSlug($slug);
        if (file_exists($fromPage)) {
            $html = file_get_contents($fromPage);
            $title = extractTitle($html, $title);
        }
    }

    $newSlug = $slug;
    $base = $slug;

    $toFolder = rtrim($toPaths['imagesDir'], DIRECTORY_SEPARATOR) . DIRECTORY_SEPARATOR . $newSlug;
    $toPage   = rtrim($toPaths['pagesDir'], DIRECTORY_SEPARATOR) . DIRECTORY_SEPARATOR . $newSlug . '.html';

    $counter = 1;
    while (is_dir($toFolder) || file_exists($toPage)) {
        $newSlug = $base . '-' . $counter;
        $toFolder = rtrim($toPaths['imagesDir'], DIRECTORY_SEPARATOR) . DIRECTORY_SEPARATOR . $newSlug;
        $toPage   = rtrim($toPaths['pagesDir'], DIRECTORY_SEPARATOR) . DIRECTORY_SEPARATOR . $newSlug . '.html';
        $counter++;
    }

    $moved = false;
    if (is_dir($fromFolder)) {
        $moved = @rename($fromFolder, $toFolder);
        if (!$moved) {
            $moved = copyDir($fromFolder, $toFolder);
            if ($moved) deleteDir($fromFolder);
        }
    }

    if (!is_dir($toPaths['pagesDir'])) mkdir($toPaths['pagesDir'], 0775, true);

    if (file_exists($fromPage)) {
        if (!@rename($fromPage, $toPage)) {
            @copy($fromPage, $toPage);
            @unlink($fromPage);
        }
    }

    $images = collectImages($toFolder);
    $html = buildPageHtml($title, $toTipo, $newSlug, $images);
    file_put_contents($toPage, $html);

    return $newSlug;
}
