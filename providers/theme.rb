use_inline_resources

def whyrun_supported?
  true
end

def load_current_resource 
  @current_resource ||= Chef::Resource::GhostTemplate.new(@new_resource.name)

  if File.directory?("#{@current_resource.install_path}/#{@current_resource.name}")
    @current_resource.installed = true
  end

  @current_resource
end

action :install do

  unless @current_resource.installed
    converge_by("Create directory in content/themes for #{@new_resource}") do
      directory @current_resource.install_path do
        owner node[:ghost][:user]
        group node[:ghost][:user]
        mode "0755"
        action :create
      end
    end

    converge_by("Download and install the theme for #{@new_resource}") do

      case new_resource.source
      when /(http|https):\/\/.*\.git/
        git @current_resource.install_path do
          repository @current_resource.source
        end
      when /(http|https):\/\/.*\.zip/
        package "unzip"

        remote_file "#{Chef::Config[:file_cache_path]}/#{@current_resource.name}.zip" do
          source @current_resource.source
          notifies :run, "execute[unzip #{@current_resource.name}]", :immediately
        end

        execute "unzip #{@current_resource.name}" do
          command "unzip #{Chef::Config[:file_cache_path]}/#{@current_resource.name} -d #{@current_resource.install_path}"
          action :nothing
        end
      when /(http|https):\/\/.*\.tar.gz/
        remote_file "#{Chef::Config[:file_cache_path]}/#{@current_resource.name}.tar.gz" do
          source @current_resource.source
          notifies :run, "execute[untar #{@current_resource.name}]", :immediately
        end

        execute "untar #{@current_resource.name}" do
          command "tar -xzf #{Chef::Config[:file_cache_path]}/#{@current_resource.name}.tar.gz -C #{@current_resource.install_path}"
          action :nothing
          notifies :restart, "service[ghost]"
        end
      end
    end
  else
    Chef::Log.info "#{@new_resource} already installed."
  end
end

action :remove do
  converge_by("Delete the template directory for #{@new_resource}") do
    directory @current_resource.install_path do
      action :delete
      notifies :restart, "service[ghost]"
    end
  end
end
