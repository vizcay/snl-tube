class Zype::Videos::List
  def self.execute(page = 1)
    response = Faraday.get('https://api.zype.com/videos',
                           app_key: Rails.application.credentials[:zype][:app_key],
                           sort: 'published_at',
                           order: 'desc',
                           per_page: 9,
                           page: page.to_i)
    if response.success?
      data = JSON.parse(response.body)
      OpenStruct.new(success?: true,
                     response: sanitize(data['response']),
                     pagination: data['pagination'])
    else
      OpenStruct.new(success?: false)
    end
  end

  WHITELISTED = ['_id', 'title', 'subscription_required']

  def self.sanitize(response)
    response.map do |video|
      video.slice(*WHITELISTED).tap do |r|
        r['thumbnail'] = video['thumbnails'].first['url']
      end
    end
  end
end
