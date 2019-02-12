require 'telegram/bot'
require 'unicode/emoji'
#the secret tokens for this bot
require_relative 'tokens'

def MandaMensagem(bot, message, texto)
  bot.api.send_message(chat_id: message.chat.id, text: "#{texto}")
end

def MandaFoto(bot, message, foto, legenda = nil)
  bot.api.send_photo(chat_id: message.chat.id, photo: foto ,caption: legenda)
end



Telegram::Bot::Client.run(TOKEN, logger: Logger.new($stderr)) do |bot|
  bot.logger.info('funcionando')
  
  bot.listen do |message|
    case message.text
      when '/start'
        foto = 'http://blogs.discovermagazine.com/inkfish/files/2017/06/1198735762_cc7928d694_z.jpg'
        legenda = "Oi, agora estou em manutenção tá, testa depois tá bom?"
        MandaFoto(bot, message, foto, legenda)
      else
        foto = 'http://blogs.discovermagazine.com/inkfish/files/2017/06/1198735762_cc7928d694_z.jpg'
          legenda = "Oi, agora estou em manutenção tá, testa depois tá bom?"
          MandaFoto(bot, message, foto, legenda)
    end
  end
end
