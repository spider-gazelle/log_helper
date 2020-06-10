require "./spec_helper"

describe Log do
  output = IO::Memory.new
  backend = Log::IOBackend.new(output)
  backend.formatter = Log::Formatter.new do |entry, io|
    io << entry.message
    io << ": "
    entry.context.each do |k, v|
      io << k << "=" << v
    end
    entry.data.each do |k, v|
      io << k << "=" << v
    end
  end

  log = Log.for("*", level: :trace)

  Spec.before_suite do
    Log.builder.clear
    log.backend = backend
  end

  Spec.before_each { output.clear }

  it "sets entry data via blocks that return a NamedTuple" do
    log.fatal { {hello: "world", message: "okay"} }
    message, _, rest = output.to_s.chomp.partition(": ")
    message.should eq "okay"
    rest.should eq "hello=world"
  end

  it "sets entry data via blocks that return a Hash" do
    log.fatal { {:hello => "world", :message => "okay"} }
    message, _, rest = output.to_s.chomp.partition(": ")
    message.should eq "okay"
    rest.should eq "hello=world"
  end

  it "works with nil `Message`s within a NamedTuple" do
    log.fatal { {hello: "world", message: nil} }
    message, _, rest = output.to_s.chomp.partition(": ")
    message.should eq ""
    rest.should eq "hello=world"
  end

  it "works with nil `Message`s within a Hash" do
    log.fatal { {:hello => "world", :message => nil} }
    message, _, rest = output.to_s.chomp.partition(": ")
    message.should eq ""
    rest.should eq "hello=world"
  end
end
