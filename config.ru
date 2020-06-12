# This file is used by Rack-based servers to start the application.

require_relative 'config/environment'

# Unicorn-worker-killer Setting
require 'unicorn/worker_killer'
use Unicorn::WorkerKiller::MaxRequests, 3072, 4096, true
use Unicorn::WorkerKiller::Oom, (192 * (1024**2)), (256 * (1024**2))

# GoogleAuth callback Setting
map '/oauth2callback' do
  run Google::Auth::WebUserAuthorizer::CallbackApp
end

run Rails.application
