require 'digest/sha2'
::Chef::Recipe.send(:include, Opscode::OpenSSL::Password)

if node[:ghost][:databag]
  databag = Chef::EncryptedDataBagItem.load(node[:ghost][:databag], node[:ghost][:databag_item])
  node.set_unless[:ghost][:password] = databag['ghost']['password'] rescue nil
else
  node.set_unless[:ghost][:password] = secure_password
end

password = node[:ghost][:password]
salt = rand(36**8).to_s(36)
shadow_hash = password.crypt("$6$" + salt)

chef_gem "ruby-shadow"

user node[:ghost][:user] do
  home node[:ghost][:home_dir]
  shell "/bin/bash"
  password shadow_hash
  supports :manage_home => true
  action :create
end

execute "add_user_to_www-data_group" do
  command "usermod -G www-data #{node[:ghost][:user]}"
end

node.set['authorization']['sudo']['passwordless'] = true
node.set_unless['authorization']['sudo']['users'] = [node[:ghost][:user]]
include_recipe "sudo"
