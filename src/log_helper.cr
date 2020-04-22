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
  def {{method.id}}(*, exception : Exception? = nil, &block : -> NamedTuple | Hash(String | Symbol, V)) forall V
    Log.with_context do
      previous_def(exception: exception) do
        block_result = yield
        block_result = block_result.to_h if block_result.is_a? NamedTuple && block_result.has_key?("message")

        message = block_result.delete(:message) || block_result.delete("message") if block_result.is_a? Hash
        Log.context.set(block_result)

        message
      end
    end
  end
  {% end %}
end
