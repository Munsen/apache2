include Apache2::Cookbook::Helpers

property :template, String,
         name_property: true

property :root_group, String,
         default: lazy { node['root_group'] }

property :template_cookbook, String,
        default: 'apache2'

action :create do
  declare_resource(:template, ::File.join(apache_dir, 'mods-available', "#{new_resource.template}.conf")) do
    source "mods/#{new_resource.template}.conf.erb"
    cookbook new_resource.template_cookbook
    owner 'root'
    group new_resource.root_group
    mode '0644'
    variables(apache_dir: apache_dir)
    notifies :reload, 'service[apache2]', :delayed
    action :create
  end
end

action_class do
  include Apache2::Cookbook::Helpers
end
