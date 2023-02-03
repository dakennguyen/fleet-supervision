namespace :fleet_task do
  task request_update: :environment do
    FleetRequestUpdateService.call
  end
end
