require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')
require 'pairtree'

describe "Pairtree::Root" do
  
  before(:all) do
    @base_path = File.join(File.dirname(__FILE__), "../test_data/working")
    Dir.chdir(File.join(File.dirname(__FILE__), "../test_data")) do
      FileUtils.cp_r('fixtures/pairtree_root_spec', './working')
    end
    @pairtree = Pairtree::Client.new(@base_path)
    @root = @pairtree.root
  end
  
  after(:all) do
    FileUtils.rm_rf(@base_path)
  end
  
  it "should have the correct prefix" do
    @pairtree.prefix.should == 'pfx:'
  end
  
  it "should be in the correct location" do
    File.expand_path(@pairtree.root.pairtree_root.path).should == File.expand_path(File.join(@base_path, "pairtree_root"))
  end
  
  it "should list identifiers" do
    @root.list.should == ['pfx:abc123def']
  end
  
  it "should verify whether an identifier exists" do
    @root.exists?('pfx:abc123def').should be_true
    @root.exists?('pfx:abc123jkl').should be_false
  end
  
  it "should raise an exception if an invalid prefix is used" do
    lambda { @root.exists?('xfp:abc123def') }.should raise_error(Pairtree::IdentifierException)
  end
  
  it "should get a ppath for a valid ID" do
    obj = @root.get 'pfx:abc123def'
    obj.class.should == Pairtree::Obj
    File.expand_path(obj.path).should == File.expand_path(File.join(@base_path, "pairtree_root/ab/c1/23/de/f/abc123def/"))
  end
  
  it "should raise an exception when attempting to get a ppath for an invalid ID" do
    lambda { @root.get 'pfx:abc123jkl' }.should raise_error(Errno::ENOENT)
  end
  
  it "should create a new ppath" do
    obj = @root.mk 'pfx:abc123jkl'
    obj.class.should == Pairtree::Obj
    File.expand_path(obj.path).should == File.expand_path(File.join(@base_path, "pairtree_root/ab/c1/23/jk/l/abc123jkl/"))
    @root.exists?('pfx:abc123jkl').should be_true
  end
  
  it "should delete a ppath" do
    @root.exists?('pfx:abc123jkl').should be_true
    @root.purge!('pfx:abc123jkl')
    @root.exists?('pfx:abc123jkl').should be_false
  end
  
end