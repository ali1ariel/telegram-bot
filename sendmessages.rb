
def MandaMensagem(bot, message, texto)
    begin
      bot.api.send_message(chat_id: message.chat.id, text: "#{texto}", reply_to_message_id: message.message_id)
    rescue
      puts "quase deu erro \n\n"
    end
  end
  
  def MandaFoto(bot, message, foto, legenda = nil)
    begin
      bot.api.send_photo(chat_id: message.chat.id, photo: foto ,caption: legenda, reply_to_message_id: message.message_id)
    rescue
      puts "quase deu erro \n\n"
    end
  end
  