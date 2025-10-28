// Preloader handler
(function() {
    const preloader = document.querySelector('.preloader');
    if (!preloader) return;
    
    // Hide preloader when page is fully loaded
    window.addEventListener('load', () => {
        setTimeout(() => {
            preloader.classList.add('fade-out');
            setTimeout(() => {
                preloader.remove();
            }, 500);
        }, 300); // Small delay to ensure smooth transition
    });
    
    // Fallback: hide after max 5 seconds
    setTimeout(() => {
        if (preloader && !preloader.classList.contains('fade-out')) {
            preloader.classList.add('fade-out');
            setTimeout(() => preloader.remove(), 500);
        }
    }, 5000);
})();

document.addEventListener('DOMContentLoaded', () => {
    initScrollButton();
    initKeyboardNav();
    initBackLink();
    initTiltEffect();
    initWelcomeToast();
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

// 3D Tilt Effect on Cards
function initTiltEffect() {
    const cards = document.querySelectorAll('[data-tilt]');
    
    cards.forEach(card => {
        card.addEventListener('mousemove', (e) => {
            const rect = card.getBoundingClientRect();
            const x = e.clientX - rect.left;
            const y = e.clientY - rect.top;
            
            const centerX = rect.width / 2;
            const centerY = rect.height / 2;
            
            const rotateX = (y - centerY) / 10;
            const rotateY = (centerX - x) / 10;
            
            card.style.transform = `perspective(1000px) rotateX(${rotateX}deg) rotateY(${rotateY}deg) scale(1.02)`;
        });
        
        card.addEventListener('mouseleave', () => {
            card.style.transform = 'perspective(1000px) rotateX(0) rotateY(0) scale(1)';
        });
    });
}

// Welcome Toast
function initWelcomeToast() {
    const toast = document.getElementById('welcomeToast');
    if (!toast) return;
    
    // Auto-remove after animation
    setTimeout(() => {
        toast.remove();
    }, 4000);
}
