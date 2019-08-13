require 'telegram/bot'
require 'unicode/emoji'
require_relative 'lastfmapi'
require_relative 'lastfmcode'
require_relative 'sendmessages'
require_relative 'tokens'

def runBot()
	Telegram::Bot::Client.run(TOKEN) do |bot|
		 bot.listen do |message|
			case message
			when Telegram::Bot::Types::Message
				Thread.new {
					puts "#{Time.now} ENTRADA"
					if (message.from.first_name == 'Alisson Ariel')#|| message.from.username == 'allymaine')
						puts 'ta entrando?!'
						case 
							when message.text.include?('/start')


							when message.text.include?('/album')
								user = message.text[7..]

								begin MandaMensagem(bot, message, getAlbum(user, message.from.first_name))
								rescue
									puts "error"
								end

								
							when message.text.include?('/listen')
								user = message.text[7..]

								begin MandaMensagem(bot, message, getListening(user, message.from.first_name))
								rescue
									puts "error"
								end


							when message.text.include?('/artist')
								user = message.text[8..]

								begin MandaMensagem(bot, message, getArtist(user, message.from.first_name))
								rescue
									puts "error"
								end


							else											
							
								begin MandaMensagem(bot, message, getListening(message.text, message.from.first_name))
								rescue
									puts "error"
								end
												
						end 		
					end
					puts "#{Time.now} SAÍDA"
				}
			end
		end
	end
end
#FUNÇÃO QUE COLOCA O BOT EM RECURSÃO, ASSIM, SEMPRE QUE QUEBRA, REINICIA.
def recursiveBot()
	begin runBot
	rescue Telegram::Bot::Exceptions::ResponseError
		recursiveBot()
	end
end

##MAIN
recursiveBot