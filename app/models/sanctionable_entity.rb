class SanctionableEntity < ActiveRecord::Base
  validates :list_name, presence: true
  validates :official_id, presence: true
  validates :extra, presence: true

  def self.find_by_extra_field(full_name:, citizenship: nil, date_of_birth: nil, gender: nil)
    full_name_conditions = full_name.split.map do |name_part| 
      "extra::text ILIKE '%\"full_name\": \"%#{name_part}%'" 
    end
    birth_datas_conditions = "extra::text ILIKE '%\"birth_datas\": [{%\"date\": \"%#{date_of_birth}%\"}]%'"
    citizenships_conditions = "extra::text ILIKE '%\"citizenships\": [{%\"country_code\": \"%#{citizenship}%\"}]%'"
  
    sql = <<-SQL
      SELECT id
      FROM sanctionable_entities
      WHERE #{full_name_conditions.join(' AND ')}
      #{' AND ' + birth_datas_conditions if date_of_birth.present?}
      #{' AND ' + citizenships_conditions if citizenship.present?}
      #{' AND (gender = :gender OR gender IS NULL)' if gender.present?}
    SQL

    query_params = {
      full_name: full_name,
      citizenship: '%"country_code": "' + "#{citizenship}" + '%"',
      date_of_birth: '%"date": "' + "#{date_of_birth}" + '%"',
      gender: gender
    }

    sanctionable_entities = SanctionableEntity.find_by_sql([sql, query_params])
  end
end