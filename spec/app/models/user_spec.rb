require 'rails_helper'

describe User do

  subject(:user) { create(:user) }

  it { should be_valid }

  it { should respond_to(:access_token) }

  it { should respond_to(:refresh_token) }

  it { should respond_to(:expires_at) }

  it { should respond_to(:expires_in) }

  it { should respond_to(:token_type) }

  specify { expect { subject.access_token = nil }. to change { subject.valid? }.from(true).to(false) }

  specify { expect { subject.expires_at = nil }. to change { subject.valid? }.from(true).to(false) }

  specify { expect { subject.expires_in = nil }. to change { subject.valid? }.from(true).to(false) }

  specify { expect { subject.token_type = nil }. to change { subject.valid? }.from(true).to(false) }

  describe "when #register! is called" do

    specify { expect { User.register! "david+ullr-#{Faker::Code.ean}@stockflare.com", "UllrTesting" }.to change { User.count }.by(1) }

    specify { expect { User.register! "david+ullr@stockflare.com", "UllrTesting" }.to raise_error ActiveRecord::RecordInvalid }

    specify { expect { User.register! "david+ullr@stockflare.com", nil }.to raise_error ActiveRecord::RecordInvalid }

    specify { expect { User.register! nil, "UllrTesting" }.to raise_error ActiveRecord::RecordInvalid }

    describe "when the request is invalid" do
      specify { expect { User.register! nil, nil }.to raise_error ActiveRecord::RecordInvalid }
    end

  end

end
