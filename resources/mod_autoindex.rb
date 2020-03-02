include Apache2::Cookbook::Helpers

property :index_options, Array,
         default: %w(FancyIndexing VersionSort HTMLTable NameWidth=* DescriptionWidth=* Charset=UTF-8)

property :readme_name, String,
         default: 'README.html'


property :header_name, String,
         default: 'HEADER.html'


property :index_ignore, String,
         default: '.??* *~ *# RCS CVS *,v *,t'


action :create do
  template ::File.join(apache_dir, 'mods-available', 'autoindex.conf') do
    source 'mods/autoindex.conf.erb'
    cookbook 'apache2'
    variables(
      header_name: new_resource.header_name,
      index_options: new_resource.index_options,
      index_ignore: new_resource.index_ignore,
      readme_name: new_resource.readme_name
    )
  end
end

action_class do
  include Apache2::Cookbook::Helpers
end
