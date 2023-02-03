# frozen_string_literal: true

class TelegramBot
  CHAT_ID = 607_324_799

  def call(**params)
    HTTParty.post(
      "https://api.telegram.org/bot#{ENV['API_KEY']}/sendMessage",
      headers: {
        'Content-Type' => 'application/json'
      },
      body: {
        chat_id: CHAT_ID,
        text: text(params)
      }.to_json
    )
  end

  private

  def text(params)
    return 'No data' if params.blank?

    <<~TEXT.strip
      Completion percentage: #{params[:completion_percentage]}
      Time since last update in seconds: #{params[:time_since_last_update_in_seconds]}
      Google map link: #{params[:google_map_link]}
    TEXT
  end
end
