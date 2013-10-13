include_recipe 'database::mysql'

if node[:ghost][:databag]
  databag = Chef::EncryptedDataBagItem.load(node[:ghost][:databag], node[:ghost][:databag_item])
  node.set_unless[:ghost][:db_admin_password] = databag['ghost']['db_admin_password'] rescue nil
  node.set_unless[:ghost][:db_password] = databag['ghost']['db_password'] rescue nil
end

mysql_connection_info = {:host => node[:ghost][:db_host], :username => node[:ghost][:db_admin_user], :password => node[:ghost][:db_admin_password]}
  mysql_database node[:ghost][:db_name] do
    connection mysql_connection_info
    action :create
  end

mysql_database_user node[:ghost][:db_user] do
  connection mysql_connection_info
  password node[:ghost][:db_password]
  database_name node[:ghost][:db_name]
  host node[:ghost][:db_grant_host]
  privileges [:all]
  action :grant
end
