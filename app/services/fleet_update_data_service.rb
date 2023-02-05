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

  def redis
    @redis ||= Redis.new
  end

  def last_call_timestamp
    @last_call_timestamp ||= redis.get('last_call_timestamp').to_i
  end
end
