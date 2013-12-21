actions :install, :remove

default_action :install

attribute :name, :kind_of => String, :name_attribute => true
attribute :source, :kind_of => String, :required => true
attribute :install_path, :kind_of => String, 
  :default => "#{node[:ghost][:install_path]}/content/themes", 
  :regex => /(http|https):\/\/.*\.(git|zip|tar.gz)/

attr_accessor :installed
