describe Votes::Vote do
  subject(:vote) { build(:vote) }

  it { should respond_to(:id) }

  it { should respond_to(:attitude) }

  specify { expect { subject.id = nil }.to raise_error(NoMethodError) }

  specify { expect { subject.attitude = nil }.to raise_error(NoMethodError) }
end
