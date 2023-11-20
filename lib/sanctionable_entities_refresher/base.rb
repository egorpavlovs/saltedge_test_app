
class SanctionableEntitiesRefresher::Base

  def initialize
    @data = get_data
  end

  def call
    convert_data_into_entities
  end

  private

  attr_reader :data

  def get_data
    response = RestClient.get(self.class::SOURCE)

    raise "Data source respondet with #{response.code} code" if response.code != 200

    Hash.from_xml(response.body)
  end

  def convert_data_into_entities
    data.dig("CONSOLIDATED_LIST", "INDIVIDUALS", "INDIVIDUAL")&.map do |input_data|
      {
        official_id: input_data.dig("REFERENCE_NUMBER"),
        list_name: self.class::LIST_NAME,
        gender: input_data.dig("GENDER"),
        additional_info: input_data.dig("COMMENTS1"),
        extra: {
          addresses: convert_addresses(input_data.dig("INDIVIDUAL_ADDRESS")),
          birth_datas: convert_birth_datas(input_data)&.flatten,
          citizenships: [
            {
              country_code: input_data.dig("NATIONALITY", "VALUE")
            }
          ],
          name_aliases: convert_individual_aliases(input_data.dig("INDIVIDUAL_ALIAS"))
        }
      }
    end
  end

  def convert_individual_aliases(individual_aliases)
    if individual_aliases.is_a?(Hash)
      [
        {
          full_name: individual_aliases.dig("ALIAS_NAME")
        }
      ]
    elsif individual_aliases.is_a?(Array)
      individual_aliases.map do |alias_data|
        {
          full_name: alias_data.dig("ALIAS_NAME")
        }
      end
    end
  end

  def convert_birth_datas(input_data)
    place_of_birth = input_data.dig("INDIVIDUAL_PLACE_OF_BIRTH")
    birth_date = input_data.dig("INDIVIDUAL_DATE_OF_BIRTH")

    birth_dates = if birth_date.is_a?(Hash)
      [birth_date["YEAR"]]
    elsif birth_date.is_a?(Array)
      birth_date.map { |e| e['YEAR'] }
    end

    if place_of_birth.is_a?(Hash)
      [
        convert_birth_data(place_of_birth, birth_dates)
      ]
    elsif place_of_birth.is_a?(Array)
      place_of_birth.map do |birth_data|
        convert_birth_data(birth_data, birth_dates)
      end
    end
  end

  def convert_birth_data(birth_data, birth_dates)
    (birth_dates || [nil]).map do |birth_date|
      {
        city: birth_data.dig("CITY"),
        date: birth_date,
        place: birth_data.dig("STATE_PROVINCE"),
        country_code: birth_data.dig("COUNTRY")
      }.compact
    end
  end

  def convert_addresses(addresses)
    return if addresses.blank?

    if addresses.is_a?(Hash)
      convert_address(addresses)
    elsif addresses.is_a?(Array)
      addresses.map { |address| convert_address(address) }.compact
    end
  end

  def convert_address(address)
    return if address.blank?

    {
      city: address["CITY"],
      region: address["STATE_PROVINCE"],
      street: address["STREET"]
    }
  end
end
