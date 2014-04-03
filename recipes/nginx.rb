node.set_unless[:nginx][:repo_source] = "nginx"
node.set_unless[:nginx][:default_site_enabled] = false

include_recipe "nginx::repo"
include_recipe "nginx"

begin
  databag = Chef::EncryptedDataBagItem.load(node[:ghost][:databag], node[:ghost][:databag_item])
  node.set[:ghost][:ssl_cert] = databag['ghost']['ssl_cert'] rescue node[:ghost][:ssl_cert]
  node.set[:ghost][:ssl_key] = databag['ghost']['ssl_key'] rescue node[:ghost][:ssl_key]
  node.set[:ghost][:ssl_cacert] = databag['ghost']['ssl_cacert'] rescue node[:ghost][:ssl_cacert]
rescue
  nil
end

if node[:ghost][:ssl_cert] and node[:ghost][:ssl_key]
  file ::File.join(node[:ghost][:ssl_cert_path], node[:ghost][:domain] + ".crt") do
    content node[:ghost][:ssl_cert]
    action :create
    owner "root"
    group "root"
    mode 00644
  end
  file ::File.join(node[:ghost][:ssl_key_path], node[:ghost][:domain] + ".key") do
    content node[:ghost][:ssl_key]
    action :create
    owner "root"
    group "root"
    mode 00600
  end
  if node[:ghost][:ssl_cacert]
    file ::File.join(node[:ghost][:ssl_cacert_path], node[:ghost][:domain] + ".ca.crt") do
      content node[:ghost][:ssl_cacert]
      action :create
      owner "root"
      group "root"
      mode 00644
    end
  end
end

template "/etc/nginx/sites-available/ghost" do
  source "nginx-site.erb"
  variables(
    :dir     => ::File.join(node[:ghost][:install_path], "ghost")
  )
  notifies :restart, "service[nginx]"
end

### Workaround for default config in conf.d instead of sites-enabled.
template "/etc/nginx/conf.d/default.conf" do
  source "nginx-default.erb"
  notifies :restart, "service[nginx]"
end

nginx_site "ghost" do
  enable true
  template false
end
