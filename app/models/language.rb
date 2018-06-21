class Language < ApplicationRecord
  # NOTE: typeというカラム名を使用するとポリモーフィックの
  #       テーブルとしてご認識されてしまうため、下記で打ち消す
  # 参考: https://qiita.com/ryonext/items/1a813639ab2a2a00058e
  self.inheritance_column = :_type_disabled
  has_many :skills, dependent: :destroy
end
