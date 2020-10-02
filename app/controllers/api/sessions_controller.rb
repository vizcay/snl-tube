class API::SessionsController < ApplicationController
  def create
    query = Zype::Auth::SignIn.execute(params[:email], params[:password])
    if query.success?
      query.zype_session.persist_to(session)
      head :ok
    elsif query.unauthorized?
      head :unauthorized
    else
      head :service_unavailable
    end
  end

  def destroy
    session[:username]           = nil
    session[:access_token]       = nil
    session[:refresh_token]      = nil
    session[:token_expires_at]   = nil
    session[:session_expires_at] = nil
    head :ok
  end
end
