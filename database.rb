require "mysql2"

def iniciaServidor()
    client = Mysql2::Client.new(host: 'localhost', username: 'alisson', password: '')
    client.query('show databases')
    client.query('use mybot')
    return client
end

def incluiUser(client, username, userid)
    if(getTrackInfo(username) == false)
        return 'Usuário não existe'
    end
    queryteste = "select * from Users where User_ID = #{userid}"
    result = client.query(queryteste)
    if result.size == 1
        queryteste = "UPDATE Users SET User_NickName = '#{username}' WHERE User_ID = #{userid}"
        client.query(queryteste)
        return 'Prontinho, alterado'
    end
    query = "insert into Users(User_ID, User_NickName) values ('#{userid}', '#{username}')"
    client.query(query)
    return 'Prontinho, cadastrado'
end

def retornaUser(client, userid)
    query = "select User_NickName from Users where User_ID = #{userid}"
    result = client.query(query)
    result.each do |what|
        return what["User_NickName"]
    end
end
