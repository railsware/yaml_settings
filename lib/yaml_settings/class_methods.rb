module YamlSettings
  module ClassMethods

    DEFAULT_OPTIONS = {
      :env           => 'development',
      :root          => '.',
      :config_dir    => 'config/settings',
      :config_glob   => '*.{yml,yaml}',
      :extensions    => %w(yml yaml),
      :base_env      => 'default',
      :app_config    => 'application'
    }.freeze

    REQUIRED_OPTIONS = DEFAULT_OPTIONS.keys.freeze

    def default_options
      DEFAULT_OPTIONS
    end

    def options(hash = nil)
      @options ||= default_options.dup
      @options.merge!(hash) if hash
      @options
    end

    def configs
      configurations.keys
    end

    def config(name)
      configurations[name.to_s]
    end
    alias :[] :config

    def application_config
      config(options[:app_config])
    end

    def load!
      REQUIRED_OPTIONS.each { |name| raise "Required option: #{name}" unless options[name] }

      path_pattern = File.join(options[:root], options[:config_dir], options[:config_glob])
      extension_regexp = /\.(#{options[:extensions].join('|')})$/
      configurations.clear

      Dir[path_pattern].each do |path|
        config_name = (File.basename(path)).gsub(extension_regexp, '')
        configurations[config_name] = Configuration.new(path, options)
      end

      configs
    end

    def reset!
      @options = @configurations = nil
    end

    def init_rails!
      application_config.each do |key, value|
        ::Rails.configuration.send("#{key}=", value)
      end if application_config
    end

    private

    def configurations
      @configurations ||= {}
    end

    def method_missing(method, *args, &block)
      self.config(method) || super
    end
  end
end
