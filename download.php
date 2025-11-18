<?php
/**
 * Endpoint do pobierania archiwów ZIP
 * Obsługuje pobieranie sekcji i podsekcji
 */

header('Content-Type: application/json; charset=utf-8');

// Pobierz parametry
$subject = isset($_GET['subject']) ? $_GET['subject'] : '';
$subsection = isset($_GET['subsection']) ? $_GET['subsection'] : '';
$urls = isset($_GET['urls']) ? $_GET['urls'] : '';

// Walidacja
if (empty($urls)) {
    http_response_code(400);
    die(json_encode(['error' => 'Brak parametru urls']));
}

// Parsuj URLs
$urlList = json_decode($urls, true);
if (!is_array($urlList) || count($urlList) === 0) {
    http_response_code(400);
    die(json_encode(['error' => 'Nieprawidłowy format URLs']));
}

// Nazwa archiwum
$zipName = $subject ? ($subject . '-' . $subsection) : 'archiwum';
$zipName = preg_replace('/[^a-z0-9\-_]/i', '_', $zipName);
$zipFilename = $zipName . '.zip';

// Utwórz tymczasowy katalog
$tempDir = sys_get_temp_dir() . '/' . uniqid('zip_');
if (!mkdir($tempDir, 0777, true)) {
    http_response_code(500);
    die(json_encode(['error' => 'Nie można utworzyć katalogu tymczasowego']));
}

$zipPath = $tempDir . '/' . $zipFilename;

// Utwórz archiwum ZIP
$zip = new ZipArchive();
if ($zip->open($zipPath, ZipArchive::CREATE | ZipArchive::OVERWRITE) !== true) {
    http_response_code(500);
    die(json_encode(['error' => 'Nie można utworzyć archiwum ZIP']));
}

// Pobierz każdy plik i dodaj do archiwum
$errors = [];
foreach ($urlList as $url) {
    // Wyznacz nazwę pliku z URL
    $filename = basename(parse_url($url, PHP_URL_PATH));
    if (empty($filename)) {
        $filename = 'file';
    }
    
    // Usuń query string z nazwy
    $filename = preg_replace('/\?.*$/', '', $filename);
    
    // Pobierz zawartość pliku
    $context = stream_context_create([
        'http' => [
            'timeout' => 30,
            'user_agent' => 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36'
        ]
    ]);
    
    $content = @file_get_contents($url, false, $context);
    
    if ($content === false) {
        $errors[] = $url;
        continue;
    }
    
    // Dodaj do archiwum
    $zip->addFromString($filename, $content);
}

$zip->close();

// Jeśli wszystkie pliki się nie powiodły
if (count($errors) === count($urlList)) {
    unlink($zipPath);
    rmdir($tempDir);
    http_response_code(500);
    die(json_encode(['error' => 'Nie udało się pobrać żadnego pliku', 'failed_urls' => $errors]));
}

// Wyślij archiwum do przeglądarki
header('Content-Type: application/zip');
header('Content-Disposition: attachment; filename="' . $zipFilename . '"');
header('Content-Length: ' . filesize($zipPath));
header('Pragma: public');
header('Cache-Control: must-revalidate, post-check=0, pre-check=0');

readfile($zipPath);

// Usuń pliki tymczasowe
unlink($zipPath);
rmdir($tempDir);

exit;
