# Backup HTML - 6 listopada 2025

## 📅 Data utworzenia
6 listopada 2025

## 📝 Opis
Backup poprawnych plików HTML po naprawie błędów:
- Usunięto duplikaty kart
- Poprawiono strukturę Bootstrap grid (row > col)
- Poprawiono URLe (kategoria, bez //)
- Zmieniono tytuły na opisowe

## 📦 Zawartość
- index.html
- desktopy.html
- informatyka.html
- TSiAI.html
- WiAI.html
- 404.html

## ✅ Stan
**POPRAWNE** - Wszystkie pliki działają bez błędów

## 🔄 Jak przywrócić
```powershell
# Przywróć wszystkie pliki
Copy-Item -Path "backups\html_backup_20251106\*.html" -Destination ".\" -Force

# Lub pojedynczy plik
Copy-Item -Path "backups\html_backup_20251106\desktopy.html" -Destination ".\desktopy.html" -Force
```

## 📊 Naprawione błędy
1. ✅ Duplikaty kart - usunięte
2. ✅ Bootstrap grid - wszystkie col w row
3. ✅ URLe - format https://prakt.dziadu.dev/{kategoria}/{sciezka}
4. ✅ Tytuły - opisowe zamiast "index", "zadanie1"
5. ✅ Spacje w URL - enkodowane jako %20

## ⚠️ Użyj tego backupu jeśli:
- Aplikacja w PyCharm zepsuje HTML
- Pojawią się duplikaty
- URLe będą złe
- Struktura Bootstrap się rozjedzie

## 💾 Backup utworzony po commitcie
Commit: [będzie wpisany po git commit]
Branch: main

---

**Ten backup zawiera POPRAWNĄ wersję HTML!**
**W razie problemów - przywróć z tego folderu.**
