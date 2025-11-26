<?php
/**
 * Gera automaticamente as páginas de obras a partir das pastas de fotos em
 * images/Obras/{Casas, Industrias, Outros, Predios}.
 *
 * Uso: php generate-obras-pages.php
 */

$categories = [
    'Casas'       => [
        'imagesDir' => __DIR__ . '/../../images/Obras/Casas',
        'pagesDir'  => __DIR__ . '/../Casas',
    ],
    'Industrias'  => [
        'imagesDir' => __DIR__ . '/../../images/Obras/Industrias',
        'pagesDir'  => __DIR__ . '/../Industrias',
    ],
    'Outros'      => [
        'imagesDir' => __DIR__ . '/../../images/Obras/Outros',
        'pagesDir'  => __DIR__ . '/../Outros',
    ],
    'Predios'     => [
        'imagesDir' => __DIR__ . '/../../images/Obras/Predios',
        'pagesDir'  => __DIR__ . '/../Predios',
    ],
];

foreach ($categories as $category => $paths) {
    generateCategoryPages($category, $paths['imagesDir'], $paths['pagesDir']);
}

/**
 * Cria/atualiza as páginas HTML de uma categoria.
 */
function generateCategoryPages(string $category, string $imagesDir, string $pagesDir): void
{
    if (!is_dir($imagesDir)) {
        echo "Pasta de imagens não encontrada: {$imagesDir}\n";
        return;
    }

    if (!is_dir($pagesDir) && !mkdir($pagesDir, 0775, true) && !is_dir($pagesDir)) {
        echo "Não foi possível criar a pasta de páginas: {$pagesDir}\n";
        return;
    }

    $dirIterator = new DirectoryIterator($imagesDir);

    foreach ($dirIterator as $entry) {
        if ($entry->isDot() || !$entry->isDir()) {
            continue;
        }

        $slug = $entry->getFilename();
        $title = humanizeSlug($slug);
        $images = collectImages($entry->getPathname());

        if (empty($images)) {
            echo "Sem imagens em {$category}/{$slug}, pulando.\n";
            continue;
        }

        $html = buildPageHtml($title, $category, $slug, $images);
        $destPath = rtrim($pagesDir, DIRECTORY_SEPARATOR) . DIRECTORY_SEPARATOR . $slug . '.html';

        file_put_contents($destPath, $html);
        echo "Página gerada: {$destPath}\n";
    }
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
 * Retorna uma lista de imagens suportadas ordenada alfabeticamente.
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
 * Monta o HTML completo de uma página de obra.
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
                    <img alt="{$alt}" src="{$src}" />
                    <div class="portfolio_hover_area">
                        <a class="fancybox" href="{$src}" data-fancybox-group="gallery" title=""><span class="fa fa-search"></span></a>
                    </div>
                </div>
HTML;
    }

    return implode("\n", $blocks);
}
