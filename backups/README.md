# 💾 Backupy HTML

## 🤖 Automatyczny backup z walidacją

### Użycie:

```powershell
# Szybki backup (jednorazowy)
.\quick-backup.ps1

# Automatyczny co 30 minut (domyślnie)
.\auto-backup.ps1

# Automatyczny co X minut
.\auto-backup.ps1 -intervalMinutes 60

# Jednorazowy backup (bez pętli)
.\auto-backup.ps1 -runOnce
```

### Co robi skrypt:
1. ✅ **Waliduje HTML** - sprawdza błędy (duplikaty, URLe, tagi)
2. ✅ **Tworzy backup** - TYLKO jeśli walidacja przeszła
3. ✅ **Czyści stare** - zachowuje ostatnie 10 backupów

### Walidacja sprawdza:
- ❌ Podwójne slashe w URL (`//`)
- ❌ Niezamknięte tagi `<div>`
- ❌ Brak podstawowych tagów HTML
- ⚠️  Col poza row (ostrzeżenie)

---

## 📁 Struktura

```
backups/
├── html_backup_20251106/          ← Manualny backup
└── html_backup_20251106_143022/   ← Automatyczny backup
    ├── README.md
    └── *.html (wszystkie pliki)
```

## 🔄 Jak przywrócić backup

### Wszystkie pliki naraz:
```powershell
Copy-Item -Path "backups\html_backup_20251106\*.html" -Destination ".\" -Force
```

### Pojedynczy plik:
```powershell
Copy-Item -Path "backups\html_backup_20251106\desktopy.html" -Destination ".\desktopy.html" -Force
```

## ⚠️ Kiedy użyć backupu?

Przywróć backup jeśli aplikacja w PyCharm:
- ❌ Utworzyła duplikaty kart
- ❌ Zepsóła strukturę Bootstrap (col poza row)
- ❌ Zepsóła URLe (brak kategorii, podwójne //)
- ❌ Zmieniła tytuły na generyczne

## 📊 Stan backupów

| Data | Folder | Status | Opis |
|------|--------|--------|------|
| 6 listopada 2025 | `html_backup_20251106` | ✅ POPRAWNY | Po naprawie wszystkich błędów |

## 🔧 Tworzenie nowego backupu

```powershell
# Utwórz folder z datą
$date = Get-Date -Format "yyyyMMdd"
New-Item -Path "backups\html_backup_$date" -ItemType Directory

# Skopiuj pliki
Copy-Item -Path "*.html" -Destination "backups\html_backup_$date\" -Force
```

---

**Zawsze rób backup przed uruchomieniem aplikacji generującej HTML!**
