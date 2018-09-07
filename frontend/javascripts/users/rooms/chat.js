import moment from 'moment'
import Firebase from '../../lib/firebase'
import Message from '../../lib/message'
import ResizeTextarea from '../../util/resize_textarea'

export default class Chat {
  constructor(gon) {
    const firebase = new Firebase();
    firebase.auth(gon.auth_token);
    this.firebase = firebase;
    this.message = new Message();
    this.roomId = gon.room_chat_id;
    this.currentUser = gon.current_user;
    this.usersInfo = gon.users_info;
    $('#message-field').prop('disabled', false);
    $('#message-btn').prop('disabled', false);
    this.bind();
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

  async sendMessage() {
    const $msgField = $('#message-field');
    const msgBody = $msgField.val();
    if(!msgBody) return;

    const regex = new RegExp(`https://github.com/${this.currentUser.name}/([\\w\\d]+)/pull/(\\d+)`);
    var msgType = 'text';

    if(this.currentUser.id === this.usersInfo.reviewee.id && msgBody.match(regex)) {
      msgType = 'review_req';
      const path = `/users/rooms/${this.roomId.replace(/room_(\d+)_reviewee_\d+/, '$1')}/review_request`;
      const repoName = msgBody.match(regex)[1];
      const pullNum = msgBody.match(regex)[2];
      const authenticityToken = $('meta[name="csrf_token"]').attr('content');
      const params = { 
        repo_name: repoName,
        pull_num: pullNum,
        reviewee_id: this.currentUser.id.replace('user_', ''),
        authenticity_token: authenticityToken
      };
      const response = await $.post(path, params);

      var checkSend
      switch(response.status) {
        case 'NO_REPOS':
          checkSend = confirm('リポジトリが存在しないため、通常のテキストメッセージとして送信されますがよろしいですか？');
          if(!checkSend) return $msgField.val('');

          msgType = 'text';
          break;
        case 'NOT_MY_REPO':
          checkSend = confirm('Myリポジトリに登録されていないため、通常のテキストメッセージとして送信されますがよろしいですか？');
          if(!checkSend) return $msgField.val('');

          msgType = 'text';
          break;
        case 'NO_PULLS':
          checkSend = confirm('PRが存在しないため、通常のテキストメッセージとして送信されますがよろしいですか？');
          if(!checkSend) return $msgField.val('');

          msgType = 'text';
          break;
        case 'NOT_OPEN_PULL':
          checkSend = confirm('PRはクローズされているため、通常のテキストメッセージとして送信されますがよろしいですか？');
          if(!checkSend) return $msgField.val('');

          msgType = 'text';
          break;
        case 'EXIST_REVIEW_REQ':
          checkSend = confirm('すでにレビュー依頼中です。再依頼しますか？');
          if(!checkSend) return $msgField.val('');

          $.ajax({ url: path, method: "PATCH", data: params });
          break;
      }
    }

    this.firebase.sendMessage(this.roomId, msgBody, msgType, this.currentUser.id);
    $msgField.val('');
  }

  bind() {
    $('#message-btn').on('click', (e) => {
      e.preventDefault();
      this.sendMessage();
    });

    $('#message-field').on('keydown', (e) => {
      if(e.keyCode !== 13) return;

      if((e.ctrlKey && !e.metaKey) || (!e.ctrlKey && e.metaKey)) {
        // Windows: ctrl+enter / Mac: command+enter
        this.sendMessage();
        e.preventDefault();
      }
    });

    this.firebase.onChangeMessages(this.roomId, (msgData) => {
      this.appendMessage(msgData);
    });

    new ResizeTextarea($('#message-field'));
  }
}
