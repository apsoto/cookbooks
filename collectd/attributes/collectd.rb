default.collectd.interval = 10
default.collectd.read_threads = 5
default.collectd.server_address = ""
default.collectd.listen_address = nil
default.collectd.plugins = [
  { "name" => "syslog", "options" => [{ "LogLevel" => "Info"  }]},
  { "name" => "cpu" },
  { "name" => "df", "options" => block_device.keys.find_all{|dev| dev =~ /^s/}.collect{|fs| {"Device" => "/dev/#{fs}"}}},
  { "name" => "disk", "options" => block_device.keys.find_all{|dev| dev =~ /^s/}.collect{|dev| {"Disk" => dev}}},
  { "name" => "interface", "options" => network.interfaces.keys.collect {|itf| {"Interface" => itf} } },
  { "name" => "memory" },
  { "name" => "swap" }
]

