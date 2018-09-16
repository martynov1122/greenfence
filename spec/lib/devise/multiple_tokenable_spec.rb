require 'spec_helper'

describe Devise::Models::MultipleTokenable do
  describe 'authentication token methods' do
    let(:user) { create(:user) }
    describe 'new_authentication_token!' do
      it 'creates an auth token on the user' do
        user.new_authentication_token!("web")
        expect(user.authentication_tokens.count).to eq(1)
      end

      it 'revokes old token when new token created on same device' do
        user.new_authentication_token!("web")
        user.new_authentication_token!("web")
        expect(user.authentication_tokens.count).to eq(1)
      end

      it 'can create multiple tokens across separate device types' do
        user.new_authentication_token!("web")
        user.new_authentication_token!("mobile")
        expect(user.authentication_tokens.count).to eq(2)
      end
    end

    describe 'destroy_authentication_token!' do
      it 'destroys auth token based on device' do
        user.new_authentication_token!("web")
        user.destroy_authentication_token!("web")
        expect(user.authentication_tokens.count).to eq(0)
      end
    end

    describe 'find_for_token_authentication' do
      it 'finds user by token' do
        token = user.new_authentication_token!("web")
        value = token.value
        expect(User.find_for_token_authentication({authentication_token: value})).to eq user
      end
    end
  end
end
