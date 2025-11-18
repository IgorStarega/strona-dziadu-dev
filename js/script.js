document.addEventListener('DOMContentLoaded', () => {
    initScrollButton();
    initKeyboardNav();
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
