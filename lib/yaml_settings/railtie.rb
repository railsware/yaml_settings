module YamlSettings

  class Railtie < Rails::Railtie

    config.before_configuration do
      YamlSettings.options({
        :env  => Rails.env,
        :root => Rails.root
      })
    end

    config.after_initialize do |app|
      YamlSettings.load!
      YamlSettings.init_rails!
    end

  end
end
