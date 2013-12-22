use_inline_resources

def whyrun_supported?
  true
end

action :install do

  unless ::File.directory?("#{new_resource.install_path}/#{new_resource.name}")
    converge_by("Create directory in content/themes for #{new_resource}") do
      directory new_resource.install_path do
        owner node[:ghost][:user]
        group node[:ghost][:user]
        mode "0755"
        action :create
      end
    end

    converge_by("Download and install the theme for #{new_resource}") do

      case new_resource.source
      when /(http|https):\/\/.*\.git/
        package "git"
        git "#{new_resource.install_path}/#{new_resource.name}" do
          repository new_resource.source
        end
      when /(http|https):\/\/.*\.zip/
        package "unzip"

        remote_file "#{Chef::Config[:file_cache_path]}/#{new_resource.name}.zip" do
          source new_resource.source
          notifies :run, "execute[unzip #{new_resource.name}]", :immediately
        end

        execute "unzip #{new_resource.name}" do
          command "unzip #{Chef::Config[:file_cache_path]}/#{new_resource.name} -d #{new_resource.install_path}/#{new_resource.name}"
          action :nothing
        end
      when /(http|https):\/\/.*\.tar.gz/
        remote_file "#{Chef::Config[:file_cache_path]}/#{new_resource.name}.tar.gz" do
          source new_resource.source
          notifies :run, "execute[untar #{new_resource.name}]", :immediately
        end

        execute "untar #{new_resource.name}" do
          command "tar -xzf #{Chef::Config[:file_cache_path]}/#{new_resource.name}.tar.gz -C #{new_resource.install_path}/#{new_resource.name}"
          action :nothing
          notifies :restart, "service[ghost]"
        end
      end
    end
  else
    Chef::Log.info "#{new_resource} already installed."
  end
end

action :remove do
  converge_by("Delete the template directory for #{new_resource}") do
    directory new_resource.install_path do
      action :delete
      notifies :restart, "service[ghost]"
    end
  end
end
