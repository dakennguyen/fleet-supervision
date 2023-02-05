require 'clockwork'

module Clockwork
  every(30.seconds, 'notify user every 30 seconds') { `rake fleet_task:request_update` }
  every(10.seconds, 'notify user if there is no new update') { `rake fleet_task:no_new_update` }
end
