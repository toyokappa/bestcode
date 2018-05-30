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

require "rails_helper"

RSpec.describe User, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
