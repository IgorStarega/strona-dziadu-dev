document.addEventListener('DOMContentLoaded', () => {
    initScrollButton();
    initKeyboardNav();
    initCollapseIcons();
});

function initScrollButton() {
    const btn = document.getElementById('scrollToTop');
    if (!btn) return;
    
    window.addEventListener('scroll', () => {
        if (window.scrollY > 300) {
            btn.style.display = 'block';
        } else {
            btn.style.display = 'none';
        }
    });
    
    btn.addEventListener('click', () => {
        window.scrollTo({ top: 0, behavior: 'smooth' });
    });
}

function initKeyboardNav() {
    const cards = document.querySelectorAll('.main-card, .link-card');
    cards.forEach((card, i) => {
        card.tabIndex = 0;
        
        card.addEventListener('keydown', (e) => {
            if (e.key === 'Enter' || e.key === ' ') {
                e.preventDefault();
                const link = card.querySelector('.stretched-link');
                if (link) link.click();
            }
        });
    });
}

function initCollapseIcons() {
    // Animacja collapse icon
    document.querySelectorAll('[data-bs-toggle="collapse"]').forEach(trigger => {
        trigger.addEventListener('click', function() {
            const icon = this.querySelector('.collapse-icon');
            const target = document.querySelector(this.dataset.bsTarget);
            
            target.addEventListener('shown.bs.collapse', () => {
                icon.style.transform = 'rotate(180deg)';
            });
            
            target.addEventListener('hidden.bs.collapse', () => {
                icon.style.transform = 'rotate(0deg)';
            });
        });
    });
}

/**
 * Pobiera całość przedmiotu przez backend PHP
 */
async function downloadFolder(folderName) {
    try {
        // Znajdź sekcję przedmiotu
        const section = document.querySelector(`[data-bs-target="#${folderName}"]`)?.closest('.subject-section');
        if (!section) {
            alert('Nie można znaleźć sekcji przedmiotu');
            return;
        }

        // Zbierz wszystkie linki z tej sekcji
        const anchors = Array.from(section.querySelectorAll('a.btn-view, a.btn-download-file'));
        const urls = anchors.map(a => a.href).filter(Boolean);

        if (!urls.length) {
            alert('Brak plików do pobrania');
            return;
        }

        console.log(`Przygotowywanie archiwum dla ${folderName} (${urls.length} plików)...`);

        // Wywołaj backend endpoint
        const params = new URLSearchParams({
            subject: folderName,
            subsection: 'wszystko',
            urls: JSON.stringify(urls)
        });

        window.location.href = `/download.php?${params.toString()}`;
    } catch (err) {
        console.error(err);
        alert('Wystąpił błąd podczas przygotowywania archiwum');
    }
}

/**
 * Pobiera podsekcję przez backend PHP (bez problemów CORS)
 */
async function downloadSubsection(subject, subsection) {
    try {
        const btns = Array.from(document.querySelectorAll('.btn-download-subsection'));
        const btn = btns.find(b => {
            const onclick = b.getAttribute('onclick') || '';
            return onclick.includes(`'${subject}'`) && onclick.includes(`'${subsection}'`);
        });

        if (!btn) {
            alert('Nie mogę znaleźć wybranej sekcji do pobrania.');
            return;
        }

        const folder = btn.closest('.folder-group') || btn.closest('.folder-subgroup');
        if (!folder) {
            alert('Struktura strony nie pozwala na identyfikację podsekcji.');
            return;
        }

        // Znajdź wszystkie linki do plików wewnątrz tej podsekcji
        const anchors = Array.from(folder.querySelectorAll('a.btn-view, a.btn-download-file'));
        const urls = anchors.map(a => a.href).filter(Boolean);

        if (!urls.length) {
            alert('Brak plików do pobrania w tej podsekcji.');
            return;
        }

        console.log(`Przygotowywanie archiwum ${subject}/${subsection} (${urls.length} plików)...`);

        // Wywołaj backend endpoint
        const params = new URLSearchParams({
            subject: subject.replace(/\//g, '-'),
            subsection: subsection,
            urls: JSON.stringify(urls)
        });

        // Przekieruj do endpointu - przeglądarka automatycznie pobierze ZIP
        window.location.href = `/download.php?${params.toString()}`;
    } catch (err) {
        console.error(err);
        alert('Wystąpił nieoczekiwany błąd podczas przygotowywania archiwum. Sprawdź konsolę.');
    }
}
