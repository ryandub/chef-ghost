# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  config.vm.hostname = "ghost-berkshelf"
  config.vm.box = "precise64"
  config.vm.box_url = "http://files.vagrantup.com/precise64.box"

  config.vm.network :private_network, ip: "33.33.33.10"
  config.vm.network :forwarded_port, guest: 80, host: 3080
  config.vm.network :forwarded_port, guest: 2368, host: 2368

  config.berkshelf.enabled = true
  config.omnibus.chef_version = :latest

  config.vm.provision :chef_solo do |chef|
    chef.log_level = :debug
    chef.json = {
      :authorization => {
        :sudo => {
          :users => ["vagrant", "ghost"]
        }
      },
      :ghost => {
        :db_admin_password => "foobar",
        :db_password => "ghost",
        :themes => {
          :ghostwriter => "https://github.com/roryg/ghostwriter.git"
        }
      },
      :mysql => {
        :bind_address => "127.0.0.1",
        :server_root_password => "foobar",
        :server_repl_password => "foobar",
        :server_debian_password => "foobar"
      }
    }

    chef.run_list = [
        "recipe[apt]",
        "recipe[postfix]",
        "recipe[mysql::server]",
        "recipe[ghost::database]",
        "recipe[ghost::default]",
        "recipe[ghost::nginx]"
    ]
  end
end
