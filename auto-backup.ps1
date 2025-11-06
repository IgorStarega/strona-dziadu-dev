# Automatyczny backup HTML z walidacją
# Uruchamia się co X minut i robi backup tylko jeśli HTML jest poprawny

param(
    [int]$intervalMinutes = 30,  # Co ile minut robić backup (domyślnie 30)
    [switch]$runOnce          # Uruchom raz zamiast w pętli
)

# Kolory
$ColorOK = "Green"
$ColorWarn = "Yellow"
$ColorError = "Red"
$ColorInfo = "Cyan"

function Write-Status {
    param([string]$message, [string]$color = "White")
    $timestamp = Get-Date -Format "HH:mm:ss"
    Write-Host "[$timestamp] $message" -ForegroundColor $color
}

function Test-HTMLValidity {
    param([string]$filePath)
    
    $errors = @()
    $warnings = @()
    
    if (-not (Test-Path $filePath)) {
        return @{
            IsValid = $false
            Errors = @("Plik nie istnieje: $filePath")
            Warnings = @()
        }
    }
    
    $content = Get-Content $filePath -Raw -Encoding UTF8
    
    # Test 1: Czy są podwójne slashe w URL
    if ($content -match 'prakt\.dziadu\.dev//') {
        $errors += "Znaleziono podwójne slashe (//) w URL"
    }
    
    # Test 2: Czy są niezamknięte tagi
    $openDivs = ([regex]::Matches($content, '<div')).Count
    $closeDivs = ([regex]::Matches($content, '</div>')).Count
    if ($openDivs -ne $closeDivs) {
        $errors += "Niezrównoważone tagi <div>: $openDivs otwartych, $closeDivs zamkniętych"
    }
    
    # Test 3: Czy col jest w row (uproszczone)
    # Sprawdź czy nie ma col bez poprzedzającego row
    $lines = $content -split "`n"
    $inRow = $false
    $lineNum = 0
    foreach ($line in $lines) {
        $lineNum++
        if ($line -match '<div[^>]*class="[^"]*row[^"]*"') {
            $inRow = $true
        }
        if ($line -match '</div>' -and $inRow) {
            # Sprawdź czy to koniec row
            if ($line -match 'row') {
                $inRow = $false
            }
        }
        if ($line -match '<div[^>]*class="[^"]*col-[^"]*"' -and -not $inRow) {
            $warnings += "Linia $lineNum : col poza row (może być fałszywy alarm)"
        }
    }
    
    # Test 4: Podstawowe tagi HTML
    if ($content -notmatch '<!DOCTYPE html>') {
        $warnings += "Brak deklaracji DOCTYPE"
    }
    if ($content -notmatch '<html') {
        $errors += "Brak tagu <html>"
    }
    if ($content -notmatch '</html>') {
        $errors += "Brak zamknięcia </html>"
    }
    
    # Test 5: Sprawdź czy są jakieś karty (podstawowa weryfikacja zawartości)
    if ($content -notmatch 'card') {
        $warnings += "Brak kart Bootstrap w HTML (może to być strona bez kart)"
    }
    
    return @{
        IsValid = ($errors.Count -eq 0)
        Errors = $errors
        Warnings = $warnings
    }
}

function Test-AllHTMLFiles {
    Write-Status "Rozpoczynam walidację plików HTML..." $ColorInfo
    
    $htmlFiles = Get-ChildItem -Path "." -Filter "*.html" | Where-Object { 
        $_.Name -ne "404.html"  # 404 może mieć inną strukturę
    }
    
    $allValid = $true
    $results = @{}
    
    foreach ($file in $htmlFiles) {
        Write-Status "  Sprawdzam: $($file.Name)..." "White"
        $result = Test-HTMLValidity -filePath $file.FullName
        $results[$file.Name] = $result
        
        if ($result.IsValid) {
            Write-Status "    ✅ OK" $ColorOK
        } else {
            Write-Status "    ❌ BŁĘDY!" $ColorError
            $allValid = $false
            foreach ($error in $result.Errors) {
                Write-Status "       • $error" $ColorError
            }
        }
        
        if ($result.Warnings.Count -gt 0) {
            foreach ($warning in $result.Warnings) {
                Write-Status "       ⚠ $warning" $ColorWarn
            }
        }
    }
    
    return @{
        IsValid = $allValid
        Results = $results
    }
}

function Create-Backup {
    $timestamp = Get-Date -Format "yyyyMMdd_HHmmss"
    $backupFolder = "backups\html_backup_$timestamp"
    
    Write-Status "Tworzę backup: $backupFolder" $ColorInfo
    
    # Utwórz folder
    New-Item -Path $backupFolder -ItemType Directory -Force | Out-Null
    
    # Skopiuj pliki HTML
    $htmlFiles = Get-ChildItem -Path "." -Filter "*.html"
    foreach ($file in $htmlFiles) {
        Copy-Item -Path $file.FullName -Destination $backupFolder -Force
        Write-Status "  ✅ Skopiowano: $($file.Name)" $ColorOK
    }
    
    # Utwórz README
    $readmeContent = @"
# Backup HTML - $(Get-Date -Format "yyyy-MM-dd HH:mm:ss")

## 📅 Data utworzenia
$(Get-Date -Format "yyyy-MM-dd HH:mm:ss")

## 📝 Opis
Automatyczny backup utworzony przez skrypt auto-backup.ps1

## ✅ Walidacja
Wszystkie pliki HTML przeszły walidację przed backupem.

## 📦 Zawartość
$($htmlFiles | ForEach-Object { "- $($_.Name)" } | Out-String)

## 🔄 Jak przywrócić
``````powershell
# Przywróć wszystkie pliki
Copy-Item -Path "$backupFolder\*.html" -Destination ".\" -Force

# Lub pojedynczy plik
Copy-Item -Path "$backupFolder\desktopy.html" -Destination ".\desktopy.html" -Force
``````

---

**Backup automatyczny - walidacja przeszła pomyślnie**
"@
    
    $readmeContent | Out-File -FilePath "$backupFolder\README.md" -Encoding UTF8
    
    Write-Status "✅ Backup utworzony: $backupFolder" $ColorOK
    return $backupFolder
}

function Clean-OldBackups {
    param([int]$keepLast = 10)  # Zachowaj ostatnie 10 backupów
    
    $backups = Get-ChildItem -Path "backups" -Directory | 
        Where-Object { $_.Name -match 'html_backup_\d{8}_\d{6}' } |
        Sort-Object Name -Descending
    
    if ($backups.Count -gt $keepLast) {
        $toDelete = $backups | Select-Object -Skip $keepLast
        foreach ($backup in $toDelete) {
            Write-Status "🗑️  Usuwam stary backup: $($backup.Name)" $ColorWarn
            Remove-Item -Path $backup.FullName -Recurse -Force
        }
    }
}

function Start-AutoBackup {
    Write-Host ""
    Write-Host "========================================" -ForegroundColor $ColorInfo
    Write-Host "  AUTOMATYCZNY BACKUP HTML" -ForegroundColor $ColorInfo
    Write-Host "========================================" -ForegroundColor $ColorInfo
    Write-Host ""
    Write-Status "Interwał: co $intervalMinutes minut" $ColorInfo
    Write-Status "Tryb: $(if($runOnce){'Jednorazowy'}else{'Ciągły'})" $ColorInfo
    Write-Status "Naciśnij Ctrl+C aby zatrzymać" $ColorWarn
    Write-Host ""
    
    $iteration = 0
    
    do {
        $iteration++
        Write-Host "========================================" -ForegroundColor $ColorInfo
        Write-Status "Iteracja #$iteration" $ColorInfo
        Write-Host ""
        
        # Walidacja
        $validation = Test-AllHTMLFiles
        
        Write-Host ""
        
        if ($validation.IsValid) {
            Write-Status "✅ Walidacja przeszła - tworzę backup" $ColorOK
            $backupFolder = Create-Backup
            Clean-OldBackups -keepLast 10
            
            Write-Host ""
            Write-Status "✅ Backup zakończony pomyślnie!" $ColorOK
        } else {
            Write-Status "❌ Walidacja nie powiodła się - POMIJAM backup!" $ColorError
            Write-Status "⚠️  Napraw błędy przed następnym backupem" $ColorWarn
        }
        
        if (-not $runOnce) {
            Write-Host ""
            Write-Status "Następny backup za $intervalMinutes minut..." $ColorInfo
            Write-Status "Oczekiwanie... (Ctrl+C aby przerwać)" "Gray"
            Start-Sleep -Seconds ($intervalMinutes * 60)
        }
        
    } while (-not $runOnce)
}

# Sprawdź czy jesteśmy w odpowiednim folderze
if (-not (Test-Path "backups")) {
    Write-Status "Tworzę folder backups..." $ColorInfo
    New-Item -Path "backups" -ItemType Directory | Out-Null
}

# Uruchom
try {
    Start-AutoBackup
} catch {
    Write-Status "❌ Błąd: $_" $ColorError
    exit 1
}
