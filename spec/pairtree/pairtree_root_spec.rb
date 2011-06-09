require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')
require 'pairtree'

describe "Pairtree::Root" do
  
  before(:all) do
    @pairtree = Pairtree::Client.new(File.join(File.dirname(__FILE__), "../test_data"))
    @root = @pairtree.root
  end
  
  it "should have the correct prefix" do
    @pairtree.prefix.should == 'pfx:'
  end
  
  it "should list identifiers" do
    @root.list.should == ['pfx:abc123def']
  end
  
end