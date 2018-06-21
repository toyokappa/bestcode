class Skill < ApplicationRecord
  belongs_to :languageable, polymorphic: true
end
