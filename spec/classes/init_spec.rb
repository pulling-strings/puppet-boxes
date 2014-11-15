require 'spec_helper'
describe 'boxes' do

  context 'with defaults for all parameters' do
    it { should contain_class('boxes') }
  end
end
