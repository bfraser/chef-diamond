include_recipe 'build-essential'
include_recipe 'git::default'

case node['platform_family']
when 'debian'
  include_recipe 'apt::default'

  # needed to generate deb package
  package 'devscripts'
  package 'python-support'
  package 'python-configobj'
  package 'python-mock'
  package 'cdbs'
when 'rhel'
  include_recipe 'yum::default'

  package 'python-configobj'
  package 'rpm-build'
end

# TODO: move source directory to an attribute
git node['diamond']['source']['path'] do
  repository node['diamond']['source']['repository']
  reference node['diamond']['source']['reference']
  action :sync
  notifies :run, 'execute[build diamond]', :immediately
end

case node['platform_family']
when 'debian'
  execute 'build diamond' do
    command "cd #{node['diamond']['source']['path']};make builddeb"
    action :nothing
    notifies :run, 'execute[install diamond]', :immediately
  end

  execute 'install diamond' do
    command "cd #{node['diamond']['source']['path']};dpkg -i build/diamond_*_all.deb"
    action :nothing
    notifies :restart, 'service[diamond]'
  end

else
  # TODO: test this
  execute 'build diamond' do
    command "cd #{node['diamond']['source']['path']};make buildrpm"
    action :nothing
    notifies :run, 'execute[install diamond]', :immediately
  end

  execute 'install diamond' do
    command "cd #{node['diamond']['source']['path']};rpm -ivh dist/*.noarch.rpm"
    action :nothing
    notifies :restart, 'service[diamond]'
  end
end
