namespace :fleet_task do
  task request_update: :environment do
    FleetRequestUpdateService.call
  end

  task no_new_update: :environment do
    FleetAlertNoNewUpdateService.call
  end

  task demo_script: :environment do
    waypoint_reached = 0
    total_waypoints = 50

    current_lat = 38.8901
    current_lon = -77.0414

    while waypoint_reached <= total_waypoints
      random_interval = rand(7..20)
      p [waypoint_reached, total_waypoints, "wait for another #{random_interval} seconds"]
      p [current_lat, current_lon]
      HTTParty.post(
        'http://localhost:3000/fleets',
        headers: {
          'Content-Type' => 'application/json'
        },
        body: {
          timestamp: Time.current.to_i,
          lat: current_lat,
          lon: current_lon,
          odom_speed: [12.3, 10.4, 10.6],
          distance_covered: 1002.32,
          waypoints_reached: waypoint_reached,
          waypoints_succesful: 10,
          total_waypoints: total_waypoints
        }.to_json
      )

      break if waypoint_reached == total_waypoints

      random_waypoints = rand(1..(total_waypoints - waypoint_reached))
      waypoint_reached += random_waypoints
      current_lat += random_waypoints * 0.0001
      current_lon += random_waypoints * 0.0001
      sleep(random_interval)
    end
    FleetAlertNoNewUpdateService.call
  end
end
