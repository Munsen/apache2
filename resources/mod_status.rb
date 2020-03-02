property :location, String,
         default: '/server-status'

property :status_allow_list, [String, Array],
         default: %w(127.0.0.1 ::1)

property :extended_status, String,
         equal_to: %w(On Off),
         default: 'Off'

property :proxy_status, String,
         equal_to: %w(On Off),
         default: 'On'

action :create do
  template ::File.join(apache_dir, 'mods-available', 'status.conf') do
    source 'mods/status.conf.erb'
    cookbook 'apache2'
    variables(
      location: new_resource.location,
      status_allow_list: Array(new_resource.status_allow_list),
      extended_status: new_resource.extended_status,
      proxy_status: new_resource.proxy_status
    )
  end
end

action_class do
  include Apache2::Cookbook::Helpers
end
