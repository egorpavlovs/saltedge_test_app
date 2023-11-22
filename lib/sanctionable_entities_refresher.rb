
class SanctionableEntitiesRefresher

  REFRESHERS = [
    SanctionableEntitiesRefresher::UNSanctionsList
    # Note: Here also should be SanctionableEntitiesRefresher::EUSanctionsList
  ].freeze

  def call
    REFRESHERS.each do |refresher|
      fresh_data = refresher.new.call

      refresh_sanctionable_entities(fresh_data)
    end
  end

  private

  def refresh_sanctionable_entities(sanctionable_entities)
    official_ids = sanctionable_entities.map { |entity_attrs| entity_attrs[:official_id] }
    existed_official_ids = SanctionableEntity.where(official_id: official_ids).pluck(:official_id)

    sanctionable_entities.each do |entity_attrs|
      SanctionableEntity.create!(entity_attrs) unless existed_official_ids.include?(entity_attrs[:official_id])
    rescue StandardError => e
      # TODO: Add Rollbar
    end
  end
end
