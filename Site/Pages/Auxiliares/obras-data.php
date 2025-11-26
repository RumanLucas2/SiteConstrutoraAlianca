<?php
// Helper para montar dados das obras e gerar paginas automaticamente.

/**
 * Le paginas HTML ja existentes.
 *
 * @param string $pagesDir   Caminho absoluto ate a pasta com os HTMLs da categoria.
 * @param string $linkPrefix Prefixo de link relativo (ex.: "../Casas/").
 * @return array<int, array{title:string, link:string, cover:?string}>
 */
function loadWorksFromPages(string $pagesDir, string $linkPrefix): array
{
    $works = [];
    $files = glob(rtrim($pagesDir, DIRECTORY_SEPARATOR) . DIRECTORY_SEPARATOR . '*.html');

    foreach ($files as $filePath) {
        $html = @file_get_contents($filePath);
        if ($html === false) {
            continue;
        }

        $slug = basename($filePath, '.html');
        $title = extractTitle($html, $slug);
        $cover = extractCover($html);

        $works[] = [
            'slug'  => $slug,
            'title' => $title,
            'link'  => $linkPrefix . $slug . '.html',
            'cover' => $cover,
        ];
    }

    return applyOrderOrAlpha($works, basename($pagesDir));
}

/**
 * Novo modo: varre pastas de imagens (images/Obras/<Categoria>/<Slug>) e gera
 * as paginas HTML se ainda nao existirem.
 *
 * @param string $imagesDir  Caminho absoluto ate a pasta da categoria em images/Obras.
 * @param string $pagesDir   Caminho absoluto ate a pasta onde ficam as paginas HTML.
 * @param string $linkPrefix Prefixo de link relativo (ex.: "../Casas/").
 * @return array<int, array{title:string, link:string, cover:?string}>
 */
function loadWorksFromImages(string $imagesDir, string $pagesDir, string $linkPrefix): array
{
    $works = [];
    if (!is_dir($imagesDir)) {
        return $works;
    }

    $categoryFolder = basename($imagesDir);
    $iterator = new DirectoryIterator($imagesDir);

    foreach ($iterator as $entry) {
        if ($entry->isDot() || !$entry->isDir()) {
            continue;
        }

        $slug = $entry->getFilename();
        $title = humanizeSlug($slug);
        $images = collectImages($entry->getPathname());
        if (empty($images)) {
            continue;
        }

        $cover = chooseCover($images);
        $coverUrl = '../../images/Obras/' . rawurlencode($categoryFolder) . '/' . rawurlencode($slug) . '/' . rawurlencode($cover);

        $pagePath = rtrim($pagesDir, DIRECTORY_SEPARATOR) . DIRECTORY_SEPARATOR . $slug . '.html';
        if (!file_exists($pagePath)) {
            $html = buildPageHtml($title, $categoryFolder, $slug, $images);
            @file_put_contents($pagePath, $html);
        }

        $works[] = [
            'slug'  => $slug,
            'title' => $title,
            'link'  => $linkPrefix . $slug . '.html',
            'cover' => $coverUrl,
        ];
    }

    // Usa o nome da pasta de paginas (quando existir) para cruzar com o JSON de ordem.
    $orderKey = basename($pagesDir) ?: $categoryFolder;
    return applyOrderOrAlpha($works, $orderKey);
}

/**
 * Ordena conforme o JSON de ordem (Site/data/obras-order.json). Se nao houver
 * ordem para a categoria, cai no alfabeto.
 *
 * @param array<int, array{slug:string,title:string,link:string,cover:?string}> $works
 * @param string $category
 * @return array<int, array{slug:string,title:string,link:string,cover:?string}>
 */
function applyOrderOrAlpha(array $works, string $category): array
{
    $orderMap = loadOrderMap();
    $orderList = $orderMap[$category] ?? null;

    if (is_array($orderList) && $orderList) {
        $positions = [];
        foreach ($orderList as $idx => $slug) {
            $positions[strtolower((string) $slug)] = $idx;
        }

        usort(
            $works,
            static function (array $a, array $b) use ($positions): int {
                $sa = strtolower($a['slug'] ?? '');
                $sb = strtolower($b['slug'] ?? '');
                $pa = $positions[$sa] ?? PHP_INT_MAX;
                $pb = $positions[$sb] ?? PHP_INT_MAX;

                if ($pa === $pb) {
                    return strcasecmp($a['title'], $b['title']);
                }

                return $pa <=> $pb;
            }
        );
        return $works;
    }

    usort(
        $works,
        static function (array $a, array $b): int {
            return strcasecmp($a['title'], $b['title']);
        }
    );

    return $works;
}

/**
 * Carrega e memoiza o mapa de ordem do arquivo data/obras-order.json.
 *
 * @return array<string, array<int, string>>
 */
function loadOrderMap(): array
{
    static $cache = null;
    if (is_array($cache)) {
        return $cache;
    }

    $path = __DIR__ . '/../../data/obras-order.json';
    if (!is_file($path)) {
        $cache = [];
        return $cache;
    }

    $json = @file_get_contents($path);
    $data = json_decode((string) $json, true);
    $cache = is_array($data) ? $data : [];
    return $cache;
}

/**
 * Busca o primeiro <h2> da pagina para usar como titulo.
 */
function extractTitle(string $html, string $fallback): string
{
    if (preg_match('/<h2[^>]*>(.*?)<\\/h2>/is', $html, $matches)) {
        return trim(strip_tags(html_entity_decode($matches[1], ENT_QUOTES, 'ISO-8859-1')));
    }

    $readableFallback = str_replace('_', ' ', $fallback);
    return ucwords($readableFallback);
}

/**
 * Usa a primeira imagem que contenha "capa" no nome; se nao houver,
 * cai na primeira imagem da pagina.
 */
function extractCover(string $html): ?string
{
    if (preg_match('/<img[^>]+src=["\']([^"\']*capa[^"\']*)["\']/i', $html, $matches)) {
        return $matches[1];
    }

    if (preg_match('/<img[^>]+src=["\']([^"\']+)["\']/i', $html, $matches)) {
        return $matches[1];
    }

    return null;
}

/**
 * Transforma "Golfe_02" em "Golfe 02" e separa camelCase.
 */
function humanizeSlug(string $slug): string
{
    $name = str_replace('_', ' ', $slug);
    $name = preg_replace('/(?<!^)([A-Z][a-z])/', ' $1', $name);
    $name = preg_replace('/\\s+/', ' ', $name);

    return trim($name);
}

/**
 * Retorna lista de imagens de uma pasta.
 */
function collectImages(string $folder): array
{
    $images = [];
    $iterator = new DirectoryIterator($folder);

    foreach ($iterator as $fileinfo) {
        if ($fileinfo->isDot() || !$fileinfo->isFile()) {
            continue;
        }

        $ext = strtolower($fileinfo->getExtension());
        if (!in_array($ext, ['jpg', 'jpeg', 'png', 'gif', 'webp', 'bmp'], true)) {
            continue;
        }

        $images[] = $fileinfo->getFilename();
    }

    natcasesort($images);

    return array_values($images);
}

/**
 * Escolhe a capa priorizando arquivos que contenham "capa".
 */
function chooseCover(array $images): string
{
    foreach ($images as $image) {
        if (stripos($image, 'capa') !== false) {
            return $image;
        }
    }

    return $images[0];
}

/**
 * Monta o HTML completo de uma pagina de obra.
 */
function buildPageHtml(string $title, string $category, string $slug, array $images): string
{
    $titleEsc = htmlspecialchars($title, ENT_QUOTES, 'ISO-8859-1');
    $gallery = buildGalleryHtml($category, $slug, $images);

    return <<<HTML
<!DOCTYPE html>
<!--[if IE 8]> <html lang="pt-br" class="ie8"> <![endif]-->
<!--[if !IE]><!-->
<html lang="pt-br"> <!--<![endif]-->
<head>
    <meta charset="iso-8859-1">
    <title>Construtora Alian&ccedil;a</title>
    <link href="../../images/logo_mini.ico" rel="icon" type="image/x-icon" />
    <script type="application/ld+json">
        {
          "@context": "https://schema.org",
          "@type": "Organization",
          "url": "https://construtoralianca.com.br",
          "logo": "https://construtoralianca.com.br/images/logo_mini.ico"
        }
    </script>
    <meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1">
    <link href="../../custom-font/fonts.css" rel="stylesheet" />
    <link href="../../css/bootstrap.min.css" rel="stylesheet" />
    <link href="../../css/font-awesome.min.css" rel="stylesheet" />
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/7.0.0/css/all.min.css">
    <link href="../../css/bootsnav.css" rel="stylesheet" />
    <link href="../../css/jquery.fancybox.css?v=2.1.5" media="screen" rel="stylesheet" type="text/css" />
    <link href="../../css/custom.css" rel="stylesheet" />
</head>
<body>
    <div id="loading">
        <div id="loading-center">
            <div id="loading-center-absolute">
                <div class="object"></div><div class="object"></div><div class="object"></div><div class="object"></div><div class="object"></div>
                <div class="object"></div><div class="object"></div><div class="object"></div><div class="object"></div><div class="object"></div>
            </div>
        </div>
    </div>

    <div id="header"></div>

    <section id="portfolio">
        <div class="container portfolio_area text-center">
            <h2>{$titleEsc}</h2>
            <div class="grid">
                <div class="grid-sizer"></div>
                {$gallery}
            </div>
        </div>
    </section>

    <div id="footer"></div>
    <script src="../../js/jquery-1.12.1.min.js"></script>
    <script src="../../js/bootstrap.min.js"></script>
    <script src="../../js/bootsnav.js"></script>
    <script src="../../js/isotope.js"></script>
    <script src="../../js/isotope-active.js"></script>
    <script src="../../js/jquery.fancybox.js?v=2.1.5"></script>
    <script src="../../js/jquery.scrollUp.min.js"></script>
    <script src="../../js/main.js"></script>
    <script src="../../js/includeHeader.js"></script>
    <script src="../../js/IncludeFooter.js"></script>
</body>
</html>
HTML;
}

/**
 * Monta os blocos da galeria com Fancybox.
 */
function buildGalleryHtml(string $category, string $slug, array $images): string
{
    $blocks = [];
    $basePath = "../../images/Obras/{$category}/{$slug}";

    foreach ($images as $image) {
        $src = "{$basePath}/" . rawurlencode($image);
        $alt = htmlspecialchars(pathinfo($image, PATHINFO_FILENAME), ENT_QUOTES, 'ISO-8859-1');

        $blocks[] = <<<HTML
                <div class="grid-item">
                    <div class="thumb">
                        <img alt="{$alt}" src="{$src}" />
                        <div class="portfolio_hover_area">
                            <a class="fancybox" href="{$src}" data-fancybox-group="gallery" title=""><span class="fa fa-search"></span></a>
                        </div>
                    </div>
                </div>
HTML;
    }

    return implode("\n", $blocks);
}
