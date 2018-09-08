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

  fetchMessages(roomId) {
    return this.firestore.collection('rooms').doc(roomId).collection('messages').orderBy('created_at').get();
  }

  sendMessage(roomId, msgBody, msgType, userId) {
    this.firestore.collection('rooms').doc(roomId).collection('messages').add({
      body: msgBody,
      message_type: msgType,
      user_id: userId,
      created_at: firebase.firestore.FieldValue.serverTimestamp()
    });
  }

  onChangeMessages(roomId, callback) {
    this.firestore.collection('rooms').doc(roomId).collection('messages').orderBy('created_at')
      .onSnapshot(function(messages) {
        callback(messages);
      });
  }
}
