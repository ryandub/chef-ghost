# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  config.vm.hostname = "ghost-berkshelf"
  config.vm.box = "precise64"
  config.vm.box_url = "http://files.vagrantup.com/precise64.box"

  config.vm.network :private_network, ip: "33.33.33.10"
  config.ssh.max_tries = 40
  config.ssh.timeout   = 120
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
        :src_url => "http://9e87a4a4938b37400365-4b32c69b6a5b0272c45e310ebc459666.r98.cf2.rackcdn.com/Ghost-0.3.3.zip",
        :db_admin_password => "foobar",
        :db_password => "ghost"
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
