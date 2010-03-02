#
# Cookbook Name:: activemq
# Recipe:: default
#
# Copyright 2009, Opscode, Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

include_recipe "java"

version = node[:activemq][:version]
mirror = node[:activemq][:mirror]
activemq_home = "/opt/apache-activemq-#{version}"
# publish install location so you can drop in your own activemq.xml in your own recipes
node[:activemq][:home] = activemq_home

unless File.exists?("#{activemq_home}/bin/activemq")
  remote_file "/tmp/apache-activemq-#{version}-bin.tar.gz" do
    source "#{mirror}/apache/activemq/apache-activemq/#{version}/apache-activemq-#{version}-bin.tar.gz"
    mode "0644"
  end

  execute "tar zxf /tmp/apache-activemq-#{version}-bin.tar.gz" do
    cwd "/opt"
  end
end

file "#{activemq_home}/bin/activemq" do
  owner "root"
  group "root"
  mode "0755"
end

if platform?("ubuntu", "debian")
  runit_service "activemq"
elsif platform?("redhat", "centos")
  # not quite right if running on non x86 architectures
  arch = (node[:kernel][:machine] == "x86_64") ? "x86-64" : "x86-32"

  # symlink the initd script provided in the distro
  link "/etc/init.d/activemq" do
    to "#{activemq_home}/bin/linux-#{arch}/activemq"
  end

  service "activemq" do
    supports  :start => true, :stop => true, :restart => true, :status => true 
    action [:enable, :start]
  end

  # symlink so the default wrapper.conf can find the native wrapper library
  link "#{activemq_home}/bin/linux" do
    to "#{activemq_home}/bin/linux-#{arch}"
  end

  # symlink the wrapper's pidfile location into /var/run
  link "/var/run/activemq.pid" do
    to "#{activemq_home}/bin/linux/ActiveMQ.pid"
  end

  template "#{activemq_home}/bin/linux/wrapper.conf" do
    source "wrapper.conf.erb"
    mode 0644
    variables(:pidfile => "/var/run/activemq.pid")
    notifies :restart, resources(:service => "activemq")
  end

end
