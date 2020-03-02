property :status_location, String,
         default: '/balancer-manager'

property :set_handler, String,
         default: 'balancer-manager'

property :require, String,
         default: 'local'

action :create do
  template ::File.join(apache_dir, 'mods-available', 'proxy_balancer.conf') do
    source 'mods/proxy_balancer.conf.erb'
    cookbook 'apache2'
    variables(
      status_location: new_resource.status_location,
      set_handler: new_resource.set_handler,
      require: new_resource.require
    )
  end
end

action_class do
  include Apache2::Cookbook::Helpers
end
