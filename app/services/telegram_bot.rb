# frozen_string_literal: true

class TelegramBot
  CHAT_ID = 607_324_799

  def call(text)
    HTTParty.post(
      "https://api.telegram.org/bot#{ENV['API_KEY']}/sendMessage",
      headers: {
        'Content-Type' => 'application/json'
      },
      body: {
        chat_id: CHAT_ID,
        text: text
      }.to_json
    )
  end
end
