class Zype::Auth::SignIn
  def self.execute(username, password)
    response = Faraday.post('https://login.zype.com/oauth/token',
                            client_id: Rails.application.credentials[:zype][:oauth_client_id],
                            client_secret: Rails.application.credentials[:zype][:oauth_client_secret],
                            username: username,
                            password: password,
                            grant_type: 'password')
    if response.success?
      OpenStruct.new(success?: true,
                     zype_session: create_zype_session(username, JSON.parse(response.body)))
    elsif response.status == 401
      OpenStruct.new(unauthorized?: true)
    else
      OpenStruct.new(unknown_error?: true)
    end
  end

  protected

  def self.create_zype_session(username, data)
    Zype::Auth::Session.new(username: username,
                            access_token: data['access_token'],
                            refresh_token: data['refresh_token'],
                            token_expires_at: data['created_at'] + data['expires_in'],
                            session_expires_at: 2.weeks.from_now.to_i)
  end
end
