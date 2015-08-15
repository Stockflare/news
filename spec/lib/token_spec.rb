describe Token do
  subject(:token) { build(:token) }

  it { should respond_to(:access_token) }

  it { should respond_to(:token_type) }

  it { should respond_to(:expires_in) }

  it { should respond_to(:expires) }

  it { should respond_to(:refresh_token) }

  it { should respond_to(:refresh!) }

  it { should respond_to(:logout!) }

  it { should respond_to(:to_cookie) }

  it { should respond_to(:to_header) }

  specify { expect { subject.access_token = nil }.to raise_error(NoMethodError) }

  specify { expect { subject.token_type = nil }.to raise_error(NoMethodError) }

  specify { expect { subject.expires_in = nil }.to raise_error(NoMethodError) }

  specify { expect { subject.refresh_token = nil }.to raise_error(NoMethodError) }

  describe 'return value of #to_cookie' do
    subject(:cookie) { token.to_cookie }

    specify { expect(subject).to_not be_empty }
  end

  describe 'return value of #from_cookie' do
    subject(:encoded) { token.to_cookie }

    specify { expect(Token.from_cookie(encoded)).to be_an_instance_of Token }
  end

  describe 'return value of #refresh!' do
    let(:user) { build(:user) }

    before { user.register! }

    subject(:token) { Token.new user.login!.body }

    specify { expect { subject.refresh! }.to change { subject.access_token } }
  end

  describe 'return value of #logout!' do
    let(:user) { build(:user) }

    before { user.register! }

    specify { expect { subject.logout! }.to_not raise_error }
  end

  describe 'return value of #expires' do
    subject(:expires) { token.expires }

    it { should be_a Time }

    it { should be > Time.now.utc }
  end

  describe 'return value of #to_header' do
    subject(:header) { token.to_header }

    it { should be_a Hash }

    it { should eq({ token.token_type.capitalize => token.access_token }) }
  end
end
