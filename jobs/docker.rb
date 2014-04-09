require 'docker'
run_docker_list = Hash.new({ value: 0 })
all_docker_list = Hash.new({ value: 0 })
#
SCHEDULER.every '10s' do 
  # Please Change Docker API ENDPOINT
  Docker.url='http://127.0.0.1:4243/'
  #
  cons_run = Docker::Container.all(:running => true)
  cons_all = Docker::Container.all(:all => true)
  docker_ver = Docker.version
  docker_info = Docker.info
  #
  cons_run.each do |con|
    docker_id = con.id[0,12]
    docker_image = con.info.fetch("Image")
    run_docker_list[docker_id] = { label: docker_id, value: docker_image }
    send_event('containers', { items: run_docker_list.values })
  end
  #
  count = (cons_run.size.to_f / cons_all.size.to_f) * 100
  send_event('countmater', { value: count.round } )
  send_event('count', { current: cons_run.size } )
  #
  mem_t = %x[ cat /proc/meminfo | grep MemTotal: | awk '{print $2}' ]
  mem_f = %x[ cat /proc/meminfo | grep MemFree: | awk '{print $2}' ]
  mem_used = ( mem_f.to_f / mem_t.to_f) * 100
  send_event('memmater', { value: mem_used.round } )
  #
  cpu_i = %x[ top -n 1 -b | grep Cpu | awk '{print $5}' | sed 's/\%id,//g' ]
  cpu_u = 100 - cpu_i.to_f
  send_event('cpumater', { value: cpu_u.round } )
  #
  hostname = %x[ hostname -s]
  send_event('docker', { text: hostname } )
  send_event('docker', { moreinfo: docker_ver["Version"] } )
  send_event('allcontainers', { current: docker_info["Containers"] } )
  p docker_info["Containers"]
end
