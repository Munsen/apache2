include Apache2::Cookbook::Helpers

property :cache_root, String,
         default: lazy { default_cache_root }

property :cache_dir_levels, String,
         default: '2'


property :cache_dir_length, String,
         default: '2'

action :create do
  template ::File.join(apache_dir, 'mods-available', 'cache_disk.conf') do
    source 'mods/cache_disk.conf.erb'
    cookbook 'apache2'
    variables(
      cache_root: new_resource.cache_root,
      cache_dir_levels: new_resource.cache_dir_levels,
      cache_dir_length: new_resource.cache_dir_length
    )
  end
end

action_class do
  include Apache2::Cookbook::Helpers
end
