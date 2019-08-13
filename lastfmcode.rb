def getListening(lastfm_user, telegram_name, size = 3)
    track = Track_info.new(lastfm_user)
    "<b>#{telegram_name}</b> is listening for the <b>#{getCount(track)}th time</b> to:\n \u{1F3B6} <b>#{track.get_name_track()}</b> <a href=\"#{track.get_photos()[size]["#text"]}\"> </a> \n \u{1F465} #{track.get_artist()}\n \u{1F4BF} #{track.get_album()}\n #{user_loved_it(track.get_user_loved())}"
    
end

def user_loved_it(liked)
    return "\u2665" if liked
end

def getAlbum(lastfm_user, telegram_name,  size = 3)
    album = Album_info.new(lastfm_user)
    "<b>#{telegram_name}</b> is listening for the <b>#{getCount(album)}th time</b> to:\n \u{1F4BF} <b>#{album.get_album()}</b> <a href=\"#{album.get_photos()[size]["#text"]}\"> </a> \n \u{1F465} #{album.get_artist()}\n "  
end

def getArtist(lastfm_user, telegram_name,  size = 3)
    artist = Artist_info.new(lastfm_user)
    "<b>#{telegram_name}</b> is listening for the <b>#{getCount(artist)}th time</b> to:\n<a href=\"#{artist.get_photos()[size]["#text"]}\"> </a>\u{1F465} #{artist.get_artist()}\n "  
end

def getCount(objeto)
    if (objeto.get_count_listening() == 0 || objeto.get_count_listening().class == NilClass)
        return 1
    else return objeto.get_count_listening()
    end
end
