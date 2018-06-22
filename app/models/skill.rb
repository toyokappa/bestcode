class Skill < ApplicationRecord
  belongs_to :language
  belongs_to :languageable, polymorphic: true
end
