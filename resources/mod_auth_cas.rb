include Apache2::Cookbook::Helpers

property :install_method, String,
         equal_to: %w( source package ),
         default: 'package'

property :source_revision, String,
         default: 'v1.0.9.1'

property :root_group, String,
         default: lazy { node['root_group'] }

property :apache_user, String,
         default: lazy { default_apache_user }

property :apache_group, String,
         default: lazy { default_apache_group }

property :mpm, String,
         default: lazy { default_mpm }

action :install do
  if new_resource.install_method.eql? 'source'
    package apache_devel_package(new_resource.mpm)

    git '/tmp/mod_auth_cas' do
      repository 'git://github.com/Jasig/mod_auth_cas.git'
      revision new_resource.source_revision
      notifies :run, 'execute[compile mod_auth_cas]', :immediately
    end

    execute 'compile mod_auth_cas' do
      command './configure && make && make install'
      cwd '/tmp/mod_auth_cas'
      not_if "test -f #{libexec_dir}/mod_auth_cas.so"
    end

    template "#{apache_dir}/mods-available/auth_cas.load" do
      cookbook 'apache2'
      source 'mods/auth_cas.load.erb'
      owner 'root'
      group new_resource.root_group
      variables(cache_dir: cache_dir)
      mode '0644'
    end
  else

    case node['platform_family']
    when 'debian'
      package 'libapache2-mod-auth-cas'
    when 'rhel', 'fedora', 'amazon'
      with_run_context :root do
        yum_package 'mod_auth_cas' do
          notifies :run, 'execute[generate-module-list]', :immediately
        end
      end

      file "#{apache_dir}/conf.d/auth_cas.conf" do
        content '# conf is under mods-available/auth_cas.conf - apache2 cookbook\n'
        only_if { ::Dir.exist?("#{apache_dir}/conf.d") }
      end
    end
  end

  apache2_module 'auth_cas'

  directory "#{cache_dir}/mod_auth_cas" do
    owner new_resource.apache_user
    group new_resource.apache_group
    mode '0700'
  end
end

action_class do
  include Apache2::Cookbook::Helpers
end
