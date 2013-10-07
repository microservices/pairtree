require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')
require 'pairtree'

describe "Pairtree::Obj" do

  before(:all) do
    @base_path = File.join(File.dirname(__FILE__), "../test_data/working")
    Dir.chdir(File.join(File.dirname(__FILE__), "../test_data")) do
      FileUtils.cp_r('fixtures/pairtree_root_spec', './working')
    end
    @root = Pairtree.at(@base_path)
    @obj = @root.get('pfx:abc123def')
  end
  
  after(:all) do
    FileUtils.rm_rf(@base_path)
  end
  
  it "should read a file" do
    @obj.read('content.xml').should == '<content/>'
  end

  it "should have entries" do
    @obj.entries.should == ['content.xml']
  end
  
  it "should glob" do
    @obj['*.xml'].should == ['content.xml']
    @obj['*.txt'].should == []
  end
  
  it "should be enumerable" do
    block_body = double('block_body')
    block_body.should_receive(:yielded).with('content.xml')
    @obj.each { |file| block_body.yielded(file) }
  end
  
  describe "Call a bunch of File methods" do
    before(:each) do
      @target = File.join(@base_path, 'pairtree_root/ab/c1/23/de/f/abc123def/content.xml')
    end
    
    it "should open a file" do
      File.should_receive(:open).with(@target,'r')
      @obj.open('content.xml','r')
    end

    it "should call delete" do
      File.should_receive(:delete).with(@target)
      @obj.delete('content.xml')
    end

    it "should call link" do
      File.should_receive(:link).with(@target,@target + '.2')
      @obj.link('content.xml','content.xml.2')
    end

    it "should call rename" do
      File.should_receive(:rename).with(@target,@target + '.new')
      @obj.rename('content.xml','content.xml.new')
    end

    it "should call utime" do
      File.should_receive(:utime).with(0,1,@target)
      @obj.utime(0,1,'content.xml')
    end
  end
  
end
