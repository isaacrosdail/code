
document.addEventListener('click', (e) => {
    const slider = document.querySelector('.slider');
    const total = slider.clientWidth;
    const scrollLeft = slider.scrollLeft;
    const firstSlide = slider.querySelector('.slider-element');
    const slideWidth = firstSlide.getBoundingClientRect().width;

    if (e.target.matches('#next-btn')) {
        slider.scrollBy({ left: slideWidth, behavior: 'smooth' });
    }

    else if (e.target.matches('#back-btn')) {
        slider.scrollBy({ left: -slideWidth, behavior: 'smooth'});
    }
})