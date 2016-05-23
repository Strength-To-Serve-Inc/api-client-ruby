require 'net/http'
require 'spec_helper'
require 'json'
require 'signup'

describe RestoreStrategies::Opportunity do
  let(:client) do
    RestoreStrategies::Client.new(
      ENV['TOKEN'],
      ENV['SECRET'],
      ENV['HOST'],
      ENV['PORT']
    )
  end

  let(:opp) do
    described_class.find(1)
  end

  describe 'find' do
    it 'finds an opporunity from id' do
      opportunity = described_class.find(1)
      expect(opportunity).to be_a(described_class)
      expect(opportunity.id.to_i).to be(1)
    end

    it 'throws error if id is not integer' do
      expect { described_class.find('1') }
        .to raise_error(ArgumentError, 'id must be integer')
    end

    it 'throws error if id is not found' do
      expect { described_class.find(99_999) }
        .to raise_error(RestoreStrategies::NotFoundError)
    end
  end

  describe 'get_signup' do
    it 'gets a signup object' do
      opp = described_class.find(1)
      signup = opp.create_signup
      expect(signup).to be_a(RestoreStrategies::Signup)
    end
  end

  describe 'submit_signup' do
    it 'throws an error if the object put in is not a signup object' do
      expect { opp.submit_signup 1 }.to raise_error(TypeError)
    end

    it 'throws an error if the signup data is not valid' do
      signup = opp.create_signup
      expect { opp.submit_signup signup }.to raise_error(
        RestoreStrategies::SignupValidationError
      )
    end

    it 'submits successfully' do
      signup = opp.create_signup
      signup.given_name = 'John'
      signup.family_name = 'Doe'
      signup.telephone = '5125419812'
      signup.email = 'john.doe@email.com'
      signup.comment = 'no comment'
      signup.num_of_items_committed = 2
      signup.lead = 'other'
      signup.valid?
      opp.submit_signup signup
    end
  end
end
