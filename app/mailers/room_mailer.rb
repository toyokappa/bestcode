class RoomMailer < ApplicationMailer
  def participate(room, reviewee)
    @room = room
    @reviewee = reviewee
    mail to: @room.reviewer.email, subject: "【BestCode】ユーザーがルームに入室しました"
  end

  def leave(room, reviewee)
    @room = room
    @reviewee = reviewee
    mail to: @room.reviewer.email, subject: "【BestCode】ユーザーがルームから退室しました"
  end

  def leave_with_evaluation(room, reviewee, evaluation)
    @room = room
    @reviewee = reviewee
    @evaluation = evaluation
    mail to: @room.reviewer.email, subject: "【BestCode】ユーザーがルームから退室しました"
  end

  def update_evaluation(room, reviewee, evaluation)
    @room = room
    @reviewee = reviewee
    @evaluation = evaluation
    mail to: @room.reviewer.email, subject: "【BestCode】ユーザーがルームを再評価しました"
  end
end
