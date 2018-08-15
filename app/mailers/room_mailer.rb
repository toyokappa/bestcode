class RoomMailer < ApplicationMailer
  def participate(room, reviewee)
    @room = room
    @reviewee = reviewee
    mail to: @room.reviewer.email, subject: "【ReviewHub】ユーザーがルームに入室しました"
  end

  def leave(room, reviewee)
    @room = room
    @reviewee = reviewee
    mail to: @room.reviewer.email, subject: "【ReviewHub】ユーザーがルームから退室しました"
  end

  def leave_with_evaluation(room, reviewee, evaluation)
    @room = room
    @reviewee = reviewee
    @evaluation = evaluation
    mail to: @room.reviewer.email, subject: "【ReviewHub】ユーザーがルームから退室しました"
  end
end
