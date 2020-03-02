include Apache2::Cookbook::Helpers

property :fast_cgi_wrapper, String,
         default: ''

property :add_handler, Hash,
         default: { 1 => 'fastcgi-script .fcgi' }

property :fast_cgi_ipc_dir, String,
         default: lazy { ::File.join(lib_dir, 'fastcgi') }

action :create do
  template ::File.join(apache_dir, 'mods-available', 'fastcgi.conf') do
    source 'mods/fastcgi.conf.erb'
    cookbook 'apache2'
    variables(
      fast_cgi_wrapper: new_resource.fast_cgi_wrapper,
      add_handler: new_resource.add_handler,
      fast_cgi_ipc_dir: new_resource.fast_cgi_ipc_dir
    )
  end
end

action_class do
  include Apache2::Cookbook::Helpers
end
