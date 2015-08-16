describe User do

  subject(:user) { build(:user) }

  it { should respond_to(:username) }

  it { should respond_to(:password) }

  it { should respond_to(:otp) }

  it { should respond_to(:id) }

  it { should respond_to(:register!) }

  it { should respond_to(:login!) }

  specify { expect { subject.username = nil }.to raise_error(NoMethodError) }

  specify { expect { subject.id = nil }.to raise_error(NoMethodError) }

  specify { expect { subject.password = nil }.to raise_error(NoMethodError) }

  specify { expect { subject.otp = nil }.to raise_error(NoMethodError) }

  describe 'return value of #get' do
    before { user.register! }

    let(:token) { Token.new user.login!.body }

    specify { expect(User.get(token).username).to eq user.username }
  end

  describe 'return value of #register!' do
    subject(:response) { user.register! }

    specify { expect(subject.body.response.email).to eq user.username }
  end

  describe 'return value of #login' do
    before { subject.register! }

    specify { expect(subject.login!.body.access_token).to_not be_empty }
  end

  describe 'yield of #execute' do
    describe 'valid register!' do
      specify { expect { |b| subject.execute(:register!, &b) }.to yield_with_args(false, anything()) }
    end

    describe 'invalid register!' do
      before { subject.register! }

      specify { expect { |b| subject.execute(:register!, &b) }.to yield_with_args(true, anything()) }
    end

    describe 'valid login!' do
      before { subject.register! }

      specify { expect { |b| subject.execute(:login!, &b) }.to yield_with_args(false, anything()) }
    end

    describe 'invalid login!' do
      specify { expect { |b| subject.execute(:login!, &b) }.to yield_with_args(true, anything()) }
    end
  end
end
