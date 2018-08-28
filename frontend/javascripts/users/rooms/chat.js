import Firebase from '../../lib/firebase'

export default class Chat {
  constructor(gon) {
    this.firebase = new Firebase();
    this.roomId = gon.room_chat_id;
    this.displayMessages();
  }

  async displayMessages() {
    const messages = await this.firebase.fetchMessages(this.roomId)
    messages.forEach((message) => {
      console.log(message.id, message.data());
    });
  }
}
