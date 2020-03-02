include Apache2::Cookbook::Helpers

property :mime_magic_file, String,
         default: lazy { default_mime_magic_file }

action :create do
  template ::File.join(apache_dir, 'mods-available', 'mime_magic.conf') do
    source 'mods/mime_magic.conf.erb'
    cookbook 'apache2'
    variables(mime_magic_file: new_resource.mime_magic_file)
  end
end

action_class do
  include Apache2::Cookbook::Helpers
end
