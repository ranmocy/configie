require 'spec_helper'
require 'configie'

describe Configie do
  it "should have a VERSION constant" do
    subject.const_get('VERSION').should_not be_empty
  end

  it 'accepts a block to define properties' do
    subject.new do
      a_property :value
      another_property :value2
    end

    subject.a_property.should == :value
    subject.another_property.should == :value2
  end

  it 'accepts deep merged properties' do
    subject.new do
      deep_hash do
        item_a :something
        item_b :something_else
      end
    end

    subject.deep_hash.item_a.should == :something
    subject.deep_hash.item_b.should == :something_else
  end

  it 'accepts lambda as value' do
    subject.new do
      condition lambda { |x| x == 0 }
    end

    subject.condition.call(0).should be_true
  end

  it 'allows user properties immediately' do
    subject.new do
      flag :test_flag

      if flag == :test_flag
        something :something
      else
        other :other
      end
    end

    subject.something.should == :something
    subject.other.should be_nil
  end

  context 'about merge' do
    before do
      subject.new do
        merged :unmerged
      end
    end

    it 'allows user to merge more properties' do
      dup = subject.merge do
        merged :merged_thing
      end
      subject.merged.should == :unmerged
      dup.merged.should == :merged_thing
    end

    it 'allows user to merge more properties to itself' do
      dup = subject.merge! do
        merged :merged_thing2
      end
      subject.merged.should == :merged_thing2
      subject.should == dup
    end
  end

end
