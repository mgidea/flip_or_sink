ONBOARD_CONFIG = YAML.load(ERB.new(File.new("config/onboard.yml").read).result)[Rails.env]
