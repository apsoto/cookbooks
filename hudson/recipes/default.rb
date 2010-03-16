#
# Cookbook Name:: hudson
# Recipe:: default
#
# Copyright 2010, Opscode, Inc.
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

# install via rpm
if platform?("centos", "redhat", "fedora")
	remote_file "/etc/yum.repos.d/hudson.repo" do
		source "http://hudson-ci.org/redhat/hudson.repo"
	end

	execute "import_hudson_org_key" do
		command "rpm --import http://hudson-ci.org/redhat/hudson-ci.org.key"
		not_if "rpm -qa gpg-pubkey* | grep gpg-pubkey-d50582e6-4a3feef6"
	end

	package "hudson"

	service "hudson" do
		supports [:restart]
	end

  template "/etc/sysconfig/hudson" do
    source "hudson_sysconfig.erb"
    notifies :restart, resources(:service => "hudson")
  end
	
end
