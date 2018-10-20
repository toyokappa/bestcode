namespace :data_patch do
  desc "Userのemailがうまく書き込めなかったものを修正するためのタスク"
  task :fix_user_email => :environment do
    User.where(email: nil).each do |user|
      github_user = Octokit::Client.new(access_token: user.access_token)
      github_user.login

      email = github_user.emails.select {|e| e[:primary] }.first[:email]
      user.update!(email: email)
    end
  end
end
