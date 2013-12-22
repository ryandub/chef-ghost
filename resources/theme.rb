actions :install, :remove

default_action :install

attribute :name, :kind_of => String, :name_attribute => true
attribute :source, :kind_of => String, :required => true,
  :regex => /(http|https):\/\/.*\.(git|zip|tar.gz)/
attribute :install_path, :kind_of => String, 
  :default => "#{node[:ghost][:install_path]}/ghost/content/themes" 

attr_accessor :installed
