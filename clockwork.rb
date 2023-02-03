require 'clockwork'

module Clockwork
  every(10.seconds, 'notify user every 15 minutes') { `rake fleet_task:request_update` }
end
