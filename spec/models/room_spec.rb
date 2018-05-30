# == Schema Information
#
# Table name: rooms
#
#  id          :bigint(8)        not null, primary key
#  name        :string(255)
#  description :text(65535)
#  capacity    :integer
#  reviewer_id :bigint(8)
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

require "rails_helper"

RSpec.describe Room, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
