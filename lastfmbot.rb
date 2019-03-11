require 'telegram/bot'
require 'unicode/emoji'
require_relative 'lastfmcode'
require_relative 'database'
require_relative 'sendmessages'
#the secret tokens for this bot
require_relative 'tokens'

def lastFMUser(database, bot, message)
  user = retornaUser(database, message.from.id)
    if user.empty? 
      MandaMensagem(bot, message, "Ainda não efetuou o cadastro, vem de pv")
      return false
    end
    return user
end

def errorOcorred()
  return "oi, algo deu errado"
end

def heyListen(database, message, bot, typeListen)
  user = lastFMUser(database, bot, message)
  if user != false
    info = getTrack(user, typeListen)
    printMusic(bot, message, info)
  end
end

def printArtist (bot, message, info)

  if (info == false)
    MandaMensagem(bot, message, errorOcorred())
    return
  end

  texto ="<b>#{message.from.first_name}</b> <i>already listened to</i> <b>#{info['name']} #{info['playcount']}</b> <i>times</i>"
  printing(bot, message, info, texto)
end


def printAlbum (bot, message, info)
  if (info == false)
    MandaMensagem(bot, message, errorOcorred())
    return
  end
  
  texto ="<b>#{message.from.first_name}</b> <i>already listened to</i> <b>#{info['album']}</b> <i>by</i> <b>#{info['artist']} #{info['playcount']}</b> <i>times</i>"
  printing(bot, message, info, texto)
end

def printMusic(bot, message, info)
  texto ="<b>#{message.from.first_name}</b> "

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
  bot.listen do |message|

    if (message.text.class != NilClass) 

      if message.text.include? '/newuser'

        message.text.slice!("/newuser ")
        print message.chat.username
        MandaMensagem(bot, message, incluiUser(database, message.text, message.from.id))
      end

      case message.text

        when '/listen', '/listen@MeuLastFMbot'
          heyListen(database, message, bot, 1)

        when '/minilisten', '/minilisten@MeuLastFMbot'
          heyListen(database, message, bot, 2)

        when '/textlisten', '/textlisten@MeuLastFMbot'
          heyListen(database, message, bot, 3
            )
        when '/artist', '/artist@MeuLastFMbot'
          user = lastFMUser(database, bot, message)
          if user != false 
            info = getArtist(user)
            printArtist(bot, message, info)
          end

        when '/album', '/album@MeuLastFMbot'
          user = lastFMUser(database, bot, message)
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


