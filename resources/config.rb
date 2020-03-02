include Apache2::Cookbook::Helpers

property :root_group, String,
         default: lazy { node['root_group'] }

property :access_file_name, String,
         default: '.htaccess'

property :log_dir, String,
         default: lazy { default_log_dir }

property :error_log, String,
         default: lazy { default_error_log }

property :log_level, String,
         default: 'warn'

property :apache_user, String,
         default: lazy { default_apache_user }

property :apache_group, String,
         default: lazy { default_apache_group }

property :keep_alive, String,
         equal_to: %w(On Off),
         default: 'On'

property :max_keep_alive_requests, Integer,
         default: 100


property :keep_alive_timeout, Integer,
         default: 5

property :docroot_dir, String,
         default: lazy { default_docroot_dir }

property :timeout, [Integer, String],
         coerce: proc { |m| m.is_a?(Integer) ? m.to_s : m },
         default: 300

property :server_name, String,
         default: 'localhost'

property :run_dir, String,
         default: lazy { default_run_dir }

action :create do
  template 'apache2.conf' do
    if platform_family?('debian')
      path "#{apache_conf_dir}/apache2.conf"
    else
      path "#{apache_conf_dir}/httpd.conf"
    end
    action :create
    source 'apache2.conf.erb'
    cookbook 'apache2'
    owner 'root'
    group new_resource.root_group
    mode '0640'
    variables(
      access_file_name: new_resource.access_file_name,
      apache_binary: apache_binary,
      apache_dir: apache_dir,
      apache_user: new_resource.apache_user,
      apache_group: new_resource.apache_group,
      docroot_dir: new_resource.docroot_dir,
      error_log: new_resource.error_log,
      keep_alive: new_resource.keep_alive,
      keep_alive_timeout: new_resource.keep_alive_timeout,
      lock_dir: lock_dir,
      log_dir: new_resource.log_dir,
      log_level: new_resource.log_level,
      max_keep_alive_requests: new_resource.max_keep_alive_requests,
      pid_file: apache_pid_file,
      run_dir: new_resource.run_dir,
      timeout: new_resource.timeout,
      server_name: new_resource.server_name
    )
    notifies :restart, 'service[apache2]', :delayed
  end
end

action_class do
  include Apache2::Cookbook::Helpers
end
