
shared_examples 'a sanctionable entities requester' do
  context 'when the data source responds with a 200 code' do
    before do
      allow(RestClient).to receive(:get).and_return(double(code: 200, body: response_body))
    end

    it 'converts the data into entities' do
      expect(refresher.call).to eq(expected_data)
    end
  end

  context 'when the data source responds with a non-200 code' do
    before do
      allow(RestClient).to receive(:get).and_return(double(code: 500))
    end

    it 'raises an error' do
      expect { refresher }.to raise_error(RuntimeError, 'Data source respondet with 500 code')
    end
  end
end
