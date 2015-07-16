describe UserApi do

  let(:klass) { UserApi }

  describe "static methods" do

    subject { klass }

    it { should respond_to(:endpoint) }
    it { should respond_to(:client_id) }
    it { should respond_to(:client_secret) }
    it { should respond_to(:login) }
    it { should respond_to(:register) }

    describe "return value of #endpoint" do
      subject { klass.endpoint }
      it { should be_a String }
      it { should_not be_empty }
      it { should eq ENV['CLIENT_ENDPOINT'] }
    end

    describe "return value of #client_id" do
      subject { klass.client_id }
      it { should be_a String }
      it { should_not be_empty }
      it { should eq ENV['CLIENT_ID'] }
    end

    describe "return value of #client_secret" do
      subject { klass.client_secret }
      it { should be_a String }
      it { should_not be_empty }
      it { should eq ENV['CLIENT_SECRET'] }
    end

    describe "return value of #register" do

      describe "when the request is valid" do

        let(:email) { "david+ullr-#{Faker::Code.ean}@stockflare.com" }
        let(:password) { "UllrTesting" }
        let(:payload) { { email: email, password: password } }

        subject { klass.register payload }

        specify { expect(subject[:email]).to eq email }

      end

      describe "when the request is invalid" do

        let(:email) { "david+ullr-#{Faker::Code.ean}@stockflare.com" }
        let(:password) { nil }
        let(:payload) { { email: email, password: password } }

        specify { expect { klass.register payload }.to raise_error klass::Errors::BadRequest }

      end

      describe "when the email is already taken" do

        let(:email) { "david+ullr@stockflare.com" }
        let(:password) { "AlreadyTakenEmail" }
        let(:payload) { { email: email, password: password } }

        specify { expect { klass.register payload }.to raise_error klass::Errors::BadRequest }

      end

    end

    describe "return value of #login" do

      describe "when the user exists" do

        let(:username) { "david+ullr@stockflare.com" }
        let(:password) { "UllrTesting" }
        let(:payload) { { username: username, password: password } }

        subject { klass.login payload }

        specify { expect(subject.keys).to include :access_token, :refresh_token }

      end

      describe "when the user does not exist" do

        let(:username) { Faker::Internet.email }
        let(:password) { Faker::Internet.password }
        let(:payload) { { username: username, password: password } }

        specify { expect { klass.login payload }.to raise_error klass::Errors::UserNotFound }

      end

      describe "when the request is invalid" do

        let(:username) { Faker::Internet.email }
        let(:payload) { { username: username } }

        specify { expect { klass.login payload }.to raise_error klass::Errors::UserNotFound }

      end

      describe "when the user has MFA enabled" do

        let(:username) { "david+ullr-mfa@stockflare.com" }
        let(:password) { "UllrTesting" }
        let(:payload) { { username: username, password: password } }

        specify { expect {  klass.login payload }.to raise_error klass::Errors::MfaEnforced }

      end

    end

  end

  let(:user) { build(:user) }

  before { @api = klass.new(user) }

  subject { @api }

  it { should respond_to(:logout) }
  it { should respond_to(:refresh) }
  it { should respond_to(:authorization_header) }
  it { should respond_to(:user) }

  describe "return value of #authorization_header" do

    let(:access_token) { Faker::Internet.password }
    before { @user = create(:user, access_token: access_token) }
    before { @api = klass.new(@user) }
    subject { @api.authorization_header }

    it { should be_a Array }
    it { should eq [:Bearer, access_token] }

  end

  describe "return value of #refresh" do

    describe "when the user is logged in" do
      before(:all) { @user = User.login! "david+ullr@stockflare.com", "UllrTesting" }
      before { @api = klass.new(@user) }
      specify { expect(@api.refresh[:access_token]).to_not eq @user.access_token }
    end

    describe "when the user is not logged in" do
      specify { expect { @api.refresh }.to raise_error klass::Errors::UserNotFound }
    end

  end

  describe "return value of #me" do

    describe "when the user is logged in" do
      before(:all) { @user = User.login! "david+ullr@stockflare.com", "UllrTesting" }
      before { @api = klass.new(@user) }
      specify { expect(@api.me[:email]).to eq "david+ullr@stockflare.com" }
    end

    describe "when the user is not logged in" do
      specify { expect { @api.me }.to raise_error klass::Errors::UserNotFound }
    end

  end

  describe "return value of #revoke" do

    describe "when the user is logged in" do
      before(:all) { @user = User.login! "david+ullr@stockflare.com", "UllrTesting" }
      before { @api = klass.new(@user) }
      specify { expect { @api.logout }.to_not raise_error }
    end

  end

  describe "return value of #user" do
    subject { @api.user }
    it { should eq user }
    it { should be_an_instance_of User }
  end

end
