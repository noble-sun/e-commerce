require 'rails_helper'

RSpec.describe "Registrations", type: :request do
  describe "POST /create" do
    context 'create a new user' do
      it 'successfully' do
        params = { user: { email_address: 'email@email.com.br', cpf: '12312312312', password: 'pass@123' } }

        expect {
          post '/registrations', params: params
        }.to change(User, :count).by(1)

        user = User.find_by(email_address: params[:user][:email_address])
        expect(user.cpf).to eq('12312312312')
        expect(user.password_digest).to be_present
      end
    end

    context 'fail to create user' do
      it 'when email address already exist' do
        email = 'email@email.com.br'
        create(:user, email_address: email)

        params = { user: { email_address: email, cpf: '12312312312', password: 'pass@123' } }

        expect {
          post '/registrations', params: params
        }.to_not change(User, :count)
      end

      it 'when cpf already exist' do
        cpf = '12312312312'
        create(:user, cpf: cpf)

        params = { user: { email_address: 'newemail@email.com', cpf: cpf, password: 'pass@123' } }

        expect {
          post '/registrations', params: params
        }.to_not change(User, :count)
      end
    end
  end
end
