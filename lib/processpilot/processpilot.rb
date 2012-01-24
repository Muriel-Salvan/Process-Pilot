#--
# Copyright (c) 2012 Muriel Salvan (murielsalvan@users.sourceforge.net)
# Licensed under the terms specified in LICENSE file. No warranty is provided.
#++

require 'open3'
require 'timeout'

module ProcessPilot

  class ChildProcessInfo

    # Constructor
    #
    # Parameters:
    # * *iWaitThread* (_Thread_): The waiting thread, can be nil if already stopped or dead
    def initialize(iWaitThread)
      @WaitThread = iWaitThread
    end

    # Has the waiting process exited already ?
    #
    # Return:
    # * _Boolean_: Has the waiting process exited already ?
    def exited?
      return ((@WaitThread == nil) or (@WaitThread.stop?))
    end

    # Stop the process' execution
    def stop
      @WaitThread.kill if @WaitThread
    end

  end

  # Pilot a process.
  # This will create a new thread for the process to be run.
  # If the process is a Ruby process, you can force STDOUT sync by specifying it in options. In this case the command line should begin with the Ruby file name to be executed (don't use ruby executable, and specifiy ruby options in iOptions[:RubyCmdLine]).
  #
  # Parameters:
  # * *iCmdLine* (<em>list<String></em>): The process' command line
  # * *iOptions* (<em>map<Symbol,Object></em>): Optional arguments [optional = nil]:
  # ** *:ForceRubyProcessSync* (_Boolean_): If the command line is a Ruby process, force setting STDOUT to be synced. [optional = false]
  # ** *:RubyCmdLine* (<em>list<String></em>): Command line of Ruby interpreter with options (used only if :ForceRubyProcessSync is true) [optional = ['ruby']]
  # ** *:Debug* (_Boolean_): Do we activate some debugging traces ? (need rUtilAnts gem if activated) [optional = false]
  # * _CodeBlock_: The code called for process piloting:
  # ** Parameters:
  # ** *oStdIN* (_IO_): The process' STDIN
  # ** *iStdOUT* (_IO_): The process' STDOUT
  # ** *iStdERR* (_IO_): The process' STDERR
  # ** *iChildProcess* (_ChildProcess_): The corresponding child process. Don't use it to pilot std* IO objects. Depending on the platforms, this might be nil.
  def self.pilot(*iArgs)
    iCmdLine = iArgs
    iOptions = (iArgs[-1].is_a?(Hash)) ? iArgs.pop : {}
    iForceRubyProcessSync = (iOptions[:ForceRubyProcessSync] || false)
    iRubyCmdLine = (iOptions[:RubyCmdLine] || ['ruby'])
    iDebug = (iOptions[:Debug] || false)

    if ((iDebug) and (require 'rUtilAnts/Logging'))
      # First time it was required: set it up
      RUtilAnts::Logging::initializeLogging('', '')
      activateLogDebug(true)
    end

    # Wrap eventually Ruby command line
    lRealCmdLine = (iForceRubyProcessSync) ? iRubyCmdLine + [ "#{File.dirname(__FILE__)}/wrapper.rb" ] + iCmdLine : iCmdLine

    logDebug "[ProcessPilot] Command line: #{lRealCmdLine.inspect}" if iDebug
    Open3::popen3(*lRealCmdLine) do |oStdIN, iStdOUT, iStdERR, iWaitThread|
      yield(oStdIN, iStdOUT, iStdERR, ChildProcessInfo.new(iWaitThread))
    end
  end

end

# Define some helpers that can be handy in case of process piloting from IO
class IO

  alias :gets_ORG_ProcessPilot :gets
  # Add the possibility to gets to take an optional Hash:
  # *:TimeOutSecs* (_Integer_): Timeout in seconds to read data. nil means no timeout (regular gets) [optional = nil].
  def gets(*iArgs)
    if (iArgs[-1].is_a?(Hash))
      lOptions = iArgs[-1]
      lTimeOutSecs = lOptions[:TimeOutSecs]
      if (lTimeOutSecs == nil)
        return gets_ORG_ProcessPilot(*iArgs[0..-2])
      else
        return Timeout::timeout(lTimeOutSecs) do
          next gets_ORG_ProcessPilot(*iArgs[0..-2])
        end
      end
    else
      return gets_ORG_ProcessPilot(*iArgs)
    end
  end

  alias :read_ORG_ProcessPilot :read
  # Add the possibility to gets to take an optional Hash:
  # *:TimeOutSecs* (_Integer_): Timeout in seconds to read data. nil means no timeout (regular gets) [optional = nil].
  def read(*iArgs)
    if (iArgs[-1].is_a?(Hash))
      lOptions = iArgs[-1]
      lTimeOutSecs = lOptions[:TimeOutSecs]
      if (lTimeOutSecs == nil)
        return read_ORG_ProcessPilot(*iArgs[0..-2])
      else
        return Timeout::timeout(lTimeOutSecs) do
          next read_ORG_ProcessPilot(*iArgs[0..-2])
        end
      end
    else
      return read_ORG_ProcessPilot(*iArgs)
    end
  end

end
