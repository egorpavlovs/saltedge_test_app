class SanctionableEntitiesRefresherJob
  include Sidekiq::Job

  def perform
    puts 'aaa'
    res = SanctionableEntitiesRefresher.new.call
    puts res
  rescue StandardError => e
    # TODO: Add Rollbar
  end
end
