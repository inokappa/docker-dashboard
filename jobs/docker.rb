require 'docker'
docker_list = Hash.new({ value: 0 })

SCHEDULER.every '10s' do 
  Docker.url='http://172.17.42.1:4243/'
  cons = Docker::Container.all(:running => true)
  cons.each do |con|
    $docker_id = con.id[0,12]
    $docker_name = con.info.fetch("Names")
    docker_list[$docker_id] = { label: $docker_id, value: $docker_name }
    send_event('containers', { items: docker_list.values })
  end
end
