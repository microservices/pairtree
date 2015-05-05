require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')
require 'pairtree'

describe "Pairtree::Path" do
  
  after(:each) do
    Pairtree::Path.set_leaf { |id| id }
  end
  
  it "should generate an encoded id as the leaf path by default" do
    expect(Pairtree::Path.leaf('abc/def')).to eql("abc=def")
  end

  it "should accept a nil override" do
    Pairtree::Path.set_leaf nil
    expect(Pairtree::Path.leaf('abc/def')).to eql("")
  end
  
  it "should accept a scalar override" do
    Pairtree::Path.set_leaf 'obj'
    expect(Pairtree::Path.leaf('abc/def')).to eql("obj")
  end
  
  it "should accept a Proc override" do
    lp = Proc.new { |id| id.reverse }
    Pairtree::Path.set_leaf(lp)
    expect(Pairtree::Path.leaf('abc/def')).to eql("fed=cba")
  end
  
  it "should accept a block override" do
    Pairtree::Path.set_leaf { |id| id.reverse }
    expect(Pairtree::Path.leaf('abc/def')).to eql("fed=cba")
  end
  
end
