require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')
require 'pairtree'

describe "Pairtree::Path" do
  
  after(:each) do
    Pairtree::Path.set_leaf { |id| id }
  end
  
  it "should generate an encoded id as the leaf path by default" do
    Pairtree::Path.leaf('abc/def').should == "abc=def"
  end

  it "should accept a nil override" do
    Pairtree::Path.set_leaf nil
    Pairtree::Path.leaf('abc/def').should == ""
  end
  
  it "should accept a scalar override" do
    Pairtree::Path.set_leaf 'obj'
    Pairtree::Path.leaf('abc/def').should == "obj"
  end
  
  it "should accept a Proc override" do
    lp = Proc.new { |id| id.reverse }
    Pairtree::Path.set_leaf(lp)
    Pairtree::Path.leaf('abc/def').should == "fed=cba"
  end
  
  it "should accept a block override" do
    Pairtree::Path.set_leaf { |id| id.reverse }
    Pairtree::Path.leaf('abc/def').should == "fed=cba"
  end
  
end
