require "log"

class Log
  private SEVERITY_MAP = {
    trace:  Severity::Trace,
    debug:  Severity::Debug,
    info:   Severity::Info,
    notice: Severity::Notice,
    warn:   Severity::Warn,
    error:  Severity::Error,
    fatal:  Severity::Fatal,
    none:   Severity::None,
  }

  {% for method, severity in SEVERITY_MAP %}
  def {{method.id}}(*, exception : Exception? = nil)
    previous_def(exception: exception) do |dsl|
      block_result = yield dsl

      if block_result.is_a? Hash
        message = block_result.delete(:message) || block_result.delete("message")
        dsl.emit(message: message, data: block_result)
      elsif block_result.is_a? NamedTuple
        dsl.emit(**block_result)
      else
        block_result
      end
    end
  end
  {% end %}
end

struct Log::Metadata::Value
  def initialize(raw : String | Symbol)
    @raw = raw.is_a?(Symbol) ? raw.to_s : raw
  end
end
