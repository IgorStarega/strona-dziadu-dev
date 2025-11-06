# Szybki backup z walidacją - uruchom raz
# Użycie: .\quick-backup.ps1

Write-Host "`n========================================" -ForegroundColor Cyan
Write-Host "  SZYBKI BACKUP Z WALIDACJĄ" -ForegroundColor Cyan
Write-Host "========================================`n" -ForegroundColor Cyan

# Walidacja
Write-Host "[1/3] Walidacja HTML..." -ForegroundColor Yellow

$errors = @()

# Sprawdź każdy plik HTML
$htmlFiles = Get-ChildItem -Path "." -Filter "*.html"
foreach ($file in $htmlFiles) {
    $content = Get-Content $file.FullName -Raw
    
    # Test: podwójne slashe
    if ($content -match 'prakt\.dziadu\.dev//') {
        $errors += "$($file.Name): Podwójne slashe w URL"
    }
    
    # Test: niezamknięte tagi div
    $openDivs = ([regex]::Matches($content, '<div')).Count
    $closeDivs = ([regex]::Matches($content, '</div>')).Count
    if ($openDivs -ne $closeDivs) {
        $errors += "$($file.Name): Niezrównoważone <div> ($openDivs otwartych, $closeDivs zamkniętych)"
    }
}

if ($errors.Count -gt 0) {
    Write-Host "`n❌ BŁĘDY WALIDACJI - backup anulowany!" -ForegroundColor Red
    foreach ($error in $errors) {
        Write-Host "   • $error" -ForegroundColor Red
    }
    Write-Host ""
    exit 1
}

Write-Host "   ✅ Wszystkie pliki poprawne`n" -ForegroundColor Green

# Backup
Write-Host "[2/3] Tworzenie backupu..." -ForegroundColor Yellow

$timestamp = Get-Date -Format "yyyyMMdd_HHmmss"
$backupFolder = "backups\html_backup_$timestamp"

New-Item -Path $backupFolder -ItemType Directory -Force | Out-Null
Copy-Item -Path "*.html" -Destination $backupFolder -Force

Write-Host "   ✅ Backup utworzony: $backupFolder`n" -ForegroundColor Green

# Czyszczenie starych
Write-Host "[3/3] Czyszczenie starych backupów..." -ForegroundColor Yellow

$backups = Get-ChildItem -Path "backups" -Directory | 
    Where-Object { $_.Name -match 'html_backup_\d{8}_\d{6}' } |
    Sort-Object Name -Descending

if ($backups.Count -gt 10) {
    $toDelete = $backups | Select-Object -Skip 10
    foreach ($backup in $toDelete) {
        Remove-Item -Path $backup.FullName -Recurse -Force
    }
    Write-Host "   ✅ Usunięto $($toDelete.Count) starych backupów`n" -ForegroundColor Green
} else {
    Write-Host "   ✅ Wszystkie backupy zachowane ($($backups.Count)/10)`n" -ForegroundColor Green
}

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  ✅ GOTOWE!" -ForegroundColor Green
Write-Host "========================================`n" -ForegroundColor Cyan
