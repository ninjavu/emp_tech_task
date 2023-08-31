# frozen_string_literal: true
# rake environment merchant:import

namespace :merchant do
  task :import do
    Merchant::ImportJob.perform_async
  end
end
