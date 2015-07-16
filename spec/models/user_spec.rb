describe User do

  before { @user = create(:user) }

  subject { @user }

  it { should be_valid }

  it { should respond_to(:access_token) }
  it { should respond_to(:refresh_token) }
  it { should respond_to(:expires_at) }
  it { should respond_to(:expires_in) }
  it { should respond_to(:token_type) }

  describe "when #access_token is nil" do
    before { subject.access_token = nil }
    it { should_not be_valid }
  end

  describe "when #expires_at is nil" do
    before { subject.expires_at = nil }
    it { should_not be_valid }
  end

  describe "when #expires_in is nil" do
    before { subject.expires_in = nil }
    it { should_not be_valid }
  end

  describe "when #token_type is nil" do
    before { subject.token_type = nil }
    it { should_not be_valid }
  end

  describe "when #register! is called" do

    specify { expect { User.register! "david+ullr-#{Faker::Code.ean}@stockflare.com", "UllrTesting" }.to change { User.count }.by(1) }

    specify { expect { User.register! "david+ullr@stockflare.com", "UllrTesting" }.to raise_error ActiveRecord::RecordInvalid }

    specify { expect { User.register! "david+ullr@stockflare.com", nil }.to raise_error ActiveRecord::RecordInvalid }

    specify { expect { User.register! nil, "UllrTesting" }.to raise_error ActiveRecord::RecordInvalid }

    describe "when the request is invalid" do
      specify { expect { User.register! nil, nil }.to raise_error ActiveRecord::RecordInvalid }
    end

  end

  describe "when #login! is called" do

    before(:all) { @logged_in_user = User.login! "david+ullr@stockflare.com", "UllrTesting" }

    subject { @logged_in_user }

    specify { expect(subject.access_token).to_not be_empty }
    specify { expect(subject.refresh_token).to_not be_empty }
    specify { expect(subject.token_type).to eq "bearer"}
    specify { expect(subject.expires_in).to be > 0 }
    specify { expect(subject.expires_at.to_i).to be_within(2).of((Time.now + subject.expires_in).to_i) }
    specify { expect(subject.refresh?).to be_falsey }

    describe "when the user does not exist" do
      specify { expect { User.login! Faker::Internet.email, "lol" }.to raise_error ActiveRecord::RecordNotFound }
    end

  end

  describe "when #refresh! is called" do

    before { @user = User.login! "david+ullr@stockflare.com", "UllrTesting" }

    specify { expect { @user.refresh! }.to change { @user.access_token } }

    describe "when the user does not exist" do
      specify { expect { build(:user).refresh! }.to raise_error ActiveRecord::RecordNotFound }
    end

  end

  describe "when #logout! is called" do

    describe "when the user is authenticated" do
      before { @user = User.login! "david+ullr@stockflare.com", "UllrTesting" }
      specify { expect { @user.logout! }.to change { User.count }.by(-1) }
    end

    describe "when the user is not authenticated" do
      before { @user = build(:user) }
      specify { expect { @user.logout! }.to_not change { User.count } }
    end

  end

  describe "return value of #refresh?" do
    describe "when the token needs refreshing" do
      before do
        subject.expires_at = Time.now + 1.minute
        subject.expires_in = 3.minutes
      end
      specify { expect(subject.refresh?).to be_truthy }
    end

    describe "when the token does not need refreshing" do
      before do
        subject.expires_at = Time.now + 5.minute
        subject.expires_in = 5.minutes
      end
      specify { expect(subject.refresh?).to be_falsey }
    end
  end

  describe "return value of #authenticate" do
    describe "when the user exists" do
      let(:valid_access_token) { @user.access_token }
      specify { expect(User.authenticate(valid_access_token)).to be_truthy }
    end
    describe "when the user does not exist" do
      let(:invalid_access_token) { "abc" }
      specify { expect(User.authenticate(invalid_access_token)).to be_falsey }
    end
  end

end
