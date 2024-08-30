Toastify({
    text: document.getElementById('display-error-message').dataset.message,
    duration: 3000,
    close: true,
    avatar: '/assets/favicon_io/apple-touch-icon.png',
    className: "bg-danger",
    offset: {
      x: 9,
      y: 3,
    },
  }).showToast();

/*
const templateContext = document.getElementById('display-error-message');
console.log(templateContext.dataset.message);
*/