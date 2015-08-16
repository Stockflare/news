require 'rails_helper'

describe 'root page' do
  let(:time) { Time.now.utc }

  let(:yesterday) { Time.now.utc - 60*60*24 }

  before { visit root_path }

  subject { page }

  it { should have_title 'Recent News' }

  it { should have_title time.strftime("#{time.day.ordinalize} %B %Y") }

  it { should have_content time.strftime("#{time.day.ordinalize} %B %Y") }

  it { should have_content yesterday.strftime("#{yesterday.day.ordinalize} %B %Y") }

  specify { expect(all('article').size).to be > 0 }

  describe 'when Yesterday is clicked' do
    let(:previous_day) { yesterday - 60*60*24 }

    before { first(:link, yesterday.strftime("#{yesterday.day.ordinalize} %B %Y")).click }

    it { should have_title yesterday.strftime("#{yesterday.day.ordinalize} %B %Y") }

    it { should have_content yesterday.strftime("#{yesterday.day.ordinalize} %B %Y") }

    it { should have_content time.strftime("#{time.day.ordinalize} %B %Y") }

    it { should have_content previous_day.strftime("#{previous_day.day.ordinalize} %B %Y") }
  end

  describe 'when Join for Free is clicked' do
    before { first(:link, 'Join for Free').click }

    it { should have_title 'Register' }
  end

  describe 'when Login is clicked' do
    before { first(:link, 'Login').click }

    it { should have_title 'Login' }
  end

  describe 'when Popular News is clicked' do
    before { first(:link, 'Top News').click }

    it { should have_title 'Popular News' }
  end

  describe 'when Recent News is clicked' do
    before { first(:link, 'Recent News').click }

    it { should have_title 'Recent News' }
  end
end
