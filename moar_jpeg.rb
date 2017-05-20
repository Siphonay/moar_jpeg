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

# Do a loop to prevent the script from crashing if it can't reach telegram
begin
  # Listen to the messages
  Telegram::Bot::Client.run(ARGV[0]) do |moar_jpeg|
    moar_jpeg.listen do |message|
      if message.photo[0]                                                                                                                                                                                                                                                       # If the message contains an image :
        compression = if message.caption.to_i.to_s == message.caption && message.caption.to_i.between?(1,100)     # If compression is specified
                        message.caption.to_i - 1                                                                  # use it.
                      else                                                                                        # Else,
                        94                                                                                        # set the default rate.
                      end
        Magick::Image.from_blob(open("https://api.telegram.org/file/bot#{ARGV[0]}/#{moar_jpeg.api.get_file(file_id: message.photo.last.file_id)["result"]["file_path"]}").read).first.write("#{message.photo.last.file_id}.jpg") { self.quality = 100 - compression }   # Download the sent image, compress it and save it
        moar_jpeg.api.send_photo(chat_id: message.chat.id, photo: Faraday::UploadIO.new("#{message.photo.last.file_id}.jpg", "image/jpeg"))                                                                                                                             # Send the saved image
        File.delete("#{message.photo.last.file_id}.jpg")                                                                                                                                                                                                                # Delete the saved image
      else                                                                                                                                                                                                                                                                      # Else,
        moar_jpeg.api.send_message(chat_id: message.chat.id, text: if message.text == "/start"                                                                                                                                  # If the user is starting the bot,
                                   "Hi, #{message.from.first_name}! Please send me your images as photos. You can also specify a number between 1 and 100 in its caption to select the conmpression level! (defaults at 94)"    # Tell him the instructions.
                                  else                                                                                                                                                                                          # Else,
                                    "Please include a photo in your message!"                                                                                                                                                   # Remind the user that the bot needs a photo.
                                   end)
      end
    end
  end
rescue => error
  # Handling exceptions
  STDERR.puts "got an exception: #{error}"      # Put what the exception is on the error output
  retry                                         # Launch the script again
end
