let swiper = new Swiper('.swiper-container-login', {
  effect: 'fade',
  fadeEffect: {
    crossFade: true,
  },
  navigation: {
    nextEl: '.swiper-button-next',
    prevEl: '.swiper-button-prev',
  },
  loop: true,
  autoHeight: true,
  autoplay: {
    delay: 3000,
    disableOnInteraction: true
  },
});