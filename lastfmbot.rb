require 'telegram/bot'
require 'unicode/emoji'
require_relative 'lastfmcode'
#the secret tokens for this bot
require_relative 'tokens'

puts TOKEN

  Telegram::Bot::Client.run(TOKEN, logger: Logger.new($stderr)) do |bot|
  bot.logger.info('funcionando')
  bot.listen do |message|
    puts message.text
    case message.text
    when '/start'
      bot.api.send_photo(chat_id: message.chat.id, photo: 'https://extra.globo.com/incoming/14451917-103-193/w640h360-PROP/1cadela-assalto-campanha.jpg' ,caption: "Oi, bem vindo, para me usar digite seu usuário com /, ex.: /usuario")
    else
      if (message.text.class == NilClass)
      elsif(message.text.include? '/')
        teste = (message.text.partition("/"))
        texto = nil
        messagemm = teste[2]
        song = lastFMbo(messagemm)
        if (song == false)
          bot.api.send_message(chat_id: message.chat.id, text: "usuário inexistente")
        else
          texto =" \u{1F60D} #{message.chat.first_name} "
          if(song['isListening'])
            texto = texto + listening(song)
          else texto = texto + waslistening(song)
          end
          if(song['image']['link']!=nil)
            bot.api.send_photo(chat_id: message.chat.id, photo: "#{song['image']['link']}", caption: "#{texto}")
          else bot.api.send_message(chat_id: message.chat.id, text: "#{texto}")
          end
        end
      else
        bot.api.send_photo(chat_id: message.chat.id, photo: 'https://pbs.twimg.com/profile_images/617110894162616320/2x38ptfg_400x400.png' ,caption: "Para de tentar me prejudicar, digite seu usuário com /, ex.: /usuario")
    end
  end
end
end

