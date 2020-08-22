class PostWeathersNoticeWorker
  include Sidekiq::Worker

  sidekiq_options queue: :sidekiq, retry: false

  def perform(line_id, token)
    uri = URI.parse('https://www.umbrellanotice.work/weathers/line_notice')
    req = Net::HTTP::Post.new(uri)

    req['Authorization'] = "Token #{token}"
    req.set_form_data(line_id: line_id)

    Net::HTTP.start(uri.hostname, uri.port, use_ssl: true) do |http|
      http.request(req)
    end
  end
end
