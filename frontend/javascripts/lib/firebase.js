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
    this.firestore.settings({timestampsInSnapshots: true});
  }

  fetchMessages(roomId) {
    return this.firestore.collection('rooms').doc(roomId).collection('messages').get();
  }
}
