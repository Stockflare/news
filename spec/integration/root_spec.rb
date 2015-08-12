require 'rails_helper'

describe 'home page' do

  before { visit '/' }

  subject { page }

  it { should has_css?('navbar navbar-default') }

  it { should has_css?('jumbotron') }

  it { should has_css?('nav nav-pills') }

  it { should has_css?('breaker') }

  # it { should has_css?('h4', :text => 'Share').to be_truthy }

  describe 'the header bar' do

    specify { expect(subject.has_css?('h4', :text => 'Share')).to be_truthy }

  end


end

