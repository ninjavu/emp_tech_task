# frozen_string_literal: true
# rake environment admin:import

namespace :admin do
  task :import do
    Admin::ImportJob.perform_async
  end
end
