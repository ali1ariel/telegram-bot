require 'telegram/bot'
require 'unicode/emoji'
require_relative 'lastfmcode'
require_relative 'database'
require_relative 'sendmessages'
#the secret tokens for this bot
require_relative 'tokens'

def lastFMUser(database, id, bot, message)
  user = retornaUser(database, id)
    if user.empty? 
      MandaMensagem(bot, message, "Ainda não efetuou o cadastro, vem de pv")
      return false
    end
    return user
end

def errorOcorred()
  return "oi, algo deu errado"
end


def printArtist (bot, message, info)
  texto ="<b>#{message.chat.first_name}</b> <i>already listened to</i> <b>#{info['name']} #{info['playcount']}</b>\u{2716} <i> times</i>"

  if (info == false)
    MandaMensagem(bot, message, errorOcorred())
    return
  end
  printing(bot, message, info, texto)
end


def printAlbum (bot, message, info)
  texto ="<b>#{message.chat.first_name}</b> <i>already listened to</i> <b>#{info['album']}</b> <i>by</i> <b>#{info['artist']} #{info['playcount']}</b> \u{2716} <i>times</i>"

  if (info == false)
    MandaMensagem(bot, message, errorOcorred())
    return
  end

  printing(bot, message, info, texto)
end

def printMusic(bot, message, info)
  texto ="<b>#{message.chat.first_name}</b> "

  if (info == false)
    MandaMensagem(bot, message, errorOcorred())
    return
  elsif(info['isListening'])
    texto = texto + listening(info)
  else texto = texto + waslistening(info)
  end

  printing(bot, message, info, texto)
end

def printing(bot, message, info, texto)
  if(info['image']['link']!=nil)
    foto = info['image']['link']
    MandaFoto(bot, message, foto, texto)
  else  MandaMensagem(bot, message, texto)
  end
end 


Telegram::Bot::Client.run(TOKEN) do |bot|
  database = iniciaServidor()
  #bot.logger.info('funcionando')
  
  bot.listen do |message|

    if (message.text.class != NilClass) 

      if message.text.include? '/newuser'
        message.text.slice!("/newuser ")
        print message.chat.username
        MandaMensagem(bot, message, incluiUser(database, message.text, message.from.id))
      end

      case message.text

        when '/listen', '/listen@MeuLastFMbot'
          user = lastFMUser(database, message.from.id, bot, message)
          if user != false
            info = getTrack(user, 1)
            printMusic(bot, message, info)
          end
        when '/minilisten', '/minilisten@MeuLastFMbot'
          user = lastFMUser(database, message.from.id, bot, message)
          if user != false
            info = getTrack(user, 2)
            printMusic(bot, message, info)
          end

        when '/textlisten', '/textlisten@MeuLastFMbot'
          user = lastFMUser(database, message.from.id, bot, message)
          if user != false
            info = getTrack(user, 3)
            printMusic(bot, message, info)
          end

        when '/artist', '/artist@MeuLastFMbot'
          user = lastFMUser(database, message.from.id, bot, message)
          if user != false 
            info = getArtist(user)
            printArtist(bot, message, info)
          end

        when '/album', '/album@MeuLastFMbot'
          user = lastFMUser(database, message.from.id, bot, message)
          if user != false
            info = getAlbum(user)
            printAlbum(bot, message, info)
          end

        when '/start'
          foto = 'https://extra.globo.com/incoming/14451917-103-193/w640h360-PROP/1cadela-assalto-campanha.jpg'
          legenda = "Oi, bem vindo, para me usar digite /newuser seguido do seu nome de usuario.\nex.: '/newuser thiago'\nse errar, não tem problema, faça de novo.\nPara mostrar o scrobble use o /listen"
          MandaFoto(bot, message, foto, legenda)
        when '/help', '/help@MeuLastFMbot'
          texto = "Oi, para me usar digite /newuser seguido do seu nome de usuario.\nex.: '/newuser thiago'\n Para mostrar o scrobble use o /listen"
          MandaMensagem(bot, message, texto)
        else
      end
    end
  end
end


