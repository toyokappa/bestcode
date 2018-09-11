import Firebase from '../../lib/firebase'
import Chat from './chat'
import UnreadCheck from './unread_check'

export default class InitChat {
  constructor(gon) {
    const firebase = new Firebase();
    firebase.auth(gon.auth_token);
    this.firebase = firebase;
    this.initialize();
  }

  initialize() {
    if(typeof gon.room_chat_ids !== 'undefined') new UnreadCheck(gon, this.firebase);
    if(typeof gon.room_chat_id !== 'undefined') new Chat(gon, this.firebase);
  }
}
