# Define some helpers that can be handy in case of process piloting from IO
class IO

  alias :gets_ORG_ProcessPilot :gets
  # Add the possibility to gets to take an optional Hash:
  # *:time_out_secs* (_Integer_): Timeout in seconds to read data. nil means no timeout (regular gets) [optional = nil].
  def gets(*iArgs)
    if (iArgs[-1].is_a?(Hash))
      lOptions = iArgs[-1]
      return protect_with_timeout(lOptions[:time_out_secs]) do
        next gets_ORG_ProcessPilot(*iArgs[0..-2])
      end
    else
      return gets_ORG_ProcessPilot(*iArgs)
    end
  end

  alias :read_ORG_ProcessPilot :read
  # Add the possibility to gets to take an optional Hash:
  # *:time_out_secs* (_Integer_): Timeout in seconds to read data. nil means no timeout (regular gets) [optional = nil].
  def read(*iArgs)
    if (iArgs[-1].is_a?(Hash))
      lOptions = iArgs[-1]
      return protect_with_timeout(lOptions[:time_out_secs]) do
        next read_ORG_ProcessPilot(*iArgs[0..-2])
      end
    else
      return read_ORG_ProcessPilot(*iArgs)
    end
  end

  # Read lines until a given pattern is recognized
  #
  # Parameters::
  # * *iPattern* (_Regexp_): The pattern to match. Can also be a _String_ for exact match (don't forget \n).
  # * *iOptions* (<em>map<Symbol,Object></em>): Additional options [optional = {}]:
  #   * *:time_out_secs* (_Integer_): Timeout in seconds to read data and find the pattern. nil means no timeout. [optional = nil]
  # Return::
  # * <em>list<String></em>: The list of lines read
  def gets_until(iPattern, iOptions = {})
    rLstLines = []

    lTimeOutSecs = iOptions[:time_out_secs]
    protect_with_timeout(lTimeOutSecs) do
      if (iPattern.is_a?(Regexp))
        while ((rLstLines << self.gets(:time_out_secs => lTimeOutSecs))[-1].match(iPattern) == nil)
          #$stdout.puts "Read from IO: #{rLstLines[-1].inspect}"
          raise(IOError, 'End of stream') if (rLstLines[-1] == nil)
        end
      else
        while ((rLstLines << self.gets(:time_out_secs => lTimeOutSecs))[-1] != iPattern)
          #$stdout.puts "Read from IO: #{rLstLines[-1].inspect}"
          raise(IOError, 'End of stream') if (rLstLines[-1] == nil)
        end
      end
      #$stdout.puts "Read from IO: #{rLstLines[-1].inspect}"
    end

    return rLstLines
  end

  private

  # Protect some code with an optional timeout.
  # Return the value of the client code block.
  #
  # Parameters::
  # * *iTimeOutSecs* (_Integer_): Time out to perform. Can be nil for no timeout.
  # * _CodeBlock_: The code called
  def protect_with_timeout(iTimeOutSecs)
    if (iTimeOutSecs == nil)
      return yield
    else
      return Timeout::timeout(iTimeOutSecs) do
        next yield
      end
    end
  end

end
