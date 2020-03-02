property :startservers, Integer,
         default: 16

property :minspareservers, Integer,
         default: 16

property :maxspareservers, Integer,
         default: 32

property :serverlimit, Integer,
         default: 256

property :maxrequestworkers, Integer,
         default: 256

property :maxconnectionsperchild, Integer,
         default: 10_000

action :create do
  template ::File.join(apache_dir, 'mods-available', 'mpm_prefork.conf') do
    source 'mods/mpm_prefork.conf.erb'
    cookbook 'apache2'
    variables(
      startservers: new_resource.startservers,
      minspareservers: new_resource.minspareservers,
      maxspareservers: new_resource.maxspareservers,
      serverlimit: new_resource.serverlimit,
      maxrequestworkers: new_resource.maxrequestworkers,
      maxconnectionsperchild: new_resource.maxconnectionsperchild
    )
  end
end

action_class do
  include Apache2::Cookbook::Helpers
end
