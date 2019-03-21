window.onload = function(){
  //　ドロワー周りの処理
  const drawerMenu = document.getElementById('header_elements_sp');
  const drawerDeletebtn = document.getElementById('drawer_dalete');
  const drawerOverlay = document.getElementById('drawer_overlay');
  const openButton = document.getElementById('menu_opener');

  if(openButton && drawerDeletebtn && drawerOverlay){
    openButton.addEventListener('click', function(){
      clicked.call(this);
    }, false);

    drawerDeletebtn.addEventListener('click', function(){
      clicked.call(this);
    }, false);

    drawerOverlay.addEventListener('click', function(){
      clicked.call(this);
    }, false);
  };

  function clicked(){
    if(this === openButton){
      drawerMenu.classList.add('open');
      drawerOverlay.classList.remove('open');
    } else {
      drawerMenu.classList.remove('open');
      drawerOverlay.classList.add('open');
    };
  };

  // プロフィール画像即時プレビュー用
  const postImage = document.getElementById('post_img');
  const previewImage = document.getElementById('preview_img');

  if(postImage){
    postImage.addEventListener('change', function(){
      readURL.call(this);
    }, false);
  };

  function readURL() {
    if (this.files && this.files[0]) {
      var reader = new FileReader();
      reader.onload = function (e) {
        previewImage.setAttribute('src', e.target.result);
      };
      reader.readAsDataURL(this.files[0]);
    };
  };

  // カードアニメーション
  const openCards = document.getElementsByClassName('user_card');
  const cardOverlay = document.getElementById('card_overlay');

  if(openCards[0]){
    document.addEventListener('click', function(event){
      if(event.target.classList.contains('show_card')){
        toggleCard.call(openCards[event.target.dataset.user - 1]);
      }
      else if(event.target.classList.contains('card_dalete')){
        toggleCard.call(openCards[event.target.dataset.user - 1]);
      }
    }, false);

    function toggleCard(){
      if(this.classList.contains('opened')){
        this.classList.remove('opened');
        cardOverlay.classList.add('open');
      } else {
        this.classList.add('opened');
        cardOverlay.classList.remove('open');
      };
    };
  };
};
