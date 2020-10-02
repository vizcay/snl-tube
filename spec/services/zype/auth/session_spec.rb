require 'rails_helper'

RSpec.describe Zype::Auth::Session do
  context 'when the session and token are current' do
    subject(:session) {
      described_class.new(username: 'test@test.com',
                          access_token: 'xxx',
                          refresh_token: 'yyy',
                          token_expires_at: 7.days.from_now.to_i,
                          session_expires_at: 14.days.from_now.to_i)
    }

    it '#logged_in? is truthy' do
      expect(session.logged_in?).to be_truthy
    end

    it 'it returns #username' do
      expect(session.username).to eq('test@test.com')
    end

    it 'it returns #access_token' do
      expect(session.access_token).to eq('xxx')
    end
  end

  context 'when the session is expired' do
    subject(:session) {
      described_class.new(username: 'test@test.com',
                          access_token: 'xxx',
                          refresh_token: 'yyy',
                          token_expires_at: 7.days.from_now.to_i,
                          session_expires_at: 1.minute.ago.to_i)
    }

    it '#logged_in? is falsey' do
      expect(session.logged_in?).to be_falsey
    end

    it '#username is nil' do
      expect(session.username).to be_nil
    end

    it '#access_token is nil' do
      expect(session.access_token).to be_nil
    end
  end

  context 'when the session is current and the token expired' do
    subject(:session) {
      described_class.new(username: 'test@test.com',
                          access_token: 'xxx',
                          refresh_token: 'yyy',
                          token_expires_at: 1.hour.ago.to_i,
                          session_expires_at: 1.day.from_now.to_i)
    }

    it '#logged_in? is truthy' do
      expect(session.logged_in?).to be_truthy
    end

    it 'it returns #username' do
      expect(session.username).to eq('test@test.com')
    end

    it 'when getting #access_token it tries to get current one with the refresh token' do
      query_results = double(success?: true,
                             access_token: 'new-token',
                             refresh_token: 'new-refresh',
                             token_expires_at: 1.day.from_now.to_i)
      expect(Zype::Auth::RefreshToken).to \
        receive(:execute).with('test@test.com', 'yyy').and_return(query_results)
      expect(session.access_token).to eq('new-token')
    end
  end

  it 'it #persist_to a rails session' do
    tomorrow = 1.day.from_now.to_i
    session = described_class.new(username: 'test@test.com',
                                  access_token: 'xxx',
                                  refresh_token: 'yyy',
                                  token_expires_at: tomorrow,
                                  session_expires_at: tomorrow)
    rails_session = double
    expect(rails_session).to receive(:[]=).with(:username, 'test@test.com').once
    expect(rails_session).to receive(:[]=).with(:access_token, 'xxx').once
    expect(rails_session).to receive(:[]=).with(:refresh_token, 'yyy').once
    expect(rails_session).to receive(:[]=).with(:token_expires_at, tomorrow).once
    expect(rails_session).to receive(:[]=).with(:session_expires_at, tomorrow).once
    session.persist_to(rails_session)
  end
end
