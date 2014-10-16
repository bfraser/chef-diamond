default['diamond']['install_method'] = 'source'

# Attributes for source installation
default['diamond']['source']['path'] = '/usr/local/share/diamond_src'
default['diamond']['source']['repository'] = 'git://github.com/BrightcoveOS/Diamond.git'
default['diamond']['source']['reference'] = 'master'

# Chef role for Graphite
default['diamond']['graphite']['role'] = nil

# Graphite server hostname
default['diamond']['graphite']['server'] = 'graphite'

# Default collector settings
default['diamond']['collectors']['default']['path_prefix'] = 'servers'
default['diamond']['collectors']['default']['interval'] = '300'

default['diamond']['handlers'] = 'diamond.handler.graphite.GraphiteHandler, diamond.handler.archive.ArchiveHandler'

default['diamond']['add_collectors'] = %w(cpu diskspace diskusage loadavg memory network vmstat tcp)
case node['platform_family']
when 'debian'
  default['diamond']['version'] = '3.0.2'
when 'rhel'
  default['diamond']['version'] = '3.0.2-0'
else
  default['diamond']['install_method'] = 'source'
end
