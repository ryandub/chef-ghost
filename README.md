chef-ghost
================
Cookbook to deploy [Ghost](http://ghost.org/) using MySQL and either Mailgun or local SMTP

Requirements
------------
#### Cookbooks
* apt 
* ark
* database
* git
* mysql
* nginx
* nodejs
* npm

Attributes
----------
* `node[:ghost][:user]` - system user to create and run Ghost service. Default is `ghost`.
* `node[:ghost][:password]` - password for Ghost user. Default is `nil`.
* `node[:ghost][:databag]` - name of databag for secrets. Default is `nil`.
* `node[:ghost][:databag_item]` - name of databag item for secrets. Default is `nil`.
* `node[:ghost][:home_dir]` - home directory for Ghost user. Default is `/home/#{node[:ghost][:user]}`.
* `node[:ghost][:db_host]` - database host. Default is `127.0.0.1`.
* `node[:ghost][:db_name]` - database name. Default is `ghost`.
* `node[:ghost][:db_user]` - database user name. Default is `ghost`.
* `node[:ghost][:db_password]` - database user password. Default is `nil`.
* `node[:ghost][:db_admin_user]` - database admin user. Default is `root`.
* `node[:ghost][:db_admin_password]` - database admin password. Default is `nil`.
* `node[:ghost][:db_grant_host]` - host to allow database connections from. Default is `127.0.0.1`.
* `node[:ghost][:domain]` - domain to use for Nginx and Ghost configuration. Default is `ghost.example.com`.
* `node[:ghost][:install_path]` - location to install ghost. Default is `/var/www/vhosts/#{node[:ghost][:domain]}`
* `node[:ghost][:src_url]` - URL to download Ghost zip.
* `node[:ghost][:mail_transport]` - local SMTP or Mailgun. Default is `local`. To use Mailgun, set to `mailgun`.
* `node[:ghost][:mail_user]` - user for SMTP auth. Default is `nil`.
* `node[:ghost][:mail_password]` - password for SMTP auth. Default is `nil`.
* `node[:ghost][:themes]` - hash of themes you would like installed. Default is empty.


Recipes
-----
### default
Installs Nodejs and npm, downloads Ghost, install dependencies, configures Ghost, creates and starts Ghost service.

### database
Connects to MySQL server and creates Ghost database, Ghost MySQL user and Ghost grants.

### nginx
Installs Nginx, creates and enables Nginx site configuration with caching and proxy_pass to Ghost.

### user
Creates Ghost user and sets password.

Resources/Providers
-------------------

### ghost\_theme

#### Actions
The default action is `:install`.
- `:install` - Downloads and installs the theme.
- `:remove` - Deletes the theme.

Both actions, when taken, will restart the ghost service.

#### Attribute Parameters
- `name` - _(Name Attribute)_, a string, name of the theme.
- `source` - a string, URL to .git, .zip or .tar.gz file.

#### Examples
```
ghost_theme "ghostwriter" do
  source "https://github.com/roryg/ghostwriter.git"
end
```

Usage
-----
### With Databags (recommended)
Create a databag like the following (in this case, the databag is called `ghost` and the databag item is called `secrets`):

```
"ghost": {
  "password": "s3cur1ty",
  "db_admin_password": "mo@rs4cur1ty",
  "db_password": "s3cur1ty"
},
"id": "secrets"
}
```

Make sure to set `node[:ghost][src_url]`!
  
Then, use a run_list like this:

```
"recipe[postfix]",
"recipe[mysql::server]",
"recipe[ghost::database]",
"recipe[ghost::default]",
"recipe[ghost::nginx]"

```

To install themes you can set the `node[:ghost][:themes]` to a hash of names and links to a Git repo (.git), ZIP file (.zip) or G-zipped Tarball (.tar.gz).
The names will be the name of the theme in your WebUI.

```
{
  "ghost": {
    "themes": {
      "n-coded": "https://github.com/polygonix/N-Coded.git",
      "swayze": "http://ghost-themes.s3.amazonaws.com/swayze/swayze.zip"
    }
  }
}


### With Vagrant
* Setup [Vagrant](http://www.vagrantup.com/).
* Install [Berkshelf](http://berkshelf.com/).
* Install `vagrant-berkshelf` and `vagrant-omnibus`:

```
vagrant plugin install vagrant-berkshelf
vagrant plugin install vagrant-omnibus
```

* Change the passwords in the `Vagrantfile` if you desire.

* ```vagrant up```

Contributing
------------

1. Fork the repository on Github
2. Create a named feature branch (like `add_component_x`)
3. Write you change
6. Submit a Pull Request using Github

License and Authors
-------------------
Authors: Ryan Walker
