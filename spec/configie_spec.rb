require 'spec_helper'
require 'configie'

describe Configie do
  subject { Configie }

  it 'has a VERSION constant' do
    expect(subject.const_get('VERSION')).not_to be_empty
  end

  it 'accepts a block to define properties' do
    config = subject.new do
      a_property :value
      another_property :value2
    end

    expect(config.a_property).to equal :value
    expect(config.another_property).to equal :value2
  end

  context 'about closure' do
    context 'about variable closure' do
      it 'accepts variable closure' do
        outter_var_val = :outter_var
        config = subject.new do
          outter_var_key outter_var_val
        end
        expect(config.outter_var_key).to equal :outter_var
      end

      it 'accepts class variable closure' do
        outter_var_val = subject.new
        config = subject.new do
          outter_var_key outter_var_val
        end
        expect(config.outter_var_key).to equal outter_var_val
      end

      it 'accepts instance variable closure' do
        @outter_var_val = :outter_var
        config = subject.new do
          outter_var_key @outter_var_val
        end
        skip("instantce variable closure can't be supported")
        expect(config.outter_var_key).to equal :outter_var
      end
    end

    context 'about function closure' do
      it 'accepts function closure' do
        def outter_func_val()
          :outter_func
        end
        config = subject.new do
          outter_func_key outter_func_val
        end
        expect(config.outter_func_key).to equal :outter_func
      end

      it 'accepts function closure with params' do
        def outter_func_val(params)
          "outter_func_#{params.to_s}"
        end
        config = subject.new do
          outter_func_key outter_func_val("foo")
        end
        expect(config.outter_func_key).to eq "outter_func_foo"
      end

      let(:lazy_property) { :i_am_lazy }
      it 'accepts lazy-defined closure' do
        config = subject.new do
          outter_key lazy_property
        end
        expect(config.outter_key).to equal :i_am_lazy
      end
    end
  end

  it 'accepts deep merged properties' do
    config = subject.new do
      deep_hash do
        item_a :something
        item_b :something_else
      end
    end
    expect(config.deep_hash.item_a).to equal :something
    expect(config.deep_hash.item_b).to equal :something_else
  end

  it 'accepts lambda as value' do
    config = subject.new do
      condition lambda { |x| x == 0 }
    end
    expect(config.condition.call(0)).to be true
  end

  it 'allows user properties immediately' do
    config = subject.new do
      flag :test_flag

      if flag == :test_flag
        something :something
      else
        other :other
      end
    end

    expect(config.something).to equal :something
    expect(config.other).to be_nil
  end

  context 'about merge' do
    before do
      subject do
        merged :unmerged
      end
    end

    it 'allows user to merge more properties' do
      dup = subject.merge do
        merged :merged_thing
      end
      subject.merged.should equal :unmerged
      dup.merged.should equal :merged_thing
    end

    it 'allows user to merge more properties to itself' do
      dup = subject.merge! do
        merged :merged_thing2
      end
      subject.merged.should equal :merged_thing2
      subject.should equal dup
    end
  end

end
