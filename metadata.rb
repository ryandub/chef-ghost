name             'ghost'
maintainer       'Rackspace'
maintainer_email 'ryan.walker@rackspace.com'
license          'Apache 2.0'
description      'Installs/Configures Ghost CMS'
version          '0.0.1'

%w{ ark database firewall git mysql nginx nodejs npm }.each do |cb|
  depends cb
end
