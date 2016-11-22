#!/usr/bin/env ruby
# coding: utf-8
# moar_jpeg: a JPEG compression Telegram bot
# Written in Ruby by Alexis « Sam » « Siphoné » Viguié on the 22-11-2016
# No license applied

# Loading the required libs
require 'telegram/bot'  # to make use of Telegram's bot API
require 'rmagick'       # to communicate with imagemagick
require 'open-uri'      # to open an image with its URL

# Exiting the program if no argument is specified
abort "please specify a telegram bot api token in argument." unless ARGV[0]

# Listen to the messages
Telegram::Bot::Client.run(ARGV[0]) do |moar_jpeg|
  moar_jpeg.listen do |message|
    moar_jpeg.api.send_message(chat_id: message.chat.id, text: "Hi, #{message.from.first_name}! Please send me your images as photos. Every other messages (text, files, stickers...) will be ignored. Have fun!") if message.text == "/start"                          # Display introduction text if the user starts the bot
    if message.photo[0]                                                                                                                                                                                                                                                 # Reply if the message contains an image
      compression = if message.caption.to_i.to_s == message.caption && message.caption.to_i.between?(1,100)     # If compression is specified
                      message.caption.to_i - 1                                                                  # use it.
                    else                                                                                        # Else,
                      94                                                                                        # set the default rate.
                    end
      Magick::Image.from_blob(open("https://api.telegram.org/file/bot#{ARGV[0]}/#{moar_jpeg.api.get_file(file_id: message.photo.last.file_id)["result"]["file_path"]}").read).first.write("#{message.photo.last.file_id}.jpg") { self.quality = 100 - compression }     # Download the sent image, compress it and save it
      moar_jpeg.api.send_photo(chat_id: message.chat.id, photo: Faraday::UploadIO.new("#{message.photo.last.file_id}.jpg", "image/jpeg"))                                                                                                                               # Send the saved image
      File.delete("#{message.photo.last.file_id}.jpg")                                                                                                                                                                                                                  # Delete the saved image
    end
  end
end

abort "this should not have happened."  # Throw an error message in case the program stops
