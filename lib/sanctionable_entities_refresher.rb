
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
    sanctionable_entities.each do |entity_attrs|
      entity = SanctionableEntity.find_or_initialize_by(official_id: entity_attrs[:official_id])

      next if entity.persisted?

      entity.update(entity_attrs)

      entity.save!
    end
  end
end
