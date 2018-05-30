# == Schema Information
#
# Table name: users
#
#  id           :bigint(8)        not null, primary key
#  provider     :string(255)
#  uid          :string(255)
#  name         :string(255)
#  email        :string(255)
#  contribution :integer          default(0), not null
#  is_reviewer  :boolean          default(FALSE), not null
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  access_token :string(255)
#

FactoryBot.define do
  factory :user do
    provider "MyString"
    uid "MyString"
    name "MyString"
    email "MyString"
    contribution 1
    is_reviewer false
  end
end
