require 'yaml'

class Configuration
  def self.[] key
    @@config[key]
  end

  def self.load name
    @@config = nil
    io = File.open( File.dirname(__FILE__) + "/../config.yml" )
    YAML::load_documents(io) { |doc| @@config = doc[name] }
    raise "Não foi possível encontrar o nome da configuração: \"#{name}\"" unless @@config
  end

  def self.[]= key, value
    @@config[key] = value
  end
end

raise "Por gentileza, atribua um valor ao parâmetro: TEST_ENV" unless ENV['TEST_ENV']
Configuration.load(ENV['TEST_ENV'])
