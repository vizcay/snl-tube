class Zype::Auth::RefreshToken
  def self.execute(username, refresh_token)
    response = Faraday.post('https://login.zype.com/oauth/token',
                            client_id: Rails.application.credentials[:zype][:oauth_client_id],
                            client_secret: Rails.application.credentials[:zype][:oauth_client_secret],
                            username: username,
                            refresh_token: refresh_token,
                            grant_type: 'refresh_token')
    if response.success?
      auth = JSON.parse(response.body)
      OpenStruct.new(success?: true,
                     access_token: auth['access_token'],
                     refresh_token: auth['refresh_token'],
                     token_expires_at: auth['created_at'] + auth['expires_in'])
    else
      OpenStruct.new(success?: false)
    end
  end
end

