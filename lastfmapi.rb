require 'httparty'
require 'json'
require 'ostruct'
require_relative 'tokens'

URL = "http://ws.audioscrobbler.com/2.0/?format=json&api_key=#{API_KEY}&"



def getAnswer(query)
    response = HTTParty.get(URI.escape(query))
    JSON.parse(response.body)
    
end

def getUser(username)
    method = 'user.getinfo'
    resposta = getAnswer("#{URL}method=#{method}&user=#{username}")
    return resposta["name"]
end

def getAlbumInfoQuery(username, albumName, artistName)   

    method = 'album.getinfo'; 
    return "#{URL}method=#{method}&artist=#{artistName}&album=#{albumName}&username=#{username}"

end

def getRecentTracksQuery(user)

    method = 'user.getrecenttracks'
    return "#{URL}method=#{method}&user=#{user}"

end

def getTrackInfoQuery(user, track)

    method = 'track.getinfo'; artist = track["artist"]["#text"]; trackname = track["name"]
    return "#{URL}method=#{method}&artist=#{artist}&track=#{trackname}&username=#{user}&autocorrect=1"

end

def getArtistInfoQuery(user, artist)
    method = 'artist.getinfo'; 
    return "#{URL}method=#{method}&artist=#{artist}&username=#{user}&autocorrect=1"
end

def getUserInfoQuery(user)
    method = 'user.getinfo';
    return "#{URL}method=#{method}&user=#{user}"
end

def getUserTopTracksQuery(user, period = 'overall')
    method = 'user.gettoptracks';
    return "#{URL}method=#{method}&period=#{period}&user=#{user}"
end

def getUserTopAlbumsQuery(user, period = 'overall')
    method = 'user.gettopalbums';
    return "#{URL}method=#{method}&period=#{period}&user=#{user}"
end

def getUserTopArtistsQuery(user, period = 'overall')
    method = 'user.gettopartists';
    return "#{URL}method=#{method}&period=#{period}&user=#{user}"
end

class Track_info
    def initialize(user)
        track = getAnswer(getRecentTracksQuery(user))
        track = track["recenttracks"]["track"][0]
        hashTrack = getAnswer(getTrackInfoQuery(user, track))
        @is_listening = track.include? '@attr'
        @name_track = hashTrack["track"]["name"]
        @album = track["album"]['#text'] 
        @artist = track["artist"]['#text']
        @count_listening = hashTrack["track"]["userplaycount"]
        @user_loved = (hashTrack["track"]["userloved"]=='1')
        @photos = track["image"]

    end

    def get_is_listening()
        @is_listening
    end

    def get_name_track()
        @name_track
    end

    def get_album()
        @album
    end

    def get_artist()
        @artist
    end

    def get_count_listening()
        @count_listening
    end

    def get_user_loved()
        @user_loved
    end

    def get_photos()
        @photos
    end
end

class Album_info
    def initialize(user)
        track = getAnswer(getRecentTracksQuery(user))
        track = track["recenttracks"]["track"][0]
        @artist = track["artist"]["#text"]
        @album = track["album"]["#text"]
        hashAlbum = getAnswer(getAlbumInfoQuery(user, @album, @artist))
        @count_listening = hashAlbum["album"]["userplaycount"]
        @photos = hashAlbum["album"]["image"]
    end

    def get_album
        @album
    end

    def get_artist
        @artist
    end
    
    def get_photos
        @photos
    end

    def get_count_listening
        @count_listening
    end
end

class Artist_info
    def initialize(user)
        track = getAnswer(getRecentTracksQuery(user))
        track = track["recenttracks"]["track"][0]
        @artist = track["artist"]["#text"]
        hashArtist = getAnswer(getArtistInfoQuery(user,  @artist))
        puts hashArtist
        @count_listening = hashArtist["artist"]["stats"]["userplaycount"]
        @photos = track["image"]
    end

    def get_artist
        @artist
    end
    
    def get_photos
        @photos
    end

    def get_count_listening
        @count_listening
    end

end