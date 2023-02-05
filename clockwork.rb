require 'clockwork'

module Clockwork
  every(15.minutes, 'notify user every 15 minutes') { `rake fleet_task:request_update` }
  every(2.minutes, 'notify user if there is no new update') { `rake fleet_task:no_new_update` }
end
