import Firebase from '../../lib/firebase'

export default class UnreadCheck {
  constructor(gon, firebase) {
    this.firebase = firebase
    this.currentRoomId = gon.room_chat_id;
    this.roomIds = gon.room_chat_ids;
    this.currentUser = gon.current_user;
    this.readTimes = {};
    this.initReadTime();
  }

  async initReadTime() {
    for(let roomId of this.roomIds) {
      this.readTimes[roomId] = await this.firebase.getReadTime(roomId, this.currentUser.id);
      if(this.readTimes[roomId] === 0) continue;

      // メッセージの内容が更新された場合
      this.firebase.onChangeMessages(roomId, this.readTimes[roomId], () => {
        // 現在開いているチャットの更新は不要なため
        if(roomId === this.currentRoomId) return;

        this.changeUnreadCount(roomId, this.readTimes[roomId]);
      });

      // ユーザーの既読時間が変わった場合
      this.firebase.onChangeReadTime(roomId, this.currentUser.id, (user) => {
        // Firestoreからのデータ受取時にread_timeがnullの場合がある
        if(user.data().read_time === null) return;

        this.changeUnreadCount(roomId, user.data().read_time);
      });
    }
  }

  async changeUnreadCount(roomId, readTime) {
    const unreadCount = await this.firebase.getUnreadsCount(roomId, readTime);
    const $unreadBadge = $(`#content-aside .list-item.${roomId} .badge`)
    if(unreadCount === 0) return $unreadBadge.hide();
    $unreadBadge.show();
    $unreadBadge.text(unreadCount);
  }
}
