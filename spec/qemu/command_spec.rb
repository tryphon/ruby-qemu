require 'spec_helper'

describe QEMU::Command do

  let(:command) { QEMU::Command.new }
  subject { command }

  describe "#name" do

    it "should be 'qemu' by default" do
      subject.name.should == "qemu"
    end

    it "should be the given name" do
      subject.name = "test"
      subject.name.should == "test"
    end

  end

  describe "#command" do

    subject { command.command }

    context "when architecture is i386" do
      before { command.architecture = :i386 }

      it { should == "/usr/bin/qemu-system-i386" }
    end

    context "when architecture is amd64" do
      before { command.architecture = :amd64 }

      it { should == "/usr/bin/qemu-system-x86_64" }
    end

  end

  describe "#command_arguments" do

    it "should include -m with memory size" do
      subject.memory = 800
      subject.command_arguments.should include("-m", "800")
    end

    it "should not include -m when no memory is specified" do
      subject.memory = nil
      subject.command_arguments.should_not include("-m")
    end


  end

end
