require "./spec_helper"

describe Log do
  output = IO::Memory.new
  backend = Log::IOBackend.new(output)
  backend.formatter = Log::Formatter.new do |entry, io|
    io << entry.message
    io << ": "
    entry.context.as_h.each do |k, v|
      io << k << "=" << v
    end
  end
  Log.setup_from_env(backend: backend)
  Spec.before_each { output.clear }

  it "sets context via blocks that return a NamedTuple" do
    Log.info { {hello: "world", message: "okay"} }
    message, _, rest = output.to_s.chomp.partition(": ")
    message.should eq "okay"
    rest.should eq "hello=world"
  end

  it "sets context via blocks that return a Hash" do
    Log.info { {:hello => "world", :message => "okay"} }
    message, _, rest = output.to_s.chomp.partition(": ")
    message.should eq "okay"
    rest.should eq "hello=world"
  end
end
