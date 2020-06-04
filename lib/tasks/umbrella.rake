namespace :umbrella do
  desc 'POST WeathersController#line_notice'
  task line_notice: :environment do
    PostWeathersNoticeWorker.perform_async(ENV['LINE_ID'], ENV['LINE_TOKEN'])
  end
end
