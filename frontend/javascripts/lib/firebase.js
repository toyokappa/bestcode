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

  sendMessage(roomId, msgBody, userId) {
    this.firestore.collection('rooms').doc(roomId).collection('messages').add({
      body: msgBody,
      user_id: userId,
      created_at: firebase.firestore.FieldValue.serverTimestamp()
    });
  }

  onChangeMessages(roomId, callback) {
    this.firestore.collection('rooms').doc(roomId).collection('messages').orderBy('created_at')
      .onSnapshot(function(messages) {
        messages.docChanges().forEach((change) => {
          if (change.type === 'added') {
            // Firestoreへメッセージ送信時にcreated_atがnullの場合がある
            // その場合は一時退避し、created_at確定後(modified)時にmessageを取得
            if(change.doc.data().created_at === null) return;

            callback(change.doc.data());
          }
          if (change.type === 'modified') {
            callback(change.doc.data());
          }
        });
      });
  }
}
