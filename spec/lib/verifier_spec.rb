# TODO: Mock SanctionableEntity sql request

describe Verifier do
  let!(:sanctionable_entity) { create(:sanctionable_entity) }
  let(:verifier) { described_class.new(list_of_persons: [{ fields: params }]) }
  let(:expected_result) do
    [
      { 
        person_details: {
          full_name:     full_name,
          citizenship:   citizenship,
          date_of_birth: date_of_birth,
          gender:        gender
        },
        detected:              detected,
        sanctionable_entities: sanctionable_entity_ids
      }
    ]
  end
  let(:detected) { true }
  let(:sanctionable_entity_ids) { [{ 'id' => sanctionable_entity.id }] }
  let(:full_name) { nil }
  let(:citizenship) { nil }
  let(:date_of_birth) { nil }
  let(:gender) { nil }

  let(:params) { { full_name: full_name, date_of_birth: date_of_birth, citizenship: citizenship, gender: gender } }

  context "when full name is provided" do
    let(:full_name) { 'john richard doe' }

    it "verifies the full name" do
      expect(verifier.run).to eq(expected_result)
    end

    context "with only surname" do
      let(:full_name) { 'richard doe' }

      it "verifies surname" do
        expect(verifier.run).to eq(expected_result)
      end
    end
  
    context "with only first name" do
      let(:full_name) { 'johny' }
      
      it "verifies first name" do
        expect(verifier.run).to eq(expected_result)
      end
    end

    context "with different case" do
      let(:full_name) { 'JohnY DoE' }

      it "verifies first name" do
        expect(verifier.run).to eq(expected_result)
      end
    end

    context "with wrong name" do
      let(:full_name) { 'Adam Smith' }
      let(:detected) { false }
      let(:sanctionable_entity_ids) { [] }

      it "verifies first name" do
        expect(verifier.run).to eq(expected_result)
      end
    end
  end

  context "when full_name and date_of_birth are provided" do
    let(:full_name) { 'JohnY' }
    let(:date_of_birth) { '1999-12-31' }

    it "verifies params" do
      expect(verifier.run).to eq(expected_result)
    end
  end

  context "when full_name, date_of_birth and citizenship are provided" do
    let(:full_name) { 'johny' }
    let(:date_of_birth) { '1999-12-31' }
    let(:citizenship) { 'MD' }

    it "verifies params" do
      expect(verifier.run).to eq(expected_result)
    end
  end

  context "when full_name, date_of_birth, citizenship and gender are provided" do
    let(:full_name) { 'johny' }
    let(:date_of_birth) { '1999-12-31' }
    let(:citizenship) { 'MD' }
    let(:gender) { 'M' }

    it "verifies params" do
      expect(verifier.run).to eq(expected_result)
    end
  end

  context "when only date_of_birth is provided" do
    let(:date_of_birth) { '1999-12-31' }
    let(:detected) { false }
    let(:sanctionable_entity_ids) { [] }

    it "return response without verified data" do
      expect(verifier.run).to eq(expected_result)
    end
  end

  context "when only citizenship is provided" do
    let(:citizenship) { 'MD' }
    let(:detected) { false }
    let(:sanctionable_entity_ids) { [] }

    it "return response without verified data" do
      expect(verifier.run).to eq(expected_result)
    end
  end

  context "when only gender is provided" do
    let(:gender) { 'M' }
    let(:detected) { false }
    let(:sanctionable_entity_ids) { [] }

    it "return response without verified data" do
      expect(verifier.run).to eq(expected_result)
    end
  end

  context 'with full_name and citizenship' do
    let(:full_name) { 'johny' }
    let(:citizenship) { 'MD' }
    let(:detected) { false }
    let(:sanctionable_entity_ids) { [] }

    it "return response without verified data" do
      expect(verifier.run).to eq(expected_result)
    end
  end

  context 'with full_name and gender' do
    let(:full_name) { 'johny' }
    let(:gender) { 'M' }
    let(:detected) { false }
    let(:sanctionable_entity_ids) { [] }

    it "return response without verified data" do
      expect(verifier.run).to eq(expected_result)
    end
  end
end