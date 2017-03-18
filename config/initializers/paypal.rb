paypal_config_hash = YAML.load(File.open(Rails.root.join('config/paypal.defaults.yml'), 'r').readlines.join)[Rails.env]
paypal_config_hash.merge!(YAML.load(File.open(Rails.root.join('config/paypal.yml'), 'r').readlines.join)[Rails.env]) if File.exist?(Rails.root.join("config/paypal.yml"))
PAYPAL_CONFIG = OpenStruct.new(paypal_config_hash)

PayPal::SDK.load("config/paypal.defaults.yml", Rails.env)
PayPal::SDK.load("config/paypal.yml", Rails.env) if File.exist?(Rails.root.join("config/paypal.yml"))
PayPal::SDK.logger = Rails.logger
# PayPal::SDK.logger.level = Logger::INFO
