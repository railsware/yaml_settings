require 'yaml'
require 'erb'

module YamlSettings
  class Configuration < ::Hash

    ATTRIBUTE_AS_METHOD_REGEXP = /^[^\d][\w\d_]+$/

    def initialize(path, options = {})
      raise "Configuration file not found: #{path.inspect}" unless ::File.exists?(path)

      configurations = ::YAML.load(::ERB.new(::File.read(path)).result)

      update(Utils.merge_hashes(
        configurations[options[:base_env]] || {},
        configurations[options[:env]] || {}
      ))

      keys.each do |key|
        if key.to_s =~ ATTRIBUTE_AS_METHOD_REGEXP
          self.instance_eval "def #{key}; self[:#{key}]; end", __FILE__, __LINE__
        end
      end

      freeze
    end

    def [](key)
      return super if key?(key)

      super(
        case key
        when Symbol
          key.to_s
        when String
          key.to_sym
        else
          key
        end
      )
    end

  end
end
