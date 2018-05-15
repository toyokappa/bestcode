class User < ApplicationRecord
  validates :name, presence: true, uniqueness: true
  validates :email, presence: true, uniqueness: true

  class << self
    def create_with_omniauth(auth)
      contribution = get_contribution(auth.info.nickname)
      create!(
        provider: auth.provider,
        uid: auth.uid,
        name: auth.info.nickname,
        email: auth.info.email,
        contribution: contribution,
        is_reviewer: is_reviewer?(contribution)
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
      body = JSON.load response.body
      
      last_year = (Date.today - 1.year).year.to_s
      this_year = Date.today.year.to_s
      last_year_contribution = body["data"][last_year].map{ |key, value| value.values.inject(:+) }.sum
      this_year_contribution = body["data"][this_year].map{ |key, value| value.values.inject(:+) }.sum
      total_contribution = last_year_contribution + this_year_contribution
    end

    def is_reviewer?(contribution)
      contribution >= 1000
    end
  end
end
