describe SanctionableEntitiesRefresher::UNSanctionsList do
  include FixturesHelper

  describe '#call' do
    it_behaves_like 'a sanctionable entities requester' do
      let(:refresher) { described_class.new }
      let(:response_body) do
        load_fixture("lib/sanctionable_entities_refresher/u_n_sanctions_list_data.xml")
      end

      let(:expected_data) do
        [
          {
            official_id: "123",
            list_name: "UN",
            gender: "Male",
            additional_info: "Additional info",
            extra: {
              addresses: {
                city: "New York",
                region: "New York",
                street: "123 Main St"
              },
              birth_datas: [
                {
                  city: "New York",
                  date: "1980",
                  place: "New York",
                  country_code: "US"
                }
              ],
              citizenships: [
                {
                  country_code: "US"
                }
              ],
              name_aliases: [
                {
                  full_name: "John Doe"
                }
              ]
            }
          },
          {
            official_id: "456",
            list_name: "UN",
            gender: "Female",
            additional_info: "Additional info",
            extra: {
              addresses: [
                {
                  city: "Los Angeles",
                  region: "California",
                  street: "456 Elm St"
                },
                {
                  city: "San Francisco",
                  region: "California",
                  street: "789 Oak St"
                }
              ],
              birth_datas: [
                {
                  city: "Los Angeles",
                  date: "1990",
                  place: "California",
                  country_code: "US"
                },
                {
                  city: "Los Angeles",
                  date: "1995",
                  place: "California",
                  country_code: "US"
                },
                {
                  city: "Toronto",
                  date: "1990",
                  place: "Ontario",
                  country_code: "CA"
                },
                {
                  city: "Toronto",
                  date: "1995",
                  place: "Ontario",
                  country_code: "CA"
                }
              ],
              citizenships: [
                {
                  country_code: "UK"
                }
              ],
              name_aliases: [
                {
                  full_name: "Jane Smith"
                },
                {
                  full_name: "Jane Doe"
                }
              ]
            }
          }
        ]
      end
    end
  end
end
