include Apache2::Cookbook::Helpers

property :public_html_dir, String,
         default: '/home/*/public_html'

property :options, String,
         default: 'MultiViews Indexes SymLinksIfOwnerMatch IncludesNoExec'

property :allow_override, String,
         default: 'FileInfo AuthConfig Limit Indexes'

action :create do
  template ::File.join(apache_dir, 'mods-available', 'userdir.conf') do
    source 'mods/userdir.conf.erb'
    cookbook 'apache2'
    variables(
      public_html_dir: new_resource.public_html_dir,
      allow_override: new_resource.allow_override,
      options: new_resource.options
    )
  end
end
