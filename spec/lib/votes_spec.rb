describe Votes do

  let(:user) { build(:user) }

  before { user.register! }

  describe 'with new user information' do
    let(:token) { Token.new user.login!.body }

    subject(:votes) { User.get(token).votes }

    before { subject.fetch! }

    it { should be_empty }

    specify { expect(subject.cursor?).to be_falsey }

    specify { expect(subject.next_page).to be_an_instance_of Array }
  end

  describe 'with existing user information' do
    let(:token) { Token.new user.login!.body }

    subject(:votes) { User.get(token).votes }

    let(:vote) {
      {
        id: Faker::Internet.slug(nil, '-'),
        created_at: Time.now.utc,
        attitude: [0, 1].sample
      }
    }

    before { votes.vote_for(vote) }

    before { subject.fetch! }

    specify { expect(subject.first.id).to eq vote[:id] }
  end

  describe 'with existing user information' do
    let(:token) { Token.new user.login!.body }

    let(:per_page) { 1 }

    subject(:votes) { User.get(token).votes(per_page: per_page) }

    let(:upsert_votes) { [
      {
        id: Faker::Internet.slug(nil, '-'),
        created_at: Time.now.utc,
        attitude: [0, 1].sample
      },
      {
        id: Faker::Internet.slug(nil, '-'),
        created_at: Time.now.utc,
        attitude: [0, 1].sample
      }
    ] }

    before { upsert_votes.each { |vote| votes.vote_for(vote) } }

    before { subject.fetch! }

    specify { expect(subject.next_page.first.id).to_not eq subject.first.id }
  end

end
