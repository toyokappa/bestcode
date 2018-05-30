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

require "rails_helper"

RSpec.describe Repo, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
