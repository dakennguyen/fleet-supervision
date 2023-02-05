namespace :fleet_task do
  task request_update: :environment do
    FleetRequestUpdateService.call
  end

  task no_new_update: :environment do
    FleetAlertNoNewUpdateService.call
  end
end
