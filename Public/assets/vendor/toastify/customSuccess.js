Toastify({
  text: document.getElementById('display-success-message').dataset.message,
  duration: 3000,
  close: true,
  avatar: '/assets/favicon_io/apple-touch-icon.png',
  className: "bg-success",
  offset: {
    x: 9,
    y: 3,
  },
}).showToast();

/*
const templateContext = document.getElementById('display-success-message');
console.log(templateContext.dataset.message);
*/
