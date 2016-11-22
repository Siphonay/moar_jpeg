#!/usr/bin/env ruby
# coding: utf-8
# moar_jpeg: a JPEG compression Telegram bot
# Written in Ruby by Alexis « Sam » « Siphoné » Viguié on the 22-11-2016
# No license applied

# Loading the required gems...
require 'telegram/bot'  # ... to make use of Telegram's bot API
require 'rmagick'       # ... to communicate with imagemagick
require 'open-uri'

# Exiting the program if no argument is specified
abort "please specify a telegram bot api token in argument." unless ARGV[0]

# Listen to the messages
Telegram::Bot::Client.run(ARGV[0]) do |moar_jpeg|
  moar_jpeg.listen do |message|
    bot.api.send_message(chat_id: message.chat.id, text: "Hi, #{message.from.first_name}! Please send me your images as photos. Every other messages (text, files, stickers... will be ignored. Have fun!") if message.text == "/start"
    if message.photo[0]
      compression = if message.caption.to_i.to_s == message.caption && message.caption.to_i.between?(1,100)
                      message.caption.to_i
                    else
                      90
                    end
      Magick::Image.from_blob(open("https://api.telegram.org/file/bot#{ARGV[0]}/#{moar_jpeg.api.get_file(file_id: message.photo.last.file_id)["result"]["file_path"]}").read).first.write("#{message.photo.last.file_id}.jpg") { self.quality = 100 - compression }
      moar_jpeg.api.send_photo(chat_id: message.chat.id, photo: Faraday::UploadIO.new("#{message.photo.last.file_id}.jpg", "image/jpeg"))
      File.delete("#{message.photo.last.file_id}.jpg")
    end
  end
end

abort "this should not have happened."
