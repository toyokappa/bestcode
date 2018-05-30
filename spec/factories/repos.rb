# == Schema Information
#
# Table name: repos
#
#  id          :bigint(8)        not null, primary key
#  name        :string(255)
#  full_name   :string(255)
#  description :text(65535)
#  url         :string(255)
#  is_private  :boolean          default(FALSE), not null
#  is_visible  :boolean          default(FALSE), not null
#  user_id     :bigint(8)
#  pushed_at   :datetime
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

FactoryBot.define do
  factory :repo do
    name "MyString"
    description "MyText"
    url "MyString"
    user nil
  end
end
