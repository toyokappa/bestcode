class Language < ActiveYaml::Base
  include ActiveHash::Associations

  set_root_path "db/master"
  set_filename "languages"

  has_many :skills, dependent: :destroy
end
