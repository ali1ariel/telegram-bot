require 'telegram/bot'
require 'unicode/emoji'
require_relative 'lastfmcode'
require_relative 'database'
#the secret tokens for this bot
require_relative 'tokens'

def MandaMensagem(bot, message, texto)
  bot.api.send_message(chat_id: message.chat.id, text: "#{texto}", reply_to_message_id: message.message_id)
end

def MandaFoto(bot, message, foto, legenda = nil)
  bot.api.send_photo(chat_id: message.chat.id, photo: foto ,caption: legenda, reply_to_message_id: message.message_id)
end

def centralbot(bot, message, song)
  texto ="#{message.chat.first_name} "
  if (song == false)
    MandaMensagem(bot, message, "oi, algo deu errado, mas estamos consertando")
    return
  elsif(song['isListening'])
    texto = texto + listening(song)
  else texto = texto + waslistening(song)
  end
  if(song['image']['link']!=nil)
    foto = song['image']['link']
    MandaFoto(bot, message, foto, texto)
  else  MandaMensagem(bot, message, texto)
  end

end 


  Telegram::Bot::Client.run(TOKEN, logger: Logger.new($stderr)) do |bot|
  database = iniciaServidor()
  bot.logger.info('funcionando')
  
  bot.listen do |message|
    case message.text

    when '/newuser'
      bot.api.send_message(chat_id: message.chat.id, text: "O cadastro... me manda teu user aí", reply_to_message_id: message.message_id)
      bot.listen do |usuario|
        MandaMensagem(bot, message, incluiUser(database, usuario.text, message.from.id))
        break
      end
    when '/listen'
      user = retornaUser(database, message.from.id)
      if user.empty? 
        MandaMensagem(bot, message, "Ainda não efetuou o cadastro")
      else
        song = lastFMbo(user)
        centralbot(bot, message, song)
      end
    when '/start'
      foto = 'https://extra.globo.com/incoming/14451917-103-193/w640h360-PROP/1cadela-assalto-campanha.jpg'
      legenda = "Oi, bem vindo, para me usar digite /newuser e se cadastre, para mostrar o scrobble use o /listen"
      MandaFoto(bot, message, foto, legenda)
    when '/help'
      texto = "Oi, bem vindo, para me usar envie /newuser e espere a mensagem para se cadastrar, para mostrar o scrobble use o /listen"
      MandaMensagem(bot, message, texto)
    end
end
end

