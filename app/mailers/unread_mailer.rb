class UnreadMailer < ApplicationMailer
  def notice(sender, receiver, chat_url)
    @sender = sender
    @chat_url = chat_url
    mail to: receiver.email, subject: "【BestCode】新着メッセージのお知らせ"
  end
end
