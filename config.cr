require "yaml"

class Config
  def call
    YAML.parse(File.read("./config.yml"))
  end
end
