# frozen_string_literal: true

RSpec.describe LoginWithGoogle::Api do
  describe 'url_in' do
    let(:url) { described_class.url_in }
    let(:base) { "#{LoginWithGoogle.config['url']['login']}?" }
    let(:client_id) { "client_id=#{LoginWithGoogle.config['url']['params_login']['client_id']}&" }
    let(:callback) do
      "redirect_uri=#{LoginWithGoogle.config['url']['callback']}"
    end
    let(:response_type) { "response_type=#{LoginWithGoogle.config['url']['params_login']['response_type']}&" }
    let(:scope) { "scope=#{LoginWithGoogle.config['url']['params_login']['scope']}" }

    it 'url_base' do
      expect(url).to start_with(base)
    end

    it 'client_id' do
      expect(url).to include(client_id)
    end

    it 'redirect_uri' do
      expect(url).to include(callback)
    end

    it 'response_type' do
      expect(url).to include(response_type)
    end

    it 'scope' do
      expect(url).to include(scope)
    end

    it 'all' do
      compose = [base, client_id, callback, response_type, scope]
      compose.each { |part| url.gsub!(part) { '' } }
      expect(url).to eq('&')
    end
  end

  describe 'auth' do
    SinatraServer.instance.restart

    it 'call auth' do
      auth = described_class.auth(code: SecureRandom.hex)
      expect(auth.keys).to eq(%w[access_token expires_in scope token_type id_token])
    end
  end

  describe 'info' do
    it 'call info' do
      auth = described_class.auth(code: SecureRandom.hex)
      info = described_class.info(auth)
      expect(info.keys).to eq(%w[id email verified_email name given_name family_name picture locale])
    end
  end

  describe 'refresh' do
    it 'call refresh' do
      auth = described_class.auth(code: SecureRandom.hex)
      refresh = described_class.refresh(token: auth['access_token'])
      expect(refresh.keys).to eq(%w[access_token expires_in scope token_type id_token])
    end

    it 'call refresh with invalid token' do
      refresh = described_class.refresh(token: SecureRandom.hex)
      expect(refresh.keys).to eq(%w[error error_description])
    end
  end
end
