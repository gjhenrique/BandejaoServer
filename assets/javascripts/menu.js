// Dropdown menu for mobile devices
(function(document) {
  var className = 'is-active';
  var mainMenu = document.getElementById('main-nav'),
    menuButton = document.getElementById('menu-button');

  function toggleMenu() {
    var isActive = mainMenu.classList.contains(className);
    if (isActive) {
      menuButton.classList.remove(className);
      mainMenu.classList.remove(className);
    } else {
      menuButton.classList.add(className);
      mainMenu.classList.add(className);
    }
  }

  menuButton.addEventListener('click', function(e) {
    toggleMenu();
  });
})(document);
