<?php
session_start();

const DATA_DIR = __DIR__ . '/data';
const TFA_FILE = DATA_DIR . '/2fa-config.json';
const ORDER_FILE = DATA_DIR . '/obras-order.json';

require_once __DIR__ . '/Pages/Auxiliares/obras-data.php';

$categories = [
    'Casas'      => [
        'imagesDir' => __DIR__ . '/images/Obras/Casas',
        'pagesDir'  => __DIR__ . '/Pages/Casas',
    ],
    'Industrias' => [
        // Imagens estao em Industriais, paginas em Industrias
        'imagesDir' => __DIR__ . '/images/Obras/Industriais',
        'pagesDir'  => __DIR__ . '/Pages/Industrias',
    ],
    'Outros'     => [
        'imagesDir' => __DIR__ . '/images/Obras/Outros',
        'pagesDir'  => __DIR__ . '/Pages/Outros',
    ],
    'Predios'    => [
        'imagesDir' => __DIR__ . '/images/Obras/Predios',
        'pagesDir'  => __DIR__ . '/Pages/Predios',
    ],
];

$method = $_SERVER['REQUEST_METHOD'] ?? 'GET';
$action = $_GET['action'] ?? '';

if (!isAdminWithTwofa()) {
    jsonResponse(['error' => 'unauthorized'], 401);
}

if ($method === 'GET' && $action === 'list') {
    $order = loadOrder();
    $data = [];
    foreach ($categories as $cat => $paths) {
        $data[$cat] = listWorks($cat, $paths['imagesDir'], $paths['pagesDir'], $order[$cat] ?? []);
    }
    jsonResponse(['ok' => true, 'categories' => $data]);
}

if ($method === 'POST') {
    $input = json_decode(file_get_contents('php://input'), true);
    if (!is_array($input)) {
        jsonResponse(['error' => 'invalid_body'], 400);
    }
    $tipo = isset($input['tipo']) ? (string) $input['tipo'] : '';
    if ($tipo === '' || !isset($categories[$tipo])) {
        jsonResponse(['error' => 'invalid_tipo'], 400);
    }
    $paths = $categories[$tipo];

    switch ($action) {
        case 'delete':
            $slug = isset($input['slug']) ? (string) $input['slug'] : '';
            if ($slug === '') jsonResponse(['error' => 'invalid_slug'], 400);
            deleteWork($slug, $paths);
            removeFromOrder($tipo, $slug);
            jsonResponse(['ok' => true]);
            break;

        case 'rename':
            $slug = isset($input['slug']) ? (string) $input['slug'] : '';
            $newName = isset($input['name']) ? trim((string)$input['name']) : '';
            if ($slug === '' || $newName === '') jsonResponse(['error' => 'invalid_params'], 400);
            $newSlug = renameWork($slug, $newName, $paths);
            updateOrderSlug($tipo, $slug, $newSlug);
            jsonResponse(['ok' => true, 'slug' => $newSlug, 'name' => $newName]);
            break;

        case 'reorder':
            $orderArr = isset($input['order']) && is_array($input['order']) ? $input['order'] : [];
            saveOrderForCategory($tipo, $orderArr);
            jsonResponse(['ok' => true]);
            break;

        case 'move':
            $from = $tipo;
            $to = isset($input['to']) ? (string)$input['to'] : '';
            $slug = isset($input['slug']) ? (string)$input['slug'] : '';
            if ($slug === '' || $to === '' || !isset($categories[$to])) {
                jsonResponse(['error' => 'invalid_params'], 400);
            }
            $newSlug = moveWork($slug, $categories[$from], $categories[$to]);
            removeFromOrder($from, $slug);
            addToOrder($to, $newSlug);
            jsonResponse(['ok' => true, 'slug' => $newSlug]);
            break;

        default:
            jsonResponse(['error' => 'invalid_action'], 400);
    }
}

http_response_code(405);
exit('method not allowed');

// ========= helpers =========
function jsonResponse(array $data, int $code = 200): void
{
    http_response_code($code);
    header('Content-Type: application/json');
    echo json_encode($data);
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
    if (empty($_SESSION['is_admin'])) {
        return false;
    }
    $cfg = loadTwofaConfig();
    if (twofaRequiredLocal($cfg) && empty($_SESSION['twofa_valid'])) {
        return false;
    }
    return true;
}

function loadOrder(): array
{
    if (!file_exists(ORDER_FILE)) return [];
    $data = json_decode((string) file_get_contents(ORDER_FILE), true);
    return is_array($data) ? $data : [];
}

function saveOrder(array $order): void
{
    if (!is_dir(DATA_DIR)) {
        mkdir(DATA_DIR, 0775, true);
    }
    file_put_contents(ORDER_FILE, json_encode($order, JSON_PRETTY_PRINT));
}

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
    $all[$tipo] = array_values(array_map(static function($s) use ($old, $new){
        return $s === $old ? $new : $s;
    }, $all[$tipo]));
    saveOrder($all);
}

function addToOrder(string $tipo, string $slug): void
{
    $all = loadOrder();
    if (!isset($all[$tipo])) {
        $all[$tipo] = [];
    }
    $all[$tipo][] = $slug;
    $all[$tipo] = array_values(array_unique($all[$tipo]));
    saveOrder($all);
}

function listWorks(string $category, string $imagesDir, string $pagesDir, array $order): array
{
    $works = loadWorksFromImages($imagesDir, $pagesDir, "../{$category}/");
    $bySlug = [];
    foreach ($works as $w) {
        $slug = basename($w['link'], '.html');
        $bySlug[$slug] = ['slug' => $slug, 'title' => $w['title'], 'page' => $w['link']];
    }
    $sorted = [];
    foreach ($order as $slug) {
        if (isset($bySlug[$slug])) {
            $sorted[] = $bySlug[$slug];
            unset($bySlug[$slug]);
        }
    }
    if ($bySlug) {
        uasort($bySlug, static fn($a, $b) => strcasecmp($a['title'], $b['title']));
        $sorted = array_merge($sorted, array_values($bySlug));
    }
    return $sorted;
}

function deleteDir(string $dir): void
{
    if (!is_dir($dir)) return;
    $items = array_diff(scandir($dir), ['.', '..']);
    foreach ($items as $item) {
        $path = $dir . DIRECTORY_SEPARATOR . $item;
        if (is_dir($path)) {
            deleteDir($path);
        } else {
            @unlink($path);
        }
    }
    @rmdir($dir);
}

function deleteWork(string $slug, array $paths): void
{
    $folder = rtrim($paths['imagesDir'], DIRECTORY_SEPARATOR) . DIRECTORY_SEPARATOR . $slug;
    $page   = rtrim($paths['pagesDir'], DIRECTORY_SEPARATOR) . DIRECTORY_SEPARATOR . $slug . '.html';
    if (is_dir($folder)) {
        deleteDir($folder);
    }
    if (file_exists($page)) {
        @unlink($page);
    }
}

function renameWork(string $slug, string $newName, array $paths): string
{
    $newSlug = slugify($newName);
    if ($newSlug === '') {
        $newSlug = 'obra';
    }
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

    if (is_dir($folder)) {
        @rename($folder, $newFolder);
    }
    if (file_exists($page)) {
        @rename($page, $newPage);
    }

    // regera HTML com o novo nome
    $images = collectImages($newFolder);
    $html = buildPageHtml($newName, basename($paths['imagesDir']), $newSlug, $images);
    file_put_contents($newPage, $html);

    return $newSlug;
}

function moveWork(string $slug, array $fromPaths, array $toPaths): string
{
    $fromFolder = rtrim($fromPaths['imagesDir'], DIRECTORY_SEPARATOR) . DIRECTORY_SEPARATOR . $slug;
    $fromPage   = rtrim($fromPaths['pagesDir'], DIRECTORY_SEPARATOR) . DIRECTORY_SEPARATOR . $slug . '.html';

    $title = humanizeSlug($slug);
    if (file_exists($fromPage)) {
        $html = file_get_contents($fromPage);
        $title = extractTitle($html, $title);
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
            if ($moved) {
                deleteDir($fromFolder);
            }
        }
    }

    if (!is_dir($toPaths['pagesDir'])) {
        mkdir($toPaths['pagesDir'], 0775, true);
    }
    if (file_exists($fromPage)) {
        if (!@rename($fromPage, $toPage)) {
            @copy($fromPage, $toPage);
            @unlink($fromPage);
        }
    }

    $images = collectImages($toFolder);
    $html = buildPageHtml($title, basename($toPaths['imagesDir']), $newSlug, $images);
    file_put_contents($toPage, $html);

    return $newSlug;
}
