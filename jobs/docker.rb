require 'docker'
run_docker_list = Hash.new({ value: 0 })
all_docker_list = Hash.new({ value: 0 })
#
SCHEDULER.every '10s' do 
  # Please Change Docker API ENDPOINT
  Docker.url='http://172.17.42.1:4243/'
  #
  cons_run = Docker::Container.all(:running => true)
  cons_all = Docker::Container.all(:all => true)
  #
  cons_run.each do |con|
    docker_id = con.id[0,12]
    docker_name = con.info.fetch("Names")
    run_docker_list[docker_id] = { label: docker_id, value: docker_name }
    send_event('containers', { items: run_docker_list.values })
  end
  #
  cons_all.each do |con|
    docker_id = con.id[0,12]
    docker_name = con.info.fetch("Names")
    all_docker_list[docker_id] = { label: docker_id, value: docker_name }
    send_event('allcontainers', { items: all_docker_list.values })
  end
  #
  count = (cons_run.size.to_f / cons_all.size.to_f) * 100
  send_event('countmater', { value: count.round } )
  send_event('count', { current: cons_run.size } )
end
