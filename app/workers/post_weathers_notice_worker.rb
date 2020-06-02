class PostWeathersNoticeWorker
  include Sidekiq::Worker
  sidekiq_options queue: :sidekiq, retry: false

  def perform(line_id, token)
    post 'http://www.umbrellanotice.work/weathers/notice',
         headers: { 'Authorization': "Token #{token}" },
         params: { line_id: line_id }
  end
end
