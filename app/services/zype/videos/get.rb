class Zype::Videos::Get
  def self.execute(video_id, zype_session)
    response = Faraday.get("https://api.zype.com/videos/#{video_id}",
                           app_key: Rails.application.credentials[:zype][:app_key])
    if response.success?
      video = JSON.parse(response.body)['response']
      if !video['subscription_required']
        OpenStruct.new(success?: true, video: sanitize(video))
      elsif !zype_session.logged_in?
        OpenStruct.new(unauthorized?: true)
      elsif Zype::Videos::ConsumerEntitled.execute(video_id, zype_session)
        OpenStruct.new(success?: true, video: sanitize(video))
      else
        OpenStruct.new(forbidden?: true)
      end
    else
      OpenStruct.new(success?: false)
    end
  end

  def self.sanitize(video)
    OpenStruct.new(title: video['title'],
                   youtube_id: video['youtube_id'],
                   subscription_required: video['subscription_required'])
  end
end
