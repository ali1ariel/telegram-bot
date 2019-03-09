require 'scrobbler2'

def datasong(song, texto)
  return texto = "#{texto}\n \u{1F3B6} <b>#{song['name']}</b>\n \u{1F465} <i>#{song['artist']}</i>\n \u{1F4BF} <i>#{song['album']}</i>"
end
  
def listening(song)
  texto ="<i>is listening for the</i><b> #{playcount(song)}</b> \u{2716}<b>time</b> <i>to:</i>"
  datasong(song, texto)
end

def waslistening(song)
  texto ="<i>was listening for the</i> <b>#{playcount(song)}</b> \u{2716}<b>time</b> <i>to:</i>"
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


def getTrackInfo (username)
  Scrobbler2::Base.api_key = "2ab8d4422f6e0b17392839c1ea5d32a4"
  Scrobbler2::Base.api_secret = "810a76e4f9802d31b42dc66dee9b2ac6"

    
  user = Scrobbler2::User.new(username)
  return false if (user.recent_tracks.class == NilClass) 
  controlador = 0
  trackInfo = user.recent_tracks["track"][0]
  return false if (trackInfo.class == NilClass)
  return trackInfo

end

def getListen(trackInfo, newInfo)
  if(!trackInfo['image'][3]['#text'].to_s.empty?)
    newInfo['image']['link'] = trackInfo['image'][3]['#text']
    newInfo['image']['size'] = trackInfo['image'][3]['size']
  end
end

def getMiniListen(trackInfo, newInfo)
  if(!trackInfo['image'][2]['#text'].to_s.empty?)
    newInfo['image']['link'] = trackInfo['image'][2]['#text']
    newInfo['image']['size'] = trackInfo['image'][2]['size']
  end
end



def getTrack(username, typeListen)
  newInfo = Hash.new
  trackInfo = getTrackInfo(username)
  if trackInfo ==false
    return false
  end
  newInfo['isListening'] = trackInfo.include? '@attr'
  newInfo['name'] = trackInfo['name']
  newInfo['artist'] = trackInfo['artist']['#text']
  track = Scrobbler2::Track.new(newInfo['artist'], newInfo['name'], username)
  if(track.info.class != NilClass)  
    newInfo['playcount'] = track.info['userplaycount'].to_i  
    puts "=> #{newInfo['playcount']} e #{newInfo['playcount'].class}"
    if newInfo['playcount'] == 0

       newInfo['playcount'] =+1
    end
  end
  newInfo['album'] = trackInfo['album']['#text']
  newInfo['image'] = Hash.new
  case typeListen
  when 1
    getListen(trackInfo, newInfo)
  when 2
    getMiniListen(trackInfo, newInfo)
  end
  return newInfo
end

def getArtist(username)
  newInfo = Hash.new
  trackInfo = getTrackInfo(username)
  artist = trackInfo['artist']['#text']
  newInfo['name'] = artist
  artist = Scrobbler2::Artist.new(artist, username)
  artist = artist.info
  newInfo['playcount'] = artist['stats']['userplaycount'].to_i+1
  newInfo['image'] = Hash.new
  if(!artist['image'][3]['#text'].to_s.empty?)
    newInfo['image']['link'] = artist['image'][3]['#text']
    newInfo['image']['size'] = artist['image'][3]['size']
  end
  return newInfo
end


def getAlbum(username)
  newInfo = Hash.new
  trackInfo = getTrackInfo(username)
  artist = trackInfo['artist']['#text']
  album = trackInfo['album']['#text']
  puts album.class
  newInfo['album'] = album
  newInfo['artist'] = artist
  album = Scrobbler2::Album.new(artist, album, username)
  album = album.info
  print "\n"
  return false if album.class == NilClass

  newInfo['playcount'] = album['userplaycount'].to_i
  newInfo['playcount']+= 1 if newInfo['playcount'] == 0 
  newInfo['image'] = Hash.new
  if(!album['image'][3]['#text'].to_s.empty?)
    newInfo['image']['link'] = album['image'][3]['#text']
    newInfo['image']['size'] = album['image'][3]['size']
  end
  return newInfo
end
