describe SanctionableEntitiesRefresher do
  describe '#call' do
    let(:refresher) { described_class.new }
    let(:entities) do
      [
        { official_id: '1', extra: { foo: :bar }, list_name: 'UN' }, 
        { official_id: '2', extra: { foo: :baz }, list_name: 'UN' }
      ]
    end

    it 'refreshes sanctionable entities' do
      expect(SanctionableEntitiesRefresher::UNSanctionsList).to receive(:new).and_return(
        double(call: entities)
      )

      refresher.call

      expect(SanctionableEntity.find_by(official_id: '1')).to be_present
      expect(SanctionableEntity.find_by(official_id: '2')).to be_present
    end
  end
end