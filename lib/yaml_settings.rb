module YamlSettings
  autoload :ClassMethods,  'yaml_settings/class_methods'
  autoload :Configuration, 'yaml_settings/configuration'
  autoload :Utils,         'yaml_settings/utils'

  extend ClassMethods
end

case ::Rails::VERSION::MAJOR
when 3
  require 'yaml_settings/railtie'
when 2
  require 'yaml_settings/rails2'
end if defined? ::Rails
