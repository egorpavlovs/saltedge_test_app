class SanctionableEntitiesRefresherJob
  include Sidekiq::Job

  def perform
    SanctionableEntitiesRefresher.new.call
  rescue StandardError => e
    # TODO: Add Rollbar
  end
end
