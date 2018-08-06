require "yaml"

class Config
  class YamlObject
    YAML.mapping({
      app_token: String,
      auth_token: String,
      start_date: Time,
      end_date: {
        type: Time,
        default: Time.now
      },
      days_off: {
        type: Array(Time),
        default: [] of Time,
      },
    })
  end

  def call
    config_file = File.read("./config.yml")

    YamlObject.from_yaml(config_file)
  end
end
