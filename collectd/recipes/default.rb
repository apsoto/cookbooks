package "collectd"
 
service "collectd" do
  supports :restart => true, :status => true
end

template "/etc/collectd.conf" do
  source "collectd.conf.erb"
  owner "root"
  group "root"
  mode "644"
  notifies :restart, resources(:service => "collectd")
end
