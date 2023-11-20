describe SanctionableEntitiesRefresherJob, type: :job do
  describe '#perform' do
    context 'when called' do
      it 'calls the SanctionableEntitiesRefresher' do
        expect(SanctionableEntitiesRefresher).to receive(:new).and_call_original
        subject.perform
      end
    end
  end
end
