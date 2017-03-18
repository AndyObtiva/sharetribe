
def __read_paypal_yaml_file__(file)
  abs_path = "#{Rails.root}/#{file}"
  if File.exists?(abs_path)
    file_content = File.open(abs_path, 'r').readlines.join
    erb_content = ERB.new(file_content).result(binding)
    yaml_content = YAML.load(erb_content)[Rails.env]
  end

  Maybe(yaml_content).or_else({})
end

paypal_config_hash = __read_paypal_yaml_file__('config/paypal.defaults.yml')
paypal_config_hash.merge!(__read_paypal_yaml_file__('config/paypal.yml'))
PAYPAL_CONFIG = OpenStruct.new(paypal_config_hash)

PayPal::SDK.load("config/paypal.defaults.yml", Rails.env)
PayPal::SDK.load("config/paypal.yml", Rails.env) if File.exist?(Rails.root.join("config/paypal.yml"))
PayPal::SDK.logger = Rails.logger
# PayPal::SDK.logger.level = Logger::INFO
