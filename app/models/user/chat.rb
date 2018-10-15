module User::Chat
  extend ActiveSupport::Concern

  def chat_id
    "user_#{id}"
  end

  def noticed_in_30_minutes?
    return false if noticed_at.blank?

    noticed_at > Time.zone.now - 30.minutes
  end
end
