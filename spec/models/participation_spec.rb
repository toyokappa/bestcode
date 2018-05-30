# == Schema Information
#
# Table name: participations
#
#  id                    :bigint(8)        not null, primary key
#  participating_room_id :bigint(8)
#  reviewee_id           :bigint(8)
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#

require "rails_helper"

RSpec.describe Participation, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
