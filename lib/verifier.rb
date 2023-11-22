
class Verifier

  def initialize(params = {})
    @params = params
  end

  def run
    params[:list_of_persons].map { |person_details| check_person(person_details) }
  end

  private

  attr_reader :params

  def check_person(data)
    fields = data[:fields]

    full_name = fields[:full_name]
    citizenship = fields[:citizenship]
    date_of_birth = fields[:date_of_birth]
    gender = fields[:gender]

    sanctionable_entities = find_sanctionable_entities(full_name, citizenship, date_of_birth, gender)

    {
      person_details: {
        full_name:     full_name,
        citizenship:   citizenship,
        date_of_birth: date_of_birth,
        gender:        gender
      },
      detected:              sanctionable_entities.size > 0 ? true : false,
      sanctionable_entities: sanctionable_entities.as_json(only: [:id, :official_id])
    }
  end

  def find_sanctionable_entities(full_name, citizenship, date_of_birth, gender)
    should_make_search = (full_name && date_of_birth) ||
                         (full_name && date_of_birth && citizenship) ||
                         (full_name && date_of_birth && citizenship && gender) ||
                         (full_name && citizenship.blank? && date_of_birth.blank? && gender.blank?)
    # NOTE: Maybe here should be raise error if should_make_search is false. Need more detais.
    return [] unless should_make_search

    # Should be like at sidekiq scheduler
    expiration_time = Time.current.change(hour: 6, min: 0, sec: 0) + 1.day
    cache_key = [full_name, citizenship, date_of_birth, gender].compact.join('-')

    Rails.cache.fetch(cache_key, expires_in: expiration_time) do
      SanctionableEntity.find_by_extra_field(
        full_name: full_name,
        citizenship: citizenship,
        date_of_birth: date_of_birth,
        gender: gender
      )
    end
  end
end
