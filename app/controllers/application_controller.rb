class ApplicationController < ActionController::Base
  before_action :export_to_js

  def start
    render html: '', layout: true
  end

  protected

  def zype_session
    @zype_session ||= Zype::Auth::Session.load_from(session)
  end

  def export_to_js
    gon.push('videoPlaceholder' => view_context.image_url('video_placeholder.jpg'))
    gon.push('loggedInAs' => zype_session.username) if zype_session.logged_in?
  end
end
