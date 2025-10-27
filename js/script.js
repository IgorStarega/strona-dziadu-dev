window.addEventListener('load', () => {
    const preloader = document.querySelector('.preloader');
    if (preloader) {
        preloader.classList.add('fade-out');
        setTimeout(() => preloader.remove(), 500);
    }
});

document.addEventListener('DOMContentLoaded', () => {
    initScrollButton();
    initKeyboardNav();
    initBackLink();
});

function initScrollButton() {
    const btn = document.getElementById('scrollToTop');
    if (!btn) return;
    
    window.addEventListener('scroll', () => {
        btn.classList.toggle('d-none', window.scrollY < 300);
    }, { passive: true });
    
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
                card.click();
            }
            if (e.key === 'ArrowRight' && i < cards.length - 1) {
                e.preventDefault();
                cards[i + 1].focus();
            }
            if (e.key === 'ArrowLeft' && i > 0) {
                e.preventDefault();
                cards[i - 1].focus();
            }
        });
    });
}

function initBackLink() {
    const link = document.querySelector('.back-link');
    if (link && document.referrer.includes(location.hostname)) {
        link.addEventListener('click', (e) => {
            e.preventDefault();
            history.back();
        });
    }
    
    document.addEventListener('keydown', (e) => {
        if (e.key === 'Escape' && link) location.href = link.href;
    });
}
