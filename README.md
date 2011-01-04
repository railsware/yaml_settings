YamlSetings
===========

YamlSettings is a simple configuration / settings solution that uses an ERB enabled YAML file.

Goals
-----

* No dependencies
* Customized
* DRY in configuration: base overridable configuration for all environments
* Rails agnostic
* Rails2/Rails3 zero configuration


Installation
------------

    gem install yaml_settings

Usage
-----

Put yaml configuration in config/settings:

config/settings/hosts.yml
    ---
    default:
      root: example.com
      www: www.example.com
    development:
      www: www.development.local
    production:
      www: www.production.com

In your application

    require 'yaml_settings'
    YamlSettings.options(:root => APP_ROOT, :env => APP_ENV, ...) # optionaly
    YamlSettings.load!
    
    YamlSettings.configs => ['hosts']
    YamlSettings[:hosts] => { 'www' => 'www.production.com', 'root' => 'example.com' }
    YamlSettings.hosts => { 'www' => 'www.production.com', 'root' => 'example.com' }
    YamlSettings.hosts[www] => 'www.production.com'
    YamlSettings.hosts[:www] => 'www.production.com'
    YamlSettings.hosts.www => 'www.production.com'

Options
-------

YamlSettings.options(OPTIONS)

* :env          - environment for configuration ('development') 
* :root         - your application root  ('.')
* :config_dir   - configurations directory ('config/settings')
* :config_glob  - configuration files glob  ('*.{yml,yaml}')
* :extensions   - configuration file extensions (%w(yml yaml))
* :base_env     - base overridable environment for any configuration ('default')
* :app_config   - configuration that can be applied to your application configuration ('application')

Rails2/Rails3 integration
-------------------------

Add to Gemfile

    gem 'yaml_settings'

You can optionally configure YamlSettings with adding next line:

    YamlSettings.options([desired_options])

* [rails2]: in config/environment.rb before line 'Rails::Initializer.run do |config|'
* [rails3]: in config/application.rb before line 'class YOUR_APP_MODULE::Application < Rails::Application'

By default YamlSettings applyes config/settings/application.yml to Rails.configurations.
So you can also configure Rails app in using yaml.

Example:
    config/settings/application.yml

    ---
    default:
      action_mailer:
        smtp_settings:
          port: 25
          domain: mydomain.com
          address: localhost
    production:
        smtp_settings:
          address: smtp.mydomain.com

References
----------

* http://github.com/binarylogic/settingslogic
* http://github.com/citrusbyte/settings
