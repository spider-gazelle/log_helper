require "log"

class Log
  private SEVERITY_MAP = {
    debug:   Severity::Debug,
    verbose: Severity::Verbose,
    info:    Severity::Info,
    warn:    Severity::Warning,
    error:   Severity::Error,
    fatal:   Severity::Fatal,
  }

  {% for method, severity in SEVERITY_MAP %}
  def {{method.id}}(*, exception : Exception? = nil)
    Log.with_context do
      previous_def(exception: exception) do
        block_result = yield

        block_result = block_result.to_h if block_result.is_a? NamedTuple

        if block_result.is_a? Hash
          message = block_result.delete(:message) || block_result.delete("message")
          Log.context.set(block_result)
          message
        else
          block_result
        end
      end
    end
  end
  {% end %}
end

class Log::Context
  # TODO: Remove after 0.34.0
  def initialize(raw : Type?)
    @raw = raw.nil? ? "" : raw
  end

  # TODO: Remove when Crystal allows Symbol in the Log::Context datum
  def initialize(raw : String | Symbol)
    @raw = raw.is_a?(Symbol) ? raw.to_s : raw
  end
end
