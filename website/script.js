/* ========================================
   Alternative Assets Literacy — Landing Page
   Brutalist scroll-driven animation + interactions
   ======================================== */

(function () {
    'use strict';

    var prefersReducedMotion = window.matchMedia('(prefers-reduced-motion: reduce)').matches;

    // Dynamic mobile check — viewport may resize after initial load
    function isMobile() {
        return window.innerWidth <= 768;
    }

    // --- Scroll Stage Animation (desktop only) ---
    var scrollStage = document.getElementById('scroll-stage');
    var stagePainting = document.getElementById('stage-painting');
    var stagePhone = document.getElementById('stage-phone');
    var stageTitle = document.getElementById('stage-title');
    var stageTagline = document.getElementById('stage-tagline');
    var navbar = document.getElementById('navbar');

    function getScrollProgress() {
        if (!scrollStage) return 1;
        var rect = scrollStage.getBoundingClientRect();
        var stageHeight = scrollStage.offsetHeight - window.innerHeight;
        if (stageHeight <= 0) return 1;
        var scrolled = -rect.top;
        return Math.max(0, Math.min(1, scrolled / stageHeight));
    }

    function lerp(start, end, t) {
        return start + (end - start) * t;
    }

    function updateScrollAnimation() {
        if (isMobile() || prefersReducedMotion) return;

        var progress = getScrollProgress();

        // --- Painting: fade out from 0.3 to 0.6 ---
        if (stagePainting) {
            if (progress <= 0.3) {
                stagePainting.style.opacity = '1';
            } else if (progress <= 0.6) {
                var paintingFade = (progress - 0.3) / 0.3;
                stagePainting.style.opacity = String(1 - paintingFade);
            } else {
                stagePainting.style.opacity = '0';
            }
        }

        // --- Phone: fade in from 0.3 to 0.6 ---
        if (stagePhone) {
            if (progress <= 0.3) {
                stagePhone.style.opacity = '0';
            } else if (progress <= 0.6) {
                var phoneFade = (progress - 0.3) / 0.3;
                stagePhone.style.opacity = String(phoneFade);
            } else {
                stagePhone.style.opacity = '1';
            }
        }

        // --- Title: stays large center (0-0.5), then shrinks + moves to navbar (0.5-0.95) ---
        if (stageTitle) {
            if (progress <= 0.5) {
                // Large, centered — sized to fit viewport
                stageTitle.style.fontSize = '7vw';
                stageTitle.style.top = '50%';
                stageTitle.style.left = '50%';
                stageTitle.style.transform = 'translate(-50%, -50%)';
                stageTitle.style.opacity = '1';
            } else if (progress <= 0.95) {
                // Shrinking and moving to upper-left
                var shrinkProgress = (progress - 0.5) / 0.45;
                var eased = shrinkProgress * shrinkProgress; // ease-in for snappy feel

                // Font size: 7vw → 1.2vw (approx 1.125rem at 1080px viewport)
                var startSize = 7; // vw
                var endSize = 1.2; // vw
                var currentSize = lerp(startSize, endSize, eased);
                stageTitle.style.fontSize = currentSize + 'vw';

                // Position: center → upper-left (navbar brand position)
                var startTop = 50; // %
                var endTop = 2.5; // % (approx 32px from top on 100vh)
                var startLeft = 50; // %
                var endLeft = 2; // % (approx 24px from left)

                var currentTop = lerp(startTop, endTop, eased);
                var currentLeft = lerp(startLeft, endLeft, eased);

                // Transform: translate(-50%, -50%) → translate(0, 0)
                var translateX = lerp(-50, 0, eased);
                var translateY = lerp(-50, 0, eased);

                stageTitle.style.top = currentTop + '%';
                stageTitle.style.left = currentLeft + '%';
                stageTitle.style.transform = 'translate(' + translateX + '%, ' + translateY + '%)';
                stageTitle.style.opacity = String(1 - eased * 0.15); // slightly dim as it shrinks
            } else {
                // Fully settled — hide (navbar brand takes over)
                stageTitle.style.opacity = '0';
            }
        }

        // --- Tagline: visible through painting phase, fades with crossfade ---
        if (stageTagline) {
            if (progress <= 0.3) {
                stageTagline.style.opacity = '1';
            } else if (progress <= 0.55) {
                var taglineFade = (progress - 0.3) / 0.25;
                stageTagline.style.opacity = String(1 - taglineFade);
            } else {
                stageTagline.style.opacity = '0';
            }
        }

        // --- Navbar: reveal after scroll stage ---
        if (navbar) {
            if (progress >= 0.85) {
                navbar.classList.add('scrolled');
            } else {
                // Only remove scrolled if we're still in the stage
                var stageRect = scrollStage.getBoundingClientRect();
                if (stageRect.bottom > 0) {
                    navbar.classList.remove('scrolled');
                }
            }
        }
    }

    // Use requestAnimationFrame for smooth animation
    var ticking = false;
    function onScroll() {
        if (!ticking) {
            requestAnimationFrame(function () {
                updateScrollAnimation();

                // Also handle navbar for content below scroll stage
                if (scrollStage) {
                    var stageRect = scrollStage.getBoundingClientRect();
                    if (stageRect.bottom <= 0 && navbar) {
                        navbar.classList.add('scrolled');
                    }
                }

                ticking = false;
            });
            ticking = true;
        }
    }

    // Always listen for scroll — the handler checks isMobile() dynamically
    window.addEventListener('scroll', onScroll, { passive: true });

    // Handle mobile navbar + set initial state
    function initNavbarState() {
        if (isMobile() && navbar) {
            navbar.classList.add('scrolled');
        } else if (!prefersReducedMotion) {
            updateScrollAnimation();
        } else {
            // Reduced motion desktop: show painting statically
            if (stagePainting) stagePainting.style.opacity = '1';
            if (stagePhone) stagePhone.style.opacity = '0';
            if (stageTitle) {
                stageTitle.style.fontSize = '7vw';
                stageTitle.style.opacity = '1';
            }
        }
    }

    // Run initial state setup after a brief delay to let viewport settle
    setTimeout(initNavbarState, 50);

    // Also re-init on resize (e.g. rotating device)
    window.addEventListener('resize', function () {
        if (isMobile() && navbar) {
            navbar.classList.add('scrolled');
        }
    });

    // --- Mobile hamburger ---
    var hamburger = document.getElementById('hamburger');
    var mobileNav = document.getElementById('mobile-nav');

    if (hamburger && mobileNav) {
        hamburger.addEventListener('click', function () {
            hamburger.classList.toggle('open');
            mobileNav.classList.toggle('open');
        });

        mobileNav.querySelectorAll('a').forEach(function (link) {
            link.addEventListener('click', function () {
                hamburger.classList.remove('open');
                mobileNav.classList.remove('open');
            });
        });
    }

    // --- Smooth scroll for anchor links ---
    document.querySelectorAll('a[href^="#"]').forEach(function (anchor) {
        anchor.addEventListener('click', function (e) {
            var target = document.querySelector(this.getAttribute('href'));
            if (target) {
                e.preventDefault();
                var offset = 80;
                var top = target.getBoundingClientRect().top + window.scrollY - offset;
                window.scrollTo({ top: top, behavior: 'smooth' });
            }
        });
    });

    // --- Intersection Observer for fade-in animations ---
    if (!prefersReducedMotion) {
        var observer = new IntersectionObserver(function (entries) {
            entries.forEach(function (entry) {
                if (entry.isIntersecting) {
                    entry.target.classList.add('visible');
                    observer.unobserve(entry.target);
                }
            });
        }, {
            threshold: 0.1,
            rootMargin: '0px 0px -40px 0px'
        });

        document.querySelectorAll('.fade-in').forEach(function (el) {
            observer.observe(el);
        });
    } else {
        document.querySelectorAll('.fade-in').forEach(function (el) {
            el.classList.add('visible');
        });
    }

    // --- Email signup form ---
    var form = document.getElementById('signup-form');
    var successMsg = document.getElementById('form-success');

    if (form) {
        form.addEventListener('submit', function (e) {
            e.preventDefault();

            var emailInput = form.querySelector('input[type="email"]');
            var email = emailInput.value.trim();

            if (!email || !email.includes('@') || !email.includes('.')) {
                emailInput.style.borderColor = '#3D22D3';
                return;
            }

            // Collect selected interests
            var interestBoxes = form.querySelectorAll('input[name="interests"]:checked');
            var interests = [];
            interestBoxes.forEach(function (box) { interests.push(box.value); });

            var submitBtn = form.querySelector('button');
            submitBtn.textContent = 'Sending...';
            submitBtn.disabled = true;

            fetch('/signup', {
                method: 'POST',
                headers: { 'Content-Type': 'application/json' },
                body: JSON.stringify({ email: email, interests: interests, source: 'website' })
            })
            .then(function (response) {
                form.classList.add('hidden');
                successMsg.classList.add('visible');
            })
            .catch(function () {
                form.classList.add('hidden');
                successMsg.classList.add('visible');
            });
        });
    }

})();
