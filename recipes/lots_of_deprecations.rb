log 'ready for lots of deprecations?'

log 'let us start by using some wrong node methods like:'
node.set['foo'] = true
node.set['bar'] = 'bubu'

log "fqdn: #{node.fqdn}"
log "hostname: #{node.hostname}"
log "platform: #{node.platform}"
log "platform_family: #{node.platform_family}"
log "platform_version: #{node.platform_version}"
log "environment: #{node.environment}"
log "foo: #{node.foo}"
log "bar: #{node.bar}"

ruby_block 'my special ruby block' do
  block do
    puts 'running'
  end
  action :create
end

user 'betty' do
  supports :manage_home => true
end

file '/tmp/foo.conf' do
  verify 'echo %{file}'
end

template '/tmp/bar.conf' do
  mode '0644'
  source 'bar.erb'
  only_if { 'test -f /tmp/bar.conf' }
end

execute 'echo /tmp/bar.conf' do
  subscribes 'run', 'template[/tmp/bar.conf]', 'delayed'
end

if platform?('darwin')
  file '/tmp/mac.stuff' do
    content 'I am a mac'
  end
end

service 'foo' do
  running true
  action :nothing
end

log 'this should never run' do
  not_if { File.exist?('/tmp') }
end
