require 'docker'
# :first_in sets how long it takes before the job is first run. In this case, it is run immediately
SCHEDULER.every '10s' do
  Docker.url='http://172.17.42.1:4243/'
  running = Docker::Container.all(:running => true)
  all = Docker::Container.all(:all => true)
  count = (running.size.to_f / all.size.to_f) * 100
  send_event('countmater', { value: count.round } )
  send_event('count', { current: running.size } )
end
