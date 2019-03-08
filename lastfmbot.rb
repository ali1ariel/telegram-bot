require 'telegram/bot'
require 'unicode/emoji'
require_relative 'lastfmcode'
require_relative 'database'
require_relative 'sendmessages'
#the secret tokens for this bot
require_relative 'tokens'



def printArtist (bot, message, info)
  texto ="#{message.chat.first_name} already listened to #{info['name']} #{info['playcount']} times"

  if (info == false)
    MandaMensagem(bot, message, "oi, algo deu errado, mas estamos consertando")
    return
  end
  if(info['image']['link']!=nil)
    foto = info['image']['link']
    MandaFoto(bot, message, foto, texto)
  else  MandaMensagem(bot, message, texto)
  end 
end


def printAlbum (bot, message, info)
  texto ="#{message.chat.first_name} already listened to #{info['name']} #{info['playcount']} times"

  if (info == false)
    MandaMensagem(bot, message, "oi, algo deu errado, mas estamos consertando")
    return
  end
  if(info['image']['link']!=nil)
    foto = info['image']['link']
    MandaFoto(bot, message, foto, texto)
  else  MandaMensagem(bot, message, texto)
  end 
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

    puts message.from.username

    infos = bot.api.get_chat(chat_id: message.chat.id)
   



    if (message.from.id == '600614550'.to_i)  
      if message.text.include? '/newuser'
        message.text.slice!("/newuser ")
        print message.chat.username
        MandaMensagem(bot, message, incluiUser(database, message.text, message.from.id))
      end
      case message.text
      when '/listen', '/listen@MeuLastFMbot'
        user = retornaUser(database, message.from.id)
        if user.empty? 
          MandaMensagem(bot, message, "Ainda não efetuou o cadastro, vem de pv")
        else
          song = getTrack(user)
          centralbot(bot, message, song)
        end

      when '/artist'
        user = retornaUser(database, message.from.id)
        if user.empty? 
          MandaMensagem(bot, message, "Ainda não efetuou o cadastro, vem de pv")
        else
          info = getArtist(user)
          printArtist(bot, message, info)
        end


      when '/album'
        user = retornaUser(database, message.from.id)
        if user.empty? 
          MandaMensagem(bot, message, "Ainda não efetuou o cadastro, vem de pv")
        else
          info = getAlbum(user)
          printAlbum(bot, message, info)
        end

      when '/start'
        foto = 'https://extra.globo.com/incoming/14451917-103-193/w640h360-PROP/1cadela-assalto-campanha.jpg'
        legenda = "Oi, bem vindo, para me usar digite /newuser seguido do seu nome de usuario.\nex.: '/newuser thiago'\nse errar, não tem problema, faça de novo.\nPara mostrar o scrobble use o /listen"
        MandaFoto(bot, message, foto, legenda)
      when '/help'
        texto = "Oi, para me usar digite /newuser seguido do seu nome de usuario.\nex.: '/newuser thiago'\n Para mostrar o scrobble use o /listen"
        MandaMensagem(bot, message, texto)
      else
      end
    end
  end
end


