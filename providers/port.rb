#
# Cookbook Name:: firewalld
# Provider:: port
#
# Copyright:: 2015, Jeff Hutchison

action :add do
  e = execute 'add open port to zone' do
    not_if "firewall-cmd --permanent #{zone} --query-port=#{new_resource.port}"
    command "firewall-cmd #{zone} --add-port=#{new_resource.port}; " +
    "firewall-cmd --permanent #{zone} --add-port=#{new_resource.port}"
  end
  new_resource.updated_by_last_action(e.updated_by_last_action?)
end

action :remove do
  e = execute 'remove open port from zone' do
    only_if "firewall-cmd --permanent #{zone} --query-port=#{new_resource.port}"
    command "firewall-cmd #{zone} --remove-port=#{new_resource.port}; " +
    "firewall-cmd --permanent #{zone} --remove-port=#{new_resource.port}"
  end
  new_resource.updated_by_last_action(e.updated_by_last_action?)
end

def zone
  new_resource.zone ? "--zone=#{new_resource.zone}" : ''
end