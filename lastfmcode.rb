require 'scrobbler2'

def datasong(song, texto)
  return texto = "#{texto}\n \u{1F3B6} #{song['name']}\n \u{1F465} #{song['artist']}\n \u{1F4BF} #{song['album']}"
end
  
def listening(song)
  texto ="is listening for the #{playcount(song)} \u{2716}time to:"
  datasong(song, texto)
end

def waslistening(song)
  texto ="was listening for the #{playcount(song)} \u{2716}time to:"
  datasong(song, texto)
end

def playcount(song)
  return case song['playcount']
  when 1
    "1st"
  when 2
    "2nd"
  when 3
    "3rd"
  else
    "#{song['playcount']}th"
  end
end


def lastFMbo (username)
  Scrobbler2::Base.api_key = "2ab8d4422f6e0b17392839c1ea5d32a4"
  Scrobbler2::Base.api_secret = "810a76e4f9802d31b42dc66dee9b2ac6"

    
  user = Scrobbler2::User.new(username)
  if (user.recent_tracks.class == NilClass) 
    return false
  end
  controlador = 0
  b = Hash.new
  a = user.recent_tracks["track"][0]
  if(a.class == NilClass)
    return false
  end  
  b['isListening'] = a.include? '@attr'
  b['name'] = a['name']
  b['artist'] = a['artist']['#text']
  track = Scrobbler2::Track.new(b['artist'], b['name'], username)
  if(track.info.class != NilClass)
    b['playcount'] = track.info['userplaycount'].to_i+1
  end
  b['album'] = a['album']['#text']
  b['image'] = Hash.new
  if(!a['image'][3]['#text'].to_s.empty?)
    b['image']['link'] = a['image'][3]['#text']
    b['image']['size'] = a['image'][3]['size']
  end
  return b
end