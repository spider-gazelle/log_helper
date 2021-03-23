require "./spec_helper"

Log.setup(:none)

def expect_log_data(message, data)
  Log.capture do |checker|
    yield
    checker.next(::Log::Severity::Fatal, message).entry.tap do |e|
      e.message.should eq message
      e.data.should eq ::Log::Metadata.build(data)
    end
  end
end

describe ::Log do
  it "sets entry data via blocks that return a NamedTuple" do
    expect_log_data("okay", {:hello => "world"}) do
      Log.fatal { {hello: "world", message: "okay"} }
    end
  end

  it "sets entry data via blocks that return a Hash" do
    expect_log_data("okay", {:hello => "world"}) do
      Log.fatal { {:hello => "world", :message => "okay"} }
    end
  end

  it "works with missing `message` within a NamedTuple" do
    expect_log_data("", {:hello => "world"}) do
      Log.fatal { {hello: "world"} }
    end
  end

  it "works with missing `message` within a Hash" do
    expect_log_data("", {:hello => "world"}) do
      Log.fatal { {:hello => "world"} }
    end
  end

  it "works with nil `message` within a NamedTuple" do
    expect_log_data("", {:hello => "world"}) do
      Log.fatal { {hello: "world"} }
    end
  end

  it "works with nil `message` within a Hash" do
    expect_log_data("", {:hello => "world"}) do
      Log.fatal { {:hello => "world", :message => nil} }
    end
  end
end
