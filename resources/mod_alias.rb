include Apache2::Cookbook::Helpers

property :options, Array,
         default: %w(Indexes MultiViews SymLinksIfOwnerMatch)

property :icondir, String,
         default: lazy { icon_dir }

property :allow_override, Array,
         default: %w(None)

property :require, String,
         default: 'all granted'

action :create do
  template ::File.join(apache_dir, 'mods-available', 'alias.conf') do
    source 'mods/alias.conf.erb'
    cookbook 'apache2'
    variables(
      icondir: new_resource.icondir,
      options: new_resource.options,
      allow_override: new_resource.allow_override,
      require: new_resource.require
    )
  end
end

action_class do
  include Apache2::Cookbook::Helpers
end
