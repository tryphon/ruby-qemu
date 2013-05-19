require 'spec_helper'

describe QEMU::Command do
  
  describe "#name" do
    
    it "should be 'qemu' by default" do
      subject.name.should == "qemu"
    end

    it "should be the given name" do
      subject.name = "test"
      subject.name.should == "test"
    end

  end

end
