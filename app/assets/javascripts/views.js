document.addEventListener('DOMContentLoaded', function(){
  // アラートメッセージのフェードアウト処理
  const alert_message = document.getElementById('alert');
  if (alert_message){
    setTimeout(function(){
      alert_message.classList.add('fadeout');
      alert_message.addEventListener("animationend", function(){
        alert_message.setAttribute('style', "display: none;");
      });
    }, 1500);
  };
  
  //　ドロワー周りの処理
  const drawerMenu = document.getElementById('drawer_elements');
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
  const postImage = document.getElementById('user_picture');
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
        toggleCard.call(openCards[event.target.dataset.index]);
      }
      else if(event.target.classList.contains('card_delete')){
        toggleCard.call(openCards[event.target.dataset.index]);
      }
    }, false);

    function toggleCard(){
      if(this.classList.contains('show')){
        this.classList.remove('show');
        cardOverlay.classList.add('open');
      } else {
        this.classList.add('show');
        cardOverlay.classList.remove('open');
      };
    };
  };

  const cards = document.querySelectorAll('.card_elements');

  function transition() {
    if (this.classList.contains('show')) {
      this.classList.remove('show')
    } else {
      this.classList.add('show');
    }
  }
  cards.forEach(card => card.addEventListener('click', transition));

  // モーダルアニメーション
  const openModal = document.getElementById('leave_modal');
  const modalOverlay = document.getElementById('modal_overlay');

  if(openModal && modalOverlay){
    document.addEventListener('click', function(event){
      if(event.target.classList.contains('modal_open')){
        toggleModal.call(openModal);
      }
      else if(event.target.classList.contains('modal_close')){
        toggleModal.call(openModal);
      }
    }, false);

    function toggleModal(){
      if(this.classList.contains('show')){
        this.classList.remove('show');
        modalOverlay.classList.add('open');
      } else {
        this.classList.add('show');
        modalOverlay.classList.remove('open');
      };
    };
  };

  // バリデーション
  $('#registration_form').parsley();
}, false);
