class User < ApplicationRecord
  validates :name, presence: true, uniqueness: true
  validates :email, presence: true, uniqueness: true

  class << self
    def create_with_omniauth(auth)
      contributions = get_contributions(auth.info.nickname)
      create!(
        provider: auth.provider,
        uid: auth.uid,
        name: auth.info.nickname,
        email: auth.info.email,
        contributions: contributions,
        is_reviewer: is_reviewer?(contributions)
      )
    end

    def get_contributions(nickname)
      # NOTE: できればこの処理を自鯖に持ちたいので修正する
      url = "https://github-contributions-api.herokuapp.com/#{nickname}/count"
      uri = URI.parse url
      request = Net::HTTP::Get.new(uri.request_uri)
      response = Net::HTTP.start(uri.host, uri.port, use_ssl: uri.scheme == "https") do |http|
        http.request(request)
      end
      body = JSON.load response.body
      
      last_year = (Date.today - 1.year).year.to_s
      this_year = Date.today.year.to_s

      last_year_contributions = body["data"][last_year].map{ |key, value| value.values.inject(:+) }.sum
      this_year_contributions = body["data"][this_year].map{ |key, value| value.values.inject(:+) }.sum
      total_contributions = last_year_contributions + this_year_contributions
    end

    def is_reviewer?(contributions)
      contributions >= 1000
    end
  end
end
