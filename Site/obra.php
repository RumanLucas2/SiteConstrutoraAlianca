<?php
session_start();

const DATA_DIR = __DIR__ . '/data';
const TFA_FILE = DATA_DIR . '/2fa-config.json';

require_once __DIR__ . '/Pages/Auxiliares/obras-data.php';

$categories = [
    'Casas'      => [
        'imagesDir' => __DIR__ . '/images/Obras/Casas',
        'pagesDir'  => __DIR__ . '/Pages/Casas',
        'linkBase'  => 'Pages/Casas'
    ],
    'Industrias' => [
        // As imagens estao em "Industriais" enquanto as paginas ficam em "Industrias"
        'imagesDir' => __DIR__ . '/images/Obras/Industriais',
        'pagesDir'  => __DIR__ . '/Pages/Industrias',
        'linkBase'  => 'Pages/Industrias'
    ],
    'Outros'     => [
        'imagesDir' => __DIR__ . '/images/Obras/Outros',
        'pagesDir'  => __DIR__ . '/Pages/Outros',
        'linkBase'  => 'Pages/Outros'
    ],
    'Predios'    => [
        'imagesDir' => __DIR__ . '/images/Obras/Predios',
        'pagesDir'  => __DIR__ . '/Pages/Predios',
        'linkBase'  => 'Pages/Predios'
    ],
];

if (($_SERVER['REQUEST_METHOD'] ?? '') !== 'POST') {
    http_response_code(405);
    exit('method not allowed');
}

if (!isAdminWithTwofa()) {
    jsonResponse(['error' => 'unauthorized'], 401);
}

$tipo = isset($_POST['tipo']) ? (string) $_POST['tipo'] : '';
$nome = isset($_POST['nome']) ? trim((string) $_POST['nome']) : '';

if ($tipo === '' || !isset($categories[$tipo])) {
    jsonResponse(['error' => 'invalid_tipo'], 400);
}
if ($nome === '') {
    jsonResponse(['error' => 'nome_required'], 400);
}
if (!isset($_FILES['fotos']) || empty($_FILES['fotos']['name'])) {
    jsonResponse(['error' => 'fotos_required'], 400);
}
$maxPhotos = 32;
$incomingCount = is_array($_FILES['fotos']['name']) ? count($_FILES['fotos']['name']) : 1;
if ($incomingCount > $maxPhotos) {
    jsonResponse(['error' => 'too_many_photos', 'max' => $maxPhotos], 400);
}

$slug = slugify($nome);
[$imagesDir, $pagesDir] = [$categories[$tipo]['imagesDir'], $categories[$tipo]['pagesDir']];

if (!is_dir($imagesDir) && !mkdir($imagesDir, 0775, true) && !is_dir($imagesDir)) {
    jsonResponse(['error' => 'cannot_create_category_dir'], 500);
}

$targetDir = $imagesDir . '/' . $slug;
$baseSlug = $slug;
$counter = 1;
while (is_dir($targetDir)) {
    $slug = $baseSlug . '-' . $counter;
    $targetDir = $imagesDir . '/' . $slug;
    $counter++;
}

if (!mkdir($targetDir, 0775, true) && !is_dir($targetDir)) {
    jsonResponse(['error' => 'cannot_create_target_dir'], 500);
}

$saved = saveUploadedImages($targetDir, $_FILES['fotos']);
if (empty($saved)) {
    jsonResponse(['error' => 'no_valid_images'], 400);
}

if (!is_dir($pagesDir) && !mkdir($pagesDir, 0775, true) && !is_dir($pagesDir)) {
    jsonResponse(['error' => 'cannot_create_pages_dir'], 500);
}

$images = collectImages($targetDir);
$html = buildPageHtml($nome, $tipo, $slug, $images);
$pagePath = $pagesDir . '/' . $slug . '.html';

file_put_contents($pagePath, $html);

cleanupOrphanPages($categories);

jsonResponse([
    'ok' => true,
    'slug' => $slug,
    'tipo' => $tipo,
    'page' => $categories[$tipo]['linkBase'] . '/' . $slug . '.html',
    'images' => count($images)
]);

// ========= Helpers =========
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
    if (empty($cfg['enabled']) || empty($cfg['provider'])) {
        return false;
    }
    if ($cfg['provider'] === 'totp') {
        return !empty($cfg['secret_hash']);
    }
    if ($cfg['provider'] === 'email') {
        return !empty($cfg['contact']);
    }
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

function slugify(string $name): string
{
    $converted = iconv('UTF-8', 'ASCII//TRANSLIT//IGNORE', $name);
    if ($converted !== false) {
        $name = $converted;
    }
    $name = strtolower($name);
    $name = preg_replace('/[^a-z0-9]+/i', '_', $name);
    $name = trim($name, '_');
    return $name !== '' ? $name : 'obra';
}

function saveUploadedImages(string $targetDir, array $files): array
{
    $allowed = ['jpg', 'jpeg', 'png', 'gif', 'webp', 'bmp'];
    $names = is_array($files['name']) ? $files['name'] : [$files['name']];
    $tmp   = is_array($files['tmp_name']) ? $files['tmp_name'] : [$files['tmp_name']];
    $errs  = is_array($files['error']) ? $files['error'] : [$files['error']];

    $saved = [];
    $usedNames = [];

    foreach ($names as $idx => $original) {
        if (($errs[$idx] ?? UPLOAD_ERR_NO_FILE) !== UPLOAD_ERR_OK) {
            continue;
        }
        $ext = strtolower(pathinfo($original, PATHINFO_EXTENSION));
        if (!in_array($ext, $allowed, true)) {
            continue;
        }

        $base = pathinfo($original, PATHINFO_FILENAME);
        $base = slugify($base);
        if ($base === '') {
            $base = 'img';
        }
        $finalName = $base . '.' . $ext;
        $counter = 1;
        while (in_array($finalName, $usedNames, true) || file_exists($targetDir . '/' . $finalName)) {
            $finalName = $base . '-' . $counter . '.' . $ext;
            $counter++;
        }

        $dest = $targetDir . '/' . $finalName;
        if (@move_uploaded_file($tmp[$idx], $dest)) {
            $saved[] = $finalName;
            $usedNames[] = $finalName;
        }
    }

    return $saved;
}

function cleanupOrphanPages(array $categories): void
{
    foreach ($categories as $category => $paths) {
        $pagesDir = $paths['pagesDir'] ?? '';
        $imagesDir = $paths['imagesDir'] ?? '';
        if (!$pagesDir || !is_dir($pagesDir)) {
            continue;
        }
        $pages = glob(rtrim($pagesDir, DIRECTORY_SEPARATOR) . DIRECTORY_SEPARATOR . '*.html');
        if (!$pages) {
            continue;
        }
        foreach ($pages as $htmlPath) {
            $slug = basename($htmlPath, '.html');
            $expectedFolder = rtrim($imagesDir, DIRECTORY_SEPARATOR) . DIRECTORY_SEPARATOR . $slug;
            if (!is_dir($expectedFolder)) {
                @unlink($htmlPath);
            }
        }
    }
}
