class UnreadMailer < ApplicationMailer
  def notice(sender, reciever, chat_url)
    @sender = sender
    @chat_url = chat_url
    mail to: reciever.email, subject: "【BestCode】新着メッセージのお知らせ"
  end
end
