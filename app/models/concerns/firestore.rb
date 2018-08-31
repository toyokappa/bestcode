module Firestore
  extend ActiveSupport::Concern
  require "google/cloud/firestore"

  def join_firestore_chat(room)
    firestore = get_firestore

    users = firestore.col('rooms').doc(room.chat_id(self.id)).col('users')
    reviewer = users.doc(room.reviewer.chat_id) 
    reviewee = users.doc(self.chat_id)

    reviewer.set({ read_time: 0 })
    reviewee.set({ read_time: 0 })
  end

  private

    # TODO: FirebaseのCredential情報(json)をgit管理下に置きたくない
    #       が故の苦肉の策。ルームに入るたびに作成、削除が実行されるので
    #       いい実装方法があればそちらに切り替えたい
    def get_firestore
      file_path = "#{Rails.root}/config/firebase_key.json"
      firebase = Rails.application.credentials.firebase
      firebase_key = {
        type: firebase[:type],
        project_id: firebase[:project_id],
        private_key_id: firebase[:private_key_id],
        private_key: firebase[:private_key],
        client_email: firebase[:client_email],
        client_id: firebase[:client_id],
        auth_uri: firebase[:auth_uri],
        token_uri: firebase[:token_uri],
        auth_provider_x509_cert_url: firebase[:auth_provider_x509_cert_url],
        client_x509_cert_url: firebase[:client_x509_cert_url],
      }.to_json

      File.write(file_path, firebase_key)
      firestore = Google::Cloud::Firestore.new(
        project_id: ENV["FIREBASE_PROJECT_ID"],
        credentials: file_path
      )
      File.unlink(file_path)
      firestore
    end
end

