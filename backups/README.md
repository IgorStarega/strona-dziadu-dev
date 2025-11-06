# 💾 Backupy HTML

## 📁 Struktura

```
backups/
└── html_backup_20251106/     ← Backup poprawnego stanu (6 listopada 2025)
    ├── README.md             (opis backupu)
    ├── index.html
    ├── desktopy.html
    ├── informatyka.html
    ├── TSiAI.html
    ├── WiAI.html
    └── 404.html
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
