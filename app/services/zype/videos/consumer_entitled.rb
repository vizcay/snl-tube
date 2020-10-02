class Zype::Videos::ConsumerEntitled
  def self.execute(video_id, zype_session)
    Faraday.get("https://api.zype.com/videos/#{video_id}/entitled",
                access_token: zype_session.access_token).success?
  end
end
