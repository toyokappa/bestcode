import moment from 'moment'
import Firebase from '../../lib/firebase'

export default class Chat {
  constructor(gon) {
    this.firebase = new Firebase();
    this.roomId = gon.room_chat_id;
    this.currentUser = gon.current_user;
    this.usersInfo = gon.users_info;
    this.displayMessages();
    this.bind()
  }

  async displayMessages() {
    const messages = await this.firebase.fetchMessages(this.roomId)
    messages.forEach((message) => {
      this.appendMessage(message.data());
    });
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
    const msgCreatedAt = moment.unix(msgData.created_at.seconds).format('H:mm');
    const msgElm = `<div class='chat-item' data-class='${msgSide}'>
                      <a class='avatar w-40 blue' href='${profilePath}'>
                        <img src='${userImg}'>
                      </a>
                      <div class='chat-body'>
                        <div class='chat-content rounded msg'>${msgData.body}</div>
                        <div class='chat-date date'>${msgCreatedAt}</div>
                      </div>
                    </div>`;
    $('.chat-list').append(msgElm);
  }

  sendMessage() {
    const $msgField = $('#message-field')
    const msgBody = $msgField.val();
    if(!msgBody) return;

    this.firebase.sendMessage(this.roomId, msgBody, this.currentUser.id);
    $msgField.val('');
  }

  bind() {
    $('#message-btn').on('click', (e) => {
      e.preventDefault();
      this.sendMessage();
    });
  }
}
