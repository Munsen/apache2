property :startservers, Integer,
         default: 4

property :minsparethreads, Integer,
         default: 64

property :maxsparethreads, Integer,
         default: 192

property :threadsperchild, Integer,
         default: 64

property :maxrequestworkers, Integer,
         default: 1024

property :maxconnectionsperchild, Integer,
         default: 0

property :threadlimit, Integer,
         default: 192

property :serverlimit, Integer,
         default: 16

action :create do
  template ::File.join(apache_dir, 'mods-available', 'mpm_worker.conf') do
    source 'mods/mpm_worker.conf.erb'
    cookbook 'apache2'
    variables(
      startservers: new_resource.startservers,
      minsparethreads: new_resource.minsparethreads,
      maxsparethreads: new_resource.maxsparethreads,
      threadsperchild: new_resource.threadsperchild,
      maxrequestworkers: new_resource.maxrequestworkers,
      maxconnectionsperchild: new_resource.maxconnectionsperchild,
      threadlimit: new_resource.threadlimit,
      serverlimit: new_resource.serverlimit
    )
  end
end

action_class do
  include Apache2::Cookbook::Helpers
end
