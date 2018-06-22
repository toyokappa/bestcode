LANGUAGES = YAML.load_file("#{Rails.root}/db/fixtures/master/languages.yml")

LANGUAGES.each do |language|
  Language.seed_once do |l|
    l.id = language["id"]
    l.name = language["name"]
    l.type = language["type"]
  end
end
