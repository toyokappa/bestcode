import moment from 'moment'
import Firebase from '../../lib/firebase'
import Message from '../../lib/message'

export default class Chat {
  constructor(gon) {
    const firebase = new Firebase();
    firebase.auth(gon.auth_token);
    this.firebase = firebase;
    this.message = new Message();
    this.roomId = gon.room_chat_id;
    this.currentUser = gon.current_user;
    this.usersInfo = gon.users_info;
    this.bind()
  }

  appendMessage(msgData) {
    var profilePath;
    var userImg;
    if(msgData.user_id === this.usersInfo.reviewer.id) {
      profilePath = this.usersInfo.reviewer.profile_path;
      userImg = this.usersInfo.reviewer.image;
    } else {
      profilePath = this.usersInfo.reviewee.profile_path;
      userImg = this.usersInfo.reviewee.image;
    }

    const msgSide = (msgData.user_id === this.currentUser.id) ? 'alt' : 'null';
    let msgElm = this.message.generateMessage(msgData, profilePath, userImg, msgSide);
    $('.chat-list').append(msgElm);
  }

  sendMessage() {
    const $msgField = $('#message-field');
    const msgBody = $msgField.val();
    if(!msgBody) return;

    var msgType
    if(this.currentUser.id === this.usersInfo.reviewee.id) {
      const regex = new RegExp(`https://github.com/${this.currentUser.name}/[\\w\\d]+/pull/\\d+`);
      msgType = msgBody.match(regex) ? 'review_req' : 'text';
    } else {
      msgType = 'text';
    }

    this.firebase.sendMessage(this.roomId, msgBody, msgType, this.currentUser.id);
    $msgField.val('');
  }

  bind() {
    $('#message-btn').on('click', (e) => {
      e.preventDefault();
      this.sendMessage();
    });

    this.firebase.onChangeMessages(this.roomId, (msgData) => {
      this.appendMessage(msgData);
    });
  }
}
