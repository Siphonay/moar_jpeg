#!/usr/bin/env ruby
# coding: utf-8
# moar_jpeg: a JPEG compression Telegram bot
# Written in Ruby by Alexis « Sam » « Siphoné » Viguié on the 22-11-2016
# No license applied

# Loading the required gems...
require 'telegram_bot'   # ... to make use of Telegram's bot API
require 'rmagick'        # ... to communicate with imagemagick

# Exiting the program if no argument is specified
abort "please specify a telegram bot api token in argument." unless ARGV[0]

# Create the bot instance with the token passed as an argument
moar_jpeg = TelegramBot.new(token: ARGV[0])

# Processing every message the bot recieves
moar_jpeg.get_updates(fail_silently: true) do |message|
  puts "got message: #{message.text}"
end
