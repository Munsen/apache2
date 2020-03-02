include Apache2::Cookbook::Helpers

property :mod_name, String,
         default: lazy { "mod_#{name}.so" }

property :path, String,
         default: lazy { "#{libexec_dir}/#{mod_name}" }

property :identifier, String,
         default: lazy { "#{name}_module" }

property :mod_conf, Hash,
        default: {}

property :conf, [true, false],
         default: lazy { config_file?(name) }

property :apache_service_notification, Symbol,
         equal_to: %i( reload restart ),
         default: :reload

action :enable do
  # Create apache2_mod_resource if we want it configured
  if new_resource.conf
    declare_resource("apache2_mod_#{new_resource.name}".to_sym, 'default') do
      new_resource.mod_conf.each { |k, v| send(k, v) }
    end
  end

  file ::File.join(apache_dir, 'mods-available', "#{new_resource.name}.load") do
    content "LoadModule #{new_resource.identifier} #{new_resource.path}\n"
    mode '0644'
  end

  execute "a2enmod #{new_resource.name}" do
    command "/usr/sbin/a2enmod #{new_resource.name}"
    notifies new_resource.apache_service_notification, 'service[apache2]', :delayed
    not_if { mod_enabled?(new_resource) }
  end
end

action :disable do
  execute "a2dismod #{new_resource.name}" do
    command "/usr/sbin/a2dismod #{new_resource.name}"
    notifies new_resource.apache_service_notification, 'service[apache2]', :delayed
    only_if { mod_enabled?(new_resource) }
  end
end

action_class do
  include Apache2::Cookbook::Helpers
end
