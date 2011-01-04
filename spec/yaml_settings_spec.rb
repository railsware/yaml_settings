require 'spec_helper'

describe YamlSettings do
  before(:each) do
    YamlSettings.reset!
  end

  describe "by default" do
    describe "options" do
      it do
        YamlSettings.options.should == YamlSettings.default_options
      end
    end

    describe "configs" do
      it { YamlSettings.configs.should == [] }
    end
    
    describe "application_config" do
      it { YamlSettings.application_config.should == nil }
    end
  end


  describe "with load!" do
    before(:each) do
      YamlSettings.options({
        :root => File.expand_path('../../', __FILE__),
        :config_dir => 'spec/settings'
      })
    end

    it "should load all yaml configurations from specified directory" do
      YamlSettings.load!

      YamlSettings.configs.should == %w(app hosts mailer yaml)
    end

    it "should have symbols and strings in configurations" do
      YamlSettings.load!

      YamlSettings[:hosts].should == {
        'one' => 'one.localhost',
        :two => 'two.localhost'
      }
    end

    it "should have configuration name as method" do
      YamlSettings.load!

      YamlSettings.hosts.should == {
        'one' => 'one.localhost',
        :two => 'two.localhost'
      }
    end


    it "should properly merge base_env and current environment" do
      YamlSettings.options[:env] = 'test'
      YamlSettings.load!

      YamlSettings[:mailer].should == {
        'name' => 'emulated',
        'settings' => {
          'address' => 'test.domain.com',
          'port'    => 25,
          'recipients' => {
            'admin' => 'admin@example.com',
            'user'  => 'test-user@example.com'
          }
        }
      }
    end


    it "should return value from configuration key given as string" do
      YamlSettings.load!

      YamlSettings.app.should == { :environment => 'staging', 'secret_key' => 'qwerty' }

      YamlSettings.app[:secret_key].should == 'qwerty'
      YamlSettings.app['secret_key'].should == 'qwerty'
      YamlSettings.app.secret_key.should == 'qwerty'
    end

    it "should return value from configuration key given as symbol" do
      YamlSettings.load!

      YamlSettings.app.should == { :environment => 'staging', 'secret_key' => 'qwerty' }
      
      YamlSettings.app[:environment].should == 'staging'
      YamlSettings.app['environment'].should == 'staging'
      YamlSettings.app.environment.should == 'staging'
    end

    it "should load configurations with custom config_glob" do
      YamlSettings.options[:config_glob] = '*.yaml'
      YamlSettings.load!

      YamlSettings.configs.should == %w(yaml)
      YamlSettings.yaml.should == { 'name' => 'YAML' }
    end

  end
end
