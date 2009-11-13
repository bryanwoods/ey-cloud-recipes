script "install-mongo" do
  interpreter "bash"
  user "root"
  cwd "/usr/local"
  code <<-EOH
  wget -O - http://downloads.mongodb.org/linux/mongodb-linux-x86_64-1.0.1.tgz | tar xzf -
  ln -nfs mongodb-linux-x86_64-1.0.1 mongodb
  EOH
  not_if { File.directory?("/usr/local/mongodb-x86_64-1.0.1") }
end

directory "/db/mongodb/masterdb" do
  owner node[:owner_name]
  group node[:owner_name]
  mode 0755
  recursive true
  not_if { File.directory?("/db/mongodb/masterdb") }
end

directory "/db/mongodb/slavedb" do
  owner node[:owner_name]
  group node[:owner_name]
  mode 0755
  recursive true
  not_if { File.directory?("/db/mongodb/slavedb") }
end

remote_file "/etc/init.d/mongodb" do
  source "mongodb"
  owner "root"
  group "root"
  mode 0755
end

# service "mongodb" do
#   action [ :start ]
# end

execute "run-mongodb" do
  command %Q{
    /etc/init.d/mongodb start
  }
end
