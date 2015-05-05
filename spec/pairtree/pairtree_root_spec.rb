require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')
require 'pairtree'

describe "Pairtree::Root" do
  
  before(:all) do
    @base_path = File.join(File.dirname(__FILE__), "../test_data/working")
    Dir.chdir(File.join(File.dirname(__FILE__), "../test_data")) do
      FileUtils.cp_r('fixtures/pairtree_root_spec', './working')
    end
    @root = Pairtree.at(@base_path)
  end
  
  after(:all) do
    FileUtils.rm_rf(@base_path)
  end
  
  it "should have the correct prefix" do
    expect(@root.prefix).to eql('pfx:')
  end
  
  it "should be in the correct location" do
    expect(File.expand_path(@root.path)).to eql(File.expand_path(@base_path))
    expect(File.expand_path(@root.root)).to eql(File.expand_path(File.join(@base_path, "pairtree_root")))
  end
  
  it "should list identifiers" do
    expect(@root.list).to eql(['pfx:abc123def'])
  end
  
  it "should verify whether an identifier exists" do
    expect(@root.exists?('pfx:abc123def')).to be true
    expect(@root.exists?('pfx:abc123jkl')).to be false
  end
  
  it "should raise an exception if an invalid prefix is used" do
    expect { @root.exists?('xfp:abc123def') }.to raise_error(Pairtree::IdentifierError)
  end
  
  it "should get a ppath for a valid ID" do
    obj = @root.get 'pfx:abc123def'
    expect(obj.class).to eql(Pairtree::Obj)
    expect(File.expand_path(obj.path)).to eql(File.expand_path(File.join(@base_path, "pairtree_root/ab/c1/23/de/f/abc123def/")))
  end
  
  it "should raise an exception when attempting to get a ppath for an invalid ID" do
    expect { @root.get 'pfx:abc123jkl' }.to raise_error(Errno::ENOENT)
  end
  
  it "should create a new ppath" do
    obj = @root.mk 'pfx:abc123jkl'
    expect(obj.class).to eql(Pairtree::Obj)
    expect(File.expand_path(obj.path)).to eql(File.expand_path(File.join(@base_path, "pairtree_root/ab/c1/23/jk/l/abc123jkl/")))
    expect(@root.exists?('pfx:abc123jkl')).to be true
  end
  
  it "should delete a ppath" do
    expect(@root.exists?('pfx:abc123jkl')).to be true
    @root.purge!('pfx:abc123jkl')
    expect(@root.exists?('pfx:abc123jkl')).to be false
  end
  
end