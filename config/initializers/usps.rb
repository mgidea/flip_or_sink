USPS_CONFIG = YAML.load(ERB.new(File.new("config/usps.yml").read).result)[Rails.env]
