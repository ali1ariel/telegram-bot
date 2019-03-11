
def MandaMensagem(bot, message, texto)
  print "okay\n"
  begin
    bot.api.send_message(chat_id: message.chat.id, text: "#{texto}", parse_mode: "HTML", reply_to_message_id: message.message_id)
  rescue
    puts "quase deu erro: #{texto}\n\n"

  end
end
  
def MandaFoto(bot, message, foto, legenda = nil)
  print "okay\n"
  begin
    bot.api.send_photo(chat_id: message.chat.id, photo: foto ,caption: legenda, parse_mode: "HTML", reply_to_message_id: message.message_id)
  rescue
    puts "quase deu erro #{legenda}\n\n"
  end
end
  