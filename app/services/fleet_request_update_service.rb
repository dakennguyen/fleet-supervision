# frozen_string_literal: true

class FleetRequestUpdateService
  attr_reader :data

  def self.call
    new.call
  end

  def call
    payload = redis.get('payload')
    return notify_user_with_no_data if payload.nil?

    @data = JSON.parse(payload).with_indifferent_access
    notify_user
  end

  private

  def notify_user
    telegram_bot.call(
      completion_percentage: completion_percentage,
      time_since_last_update_in_seconds: time_since_last_update.to_i,
      google_map_link: google_map_link
    )
  end

  def notify_user_with_no_data
    telegram_bot.call
  end

  def redis
    @redis = Redis.new
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
