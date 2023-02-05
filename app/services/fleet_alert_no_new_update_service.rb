# frozen_string_literal: true

class FleetAlertNoNewUpdateService
  attr_reader :data

  def self.call
    new.call
  end

  def call
    payload = redis.get('payload')
    return notify_user if payload.nil?

    @data = JSON.parse(payload).with_indifferent_access
    notify_user if no_new_update_after_2_minutes
  end

  private

  def notify_user
    telegram_bot.call('There is no update for the last 10 seconds')
  end

  def redis
    @redis ||= Redis.new
  end

  def no_new_update_after_2_minutes
    return true if last_call_timestamp.zero?

    time_since_last_update > 10.seconds
  end

  def time_since_last_update
    @time_since_last_update ||= Time.now - Time.at(last_call_timestamp)
  end

  def last_call_timestamp
    @last_call_timestamp ||= redis.get('last_call_timestamp').to_i
  end

  def telegram_bot
    @telegram_bot ||= TelegramBot.new
  end
end
