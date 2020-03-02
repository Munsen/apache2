property :proxy_requests, String,
         default: 'Off'

property :require, String,
         default: 'all denied'

property :add_default_charset, String,
         default: 'off'

property :proxy_via, String,
         equal_to: %w( Off On Full Block ),
         default: 'On'

action :create do
  template ::File.join(apache_dir, 'mods-available', 'proxy.conf') do
    source 'mods/proxy.conf.erb'
    cookbook 'apache2'
    variables(
      proxy_requests: new_resource.proxy_requests,
      require: new_resource.require,
      add_default_charset: new_resource.add_default_charset,
      proxy_via: new_resource.proxy_via
    )
  end
end

action_class do
  include Apache2::Cookbook::Helpers
end
