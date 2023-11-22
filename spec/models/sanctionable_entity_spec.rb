describe SanctionableEntity do
  let!(:sanctionable_entity) { create :sanctionable_entity }

  it { should validate_presence_of(:list_name) }
  it { should validate_presence_of(:official_id) }
  it { should validate_presence_of(:extra) }

  describe "validations" do
    it "should allow country_id to be nil" do
      sanctionable_entity = build :sanctionable_entity, gender: nil
      expect(sanctionable_entity.valid?).to be true
    end
    it "should allow country_id to be nil" do
      sanctionable_entity = build :sanctionable_entity, additional_info: nil
      expect(sanctionable_entity.valid?).to be true
    end
  end

  # TODO: add tests for another fields
  describe ".find_by_extra_field" do
    let(:response) do
      SanctionableEntity.find_by_extra_field(full_name: full_name)
    end
    let(:full_name) { 'johny' }

    it "should return sanctionable_entity" do
      expect(response).to eq([sanctionable_entity])
    end

    context "when full name is wrong" do
      let(:full_name) { 'Mike' }

      it "should return empty array" do
        expect(response).to be_empty
      end
    end
  end
end
