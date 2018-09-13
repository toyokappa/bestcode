module User::Firestore
  extend ActiveSupport::Concern
  require "google/cloud/firestore"

  def join_firestore_chat(room)
    firestore = init_firestore

    users = firestore.col("rooms").doc(room.chat_id(self.id)).col("users")
    reviewer = users.doc(room.reviewer.chat_id)
    reviewee = users.doc(self.chat_id)

    reviewer.set({ read_time: firestore.field_server_time })
    reviewee.set({ read_time: firestore.field_server_time })
  end

  # 作成したものの一旦は使わなそう
  def firebase_login
    api_key = Rails.application.credentials.firebase[Rails.env.to_sym][:api_key]
    url = "https://www.googleapis.com"
    conn = Faraday.new url: url do |faraday|
      faraday.response :logger
      faraday.adapter  Faraday.default_adapter
    end

    response = conn.post do |req|
      req.url "/identitytoolkit/v3/relyingparty/verifyCustomToken?key=#{api_key}"
      req.headers["Content-Type"] = "application/json"
      req.body = { "token" => firebase_auth_token }.to_json
    end

    raise StandardError unless response.status == 200
  end

  def firebase_auth_token
    firebase = Rails.application.credentials.firebase[Rails.env.to_sym]
    service_account_email = firebase[:client_email]
    private_key = OpenSSL::PKey::RSA.new(firebase[:private_key])
    now_seconds = Time.now.to_i
    uid = chat_id

    payload = {
      iss: service_account_email,
      sub: service_account_email,
      aud: "https://identitytoolkit.googleapis.com/google.identity.identitytoolkit.v1.IdentityToolkit",
      iat: now_seconds,
      exp: now_seconds + (60 * 60), # Maximum expiration time is one hour
      uid: uid,
    }
    JWT.encode payload, private_key, "RS256"
  end

  private

    # TODO: FirebaseのCredential情報(json)をgit管理下に置きたくない
    #       が故の苦肉の策。ルームに入るたびに作成、削除が実行されるので
    #       いい実装方法があればそちらに切り替えたい
    def init_firestore
      file_path = "#{Rails.root}/config/firebase_key.json"
      firebase = Rails.application.credentials.firebase[Rails.env.to_sym]
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
      firestore = Google::Cloud::Firestore.new(project_id: firebase[:project_id], credentials: file_path)
      File.unlink(file_path)
      firestore
    end
end
