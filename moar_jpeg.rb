#!/usr/bin/env ruby
# coding: utf-8
# moar_jpeg: a JPEG compression Telegram bot
# Written in Ruby by Alexis « Sam » « Siphoné » Viguié on the 22-11-2016
# No license applied

# Loading the required gems...
require 'telegram-bot-ruby'     # ... to make use of Telegram's bot API
require 'rmagick'               # ... to communicate with imagemagick

# Exiting the program if no argument is specified
abort "please specify a telegram bot api token in argument." unless ARGV[0]

# Listen to the messages
Telegram::Bot::Client.run(token) do |moar_jpeg|
  moar_jpeg.listen do |message|
    puts "got message: #{message.text}"
    moar_jpeg.api.send_message(chat_id: message.chat.id, text: "#{message.from.first_name}, I've got your message.")
  end
end
