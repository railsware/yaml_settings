YamlSettings.options({
  :env  => Rails.env,
  :root => Rails.root
})

Rails.configuration.after_initialize do
  YamlSettings.load!
  YamlSettings.apply_to_app!(Rails.configuration)
end
