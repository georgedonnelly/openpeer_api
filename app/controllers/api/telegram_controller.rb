# app/controllers/api/telegram_controller.rb
require 'telegram/bot'

module Api
  class TelegramController < ApplicationController
    skip_before_action :verify_authenticity_token

    def webhook
      Rails.logger.info "Received webhook request with params: #{params.inspect}"

      message = params[:message]
      
      if message && message[:text]
        if message[:text].start_with?('/start')
          unique_identifier = extract_unique_identifier(message[:text])
          Rails.logger.info "Extracted unique identifier: #{unique_identifier}"

          if unique_identifier
            user = User.find_by(unique_identifier: unique_identifier)
            Rails.logger.info "User found: #{user.inspect}"

            if user
              chat_id = message[:chat][:id]
              username = message[:from][:username]
              Rails.logger.info "Updating user with chat_id: #{chat_id}, username: #{username}"

              if User.exists?(telegram_user_id: chat_id) && User.find_by(telegram_user_id: chat_id) != user
                Rails.logger.warn "Telegram ID #{chat_id} is already associated with another account."
                send_message(chat_id, "This Telegram ID is already associated with another account.")
              else
                user.update(telegram_user_id: chat_id, telegram_username: username)
                send_welcome_message(chat_id, user.name)
              end
            else
              Rails.logger.warn "User not found with unique identifier: #{unique_identifier}"
              send_message(message[:chat][:telegram_user_id], "User not found. Please make sure you entered the correct unique identifier.")
            end
          else
            Rails.logger.warn "Unique identifier not provided in message: #{message[:text]}"
            send_message(message[:chat][:telegram_user_id], "Please provide your unique identifier after the /start command.")
          end
        end
      end

      head :ok
    end

    private

    def extract_unique_identifier(text)
      text.split(' ').second
    end

    def send_message(chat_id, text)
      Telegram::Bot::Client.run(ENV['TELEGRAM_BOT_TOKEN']) do |bot|
        bot.api.send_message(chat_id: chat_id.to_s, text: text)
      end
    rescue StandardError => e
      Rails.logger.error "Failed to send message: #{e.message}"
    end

    def send_welcome_message(chat_id, user_name)
      message = "GM #{user_name}. Welcome! You have just subscribed to receive OpenPeer trade notifications. Your unique chat ID is #{chat_id}. Please make sure I'm not muted!"
      send_message(chat_id, message)
    end
  end
end