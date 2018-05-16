class User < ApplicationRecord
  validates :name, presence: true, uniqueness: true
  validates :email, presence: true, uniqueness: true

  class << self
    def create_with_omniauth(auth)
      contribution = total_contribution(auth.info.nickname)
      create!(
        provider: auth.provider,
        uid: auth.uid,
        name: auth.info.nickname,
        email: auth.info.email,
        contribution: contribution,
        is_reviewer: reviewer?(contribution),
      )
    end

    def get_contribution(nickname)
      # NOTE: できればこの処理を自鯖に持ちたいので修正する
      url = "https://github-contributions-api.herokuapp.com/#{nickname}/count"
      uri = URI.parse url
      request = Net::HTTP::Get.new(uri.request_uri)
      response = Net::HTTP.start(uri.host, uri.port, use_ssl: uri.scheme == "https") do |http|
        http.request(request)
      end
      body = JSON.parse response.body
      body["data"]
    end

    # 昨年〜今年のコントリビューションを取得し合算
    def total_contribution(nickname)
      yearly_contributions = get_contribution(nickname)
      last_year = (Time.zone.today - 1.year).year.to_s
      this_year = Time.zone.today.year.to_s
      last_year_contribution = yearly_contributions[last_year]&.map {|_, contributions| contributions.values.inject(:+) }&.sum
      this_year_contribution = yearly_contributions[this_year].map {|_, contributions| contributions.values.inject(:+) }.sum
      last_year_contribution + this_year_contribution
    end

    def reviewer?(contribution)
      contribution >= 1000
    end
  end
end
