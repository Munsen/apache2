property :actions, Hash,
         default: {}

action :create do
  template ::File.join(apache_dir, 'mods-available', 'actions.conf') do
    source 'mods/actions.conf.erb'
    cookbook 'apache2'
    variables(actions: new_resource.actions)
  end
end

action_class do
  include Apache2::Cookbook::Helpers
end
