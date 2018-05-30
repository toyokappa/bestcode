# == Schema Information
#
# Table name: pulls
#
#  id          :bigint(8)        not null, primary key
#  name        :string(255)
#  description :text(65535)
#  url         :string(255)
#  number      :integer
#  is_open     :boolean          default(FALSE), not null
#  repo_id     :bigint(8)
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

FactoryBot.define do
  factory :pull do
    name "MyString"
    description "MyText"
    url "MyString"
    repository nil
  end
end
