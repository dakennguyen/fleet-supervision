# frozen_string_literal: true

class FleetUpdateDataService
  attr_reader :data

  def self.call(data)
    new(data).call
  end

  def initialize(data)
    @data = data
  end

  def call
    notify_user if no_new_update_after_2_minutes
    save_data
    save_last_call_timestamp
  end

  private

  def save_data
    redis.set('payload', data.to_json)
  end

  def save_last_call_timestamp
    redis.set('last_call_timestamp', Time.current.to_i)
  end

  def notify_user
    telegram_bot.call(
      completion_percentage: completion_percentage,
      time_since_last_update_in_seconds: time_since_last_update,
      google_map_link: google_map_link
    )
  end

  def redis
    @redis = Redis.new
  end

  def no_new_update_after_2_minutes
    return true if last_call_timestamp.zero?

    time_since_last_update > 5.seconds
  end

  def time_since_last_update
    @time_since_last_update ||= Time.now - Time.at(last_call_timestamp)
  end

  def last_call_timestamp
    @last_call_timestamp ||= redis.get('last_call_timestamp').to_i
  end

  def google_map_link
    "http://maps.google.com/maps?q=#{data[:lat]},#{data[:lon]}"
  end

  def telegram_bot
    @telegram_bot ||= TelegramBot.new
  end

  def completion_percentage
    @completion_percentage ||= data[:waypoints_reached] * 100.0 / data[:total_waypoints]
  end
end
