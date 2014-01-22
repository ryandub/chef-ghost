require 'spec_helper'

describe 'Ghost Installation' do

  describe service('nginx') do
    it { should be_running }
    it { should be_enabled }
  end

  describe service('ghost') do
    it { should be_running }
    it { should be_enabled }
  end

  it 'should have the swayze theme installed' do
    expect(file '/var/www/vhosts/ghost.example.com/ghost/content/themes/swayze').to be_directory
  end

  it 'should have the ghostwriter theme installed' do
    expect(file '/var/www/vhosts/ghost.example.com/ghost/content/themes/ghostwriter').to be_directory
  end
end
