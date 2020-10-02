class Zype::Auth::Session
  def initialize(username:,
                 access_token:,
                 refresh_token:,
                 token_expires_at:,
                 session_expires_at:,
                 session: nil)
    @username           = username
    @access_token       = access_token
    @refresh_token      = refresh_token
    @token_expires_at   = token_expires_at
    @session_expires_at = session_expires_at
    @session            = session
  end

  def self.load_from(session)
    new(username: session[:username],
        access_token: session[:access_token],
        refresh_token: session[:refresh_token],
        token_expires_at: session[:token_expires_at],
        session_expires_at: session[:session_expires_at])
  end

  def persist_to(session)
    session[:username]           = @username
    session[:access_token]       = @access_token
    session[:refresh_token]      = @refresh_token
    session[:token_expires_at]   = @token_expires_at
    session[:session_expires_at] = @session_expires_at
  end

  def logged_in?
    @username.present? && @access_token.present? && !session_expired?
  end

  def username
    @username unless session_expired?
  end

  def access_token
    unless session_expired?
      renew_token! if token_close_to_or_expired?
      @access_token
    end
  end

  protected

  def session_expired?
    @session_expired ||= @session_expires_at <= Time.now.to_i
  end

  def token_close_to_or_expired?
    @token_close_to_or_expired ||= @token_expires_at < 10.minutes.ago.to_i
  end

  def clear
    @username           = nil
    @access_token       = nil
    @refresh_token      = nil
    @token_expires_at   = nil
    @session_expires_at = nil
  end

  def renew_token!
    query = Zype::Auth::RefreshToken.execute(@username, @refresh_token)
    if query.success?
      @access_token     = query.access_token
      @refresh_token    = query.refresh_token
      @token_expires_at = query.token_expires_at
      persist_to(@session) if @session
    else
      clear
    end
  end
end
