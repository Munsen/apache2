include Apache2::Cookbook::Helpers

property :default_site_name, String,
         default: 'default-site'

property :site_action, [String, Symbol],
         default: :enable,
         coerce: proc { |m| m.is_a?(String) ? m.to_i : m },
         equal_to: %i( enable disable)

property :port, String,
         default: '80'

property :template_cookbook, String,
         default: 'apache2'

property :server_admin, String,
         default: 'root@localhost'

property :log_level, String,
         default: 'warn'

property :log_dir, String,
         default: lazy { default_log_dir }

property :docroot_dir, String,
         default: lazy { default_docroot_dir }

property :apache_root_group, String,
         default: lazy { node['root_group'] }

property :template_source, String,
         default: lazy { default_site_template_source }

action :enable do
  template "#{new_resource.default_site_name}.conf" do
    source new_resource.template_source
    path "#{apache_dir}/sites-available/#{new_resource.default_site_name}.conf"
    owner 'root'
    group new_resource.apache_root_group
    mode '0644'
    cookbook new_resource.template_cookbook
    variables(
      access_log: default_access_log,
      cgibin_dir: default_cgibin_dir,
      docroot_dir: new_resource.docroot_dir,
      error_log: default_error_log,
      log_dir: default_log_dir,
      log_level: new_resource.log_level,
      port: new_resource.port,
      server_admin: new_resource.server_admin
    )
  end

  apache2_site new_resource.default_site_name do
    action :enable
  end
end

action :disable do
  template "#{new_resource.default_site_name}.conf" do
    path "#{apache_dir}/sites-available/#{new_resource.default_site_name}.conf"
    source 'default-site.conf.erb'
    owner 'root'
    group new_resource.apache_root_group
    mode '0644'
    cookbook new_resource.template_cookbook
    action :delete
  end

  apache2_site new_resource.default_site_name do
    action :disable
  end
end

action_class do
  include Apache2::Cookbook::Helpers
end
