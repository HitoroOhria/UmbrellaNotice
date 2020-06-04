namespace :umbrellanotice do
  desc 'POST WeathersController#line_notice'
  task :line_notice do
    PostWeathersNoticeWorker.perform_async(ENV['LINE_ID'], ENV['LINE_TOKEN'])
  end
end
