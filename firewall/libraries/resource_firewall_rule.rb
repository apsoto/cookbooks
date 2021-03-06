#
# Author:: Seth Chisamore (<schisamo@opscode.com>)
# Copyright:: Copyright (c) 2011 Opscode, Inc.
# License:: Apache License, Version 2.0
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

require 'chef/resource'

class Chef
  class Resource
    class FirewallRule < Chef::Resource

      IP_CIDR_VALID_REGEX = /\b(?:\d{1,3}\.){3}\d{1,3}\b(\/[0-3]?[0-9])?/

      def initialize(name, run_context=nil)
        super
        @resource_name = :firewall_rule
        @source = "0.0.0.0/0"
        @allowed_actions.push(:allow, :deny, :reject)
      end

      def port(arg=nil)
        set_or_return(
          :port,
          arg,
          :kind_of => Integer
          )
      end

      def protocol(arg=nil)
        arg.downcase! if arg
        set_or_return(
          :protocol,
          arg,
          :equal_to => [ 'udp', 'tcp' ]
          )
      end

      def direction(arg=nil)
        arg.downcase! if arg
        set_or_return(
          :direction,
          arg,
          :equal_to => [ 'in', 'out' ]
          )
      end

      def interface(arg=nil)
        arg.downcase! if arg
        set_or_return(
          :interface,
          arg,
          :kind_of => [ String ]
          )
      end

      def logging(arg=nil)
        arg.downcase! if arg
        set_or_return(
          :logging,
          arg,
          :equal_to => [ 'log', 'log-all' ]
          )
      end

      def source(arg=nil)
        set_or_return(
          :source,
          arg,
          :regex => IP_CIDR_VALID_REGEX
          )
      end

      def destination(arg=nil)
        set_or_return(
          :destination,
          arg,
          :regex => IP_CIDR_VALID_REGEX
          )
      end

      def dest_port(arg=nil)
        set_or_return(
          :dest_port,
          arg,
          :kind_of => Integer
          )
      end

      def position(arg=nil)
        set_or_return(
          :position,
          arg,
          :kind_of => Integer
          )
      end
    end
  end
end
