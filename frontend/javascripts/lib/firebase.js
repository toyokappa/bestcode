import firebase from 'firebase';

export default class Firebase {
  constructor() {
    firebase.initializeApp({
      apiKey: process.env.FIREBASE_API_KEY,
      authDomain: process.env.FIREBASE_AUTH_DOMAIN,
      databaseURL: process.env.FIREBASE_DB_URL,
      projectId: process.env.FIREBASE_PROJECT_ID,
      storageBucket: process.env.FIREBASE_STORAGE_BUCKET,
      messagingSenderId: process.env.FIREBASE_SENDER_ID,
    });
    this.firestore = firebase.firestore();
    this.firebaseAuth = firebase.auth();
    this.firestore.settings({timestampsInSnapshots: true});
  }

  auth(auth_token) {
    this.firebaseAuth.signInWithCustomToken(auth_token).catch((error) => {
      console.error(`error code: ${error.code}, message: ${error.message}`);
      throw error;
    });
  }

  fetchMessages(roomId, readTime) {
    return this.firestore.collection('rooms').doc(roomId).collection('messages').where('created_at', '<=', readTime).orderBy('created_at').get();
  }

  sendMessage(roomId, msgBody, msgType, userId) {
    this.firestore.collection('rooms').doc(roomId).collection('messages').add({
      body: msgBody,
      message_type: msgType,
      user_id: userId,
      created_at: firebase.firestore.FieldValue.serverTimestamp()
    });
  }

  onChangeMessages(roomId, readTime, callback) {
    this.firestore.collection('rooms').doc(roomId).collection('messages').where('created_at', '>', readTime).orderBy('created_at')
      .onSnapshot(function(messages) {
        callback(messages);
      });
  }

  onChangeReadTime(roomId, userId, callback) {
    this.firestore.collection('rooms').doc(roomId).collection('users').doc(userId)
      .onSnapshot(function(user) {
        callback(user);
      });
  }

  async getReadTime(roomId, userId) {
    const user = await this.firestore.collection('rooms').doc(roomId).collection('users').doc(userId).get();
    if(!user.exists) return 0;

    return user.data().read_time
  }

  updateReadTime(roomId, userId) { 
    this.firestore.collection('rooms').doc(roomId).collection('users').doc(userId).update({
      read_time: firebase.firestore.FieldValue.serverTimestamp()
    });
  }

  async getUnreadsCount(roomId, readTime) {
    const messages = await this.firestore.collection('rooms').doc(roomId).collection('messages').where('created_at', '>', readTime).get();
    return messages.size
  }

  // FirestoreにRealtime Databaseのプレゼンスを同期
  // 参考: https://firebase.google.com/docs/firestore/solutions/presence?hl=ja#connecting_to
  onChangePresence(currentUserId) {
    const userPresenceDatabaseRef = firebase.database().ref(`/presence/${currentUserId}`);
    const isOfflineForDatabase = {
      state: 'offline',
      last_changed: firebase.database.ServerValue.TIMESTAMP,
    };
    const isOnlineForDatabase = {
      state: 'online',
      last_changed: firebase.database.ServerValue.TIMESTAMP,
    };
    firebase.database().ref('.info/connected').on('value', function(snapshot) {
      if(snapshot.val() == false) return;
      userPresenceDatabaseRef.onDisconnect().set(isOfflineForDatabase).then(function() {
        userPresenceDatabaseRef.set(isOnlineForDatabase);
      });
    });
  }

  getPresence(userId) {
    return firebase.database().ref(`/presence/${userId}`).once('value');
  }
}
