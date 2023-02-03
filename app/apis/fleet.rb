class Fleet < Grape::API
  resource :fleets do
    params do
      requires :timestamp, type: Integer
      requires :lat, type: BigDecimal
      requires :lon, type: BigDecimal
      requires :odom_speed, type: Array[BigDecimal]
      requires :distance_covered, type: BigDecimal
      requires :waypoints_reached, type: Integer
      requires :waypoints_succesful, type: Integer
      requires :total_waypoints, type: Integer
    end
    post do
      FleetUpdateDataService.call declared(params)
    end

    post '/request_update' do
      FleetRequestUpdateService.call
    end
  end
end
