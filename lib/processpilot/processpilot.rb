require 'open3'
require 'timeout'
require 'processpilot/io'

module ProcessPilot

  class ChildProcessInfo

    # Constructor
    #
    # Parameters::
    # * *iWaitThread* (_Thread_): The waiting thread, can be nil
    def initialize(iWaitThread)
      @WaitThread = iWaitThread
    end

    # Has the waiting process exited already ?
    #
    # Return::
    # * _Boolean_: Has the waiting process exited already ?
    def exited?
      return ((@WaitThread == nil) or (@WaitThread.stop?))
    end

    # Return the exit status
    #
    # Return::
    # * <em>Process::Status</em>: The exit status
    def exit_status
      return (@WaitThread == nil) ? nil : @WaitThread.value
    end

    # Stop the process' execution
    def stop
      @WaitThread.kill if @WaitThread
    end

  end

  # Pilot a process.
  # This will create a new thread for the process to be run.
  # If the process is a Ruby process, you can force STDOUT sync by specifying it in options. In this case the command line should begin with the Ruby file name to be executed (don't use ruby executable, and specifiy ruby options in iOptions[:ruby_cmd_line]).
  #
  # Parameters::
  # * *iCmdLine* (<em>list<String></em>): The process' command line
  # * *iOptions* (<em>map<Symbol,Object></em>): Optional arguments [optional = nil]:
  #   * *:force_ruby_process_sync* (_Boolean_): If the command line is a Ruby process, force setting STDOUT to be synced. [optional = false]
  #   * *:ruby_cmd_line* (<em>list<String></em>): Command line of Ruby interpreter with options (used only if :force_ruby_process_sync is true) [optional = ['ruby']]
  #   * *:debug* (_Boolean_): Do we activate some debugging traces ? (need rUtilAnts gem if activated) [optional = false]
  # * _CodeBlock_: The code called for process piloting:
  #   * Parameters::
  #   * *oStdIN* (_IO_): The process' STDIN
  #   * *iStdOUT* (_IO_): The process' STDOUT
  #   * *iStdERR* (_IO_): The process' STDERR
  #   * *iChildProcess* (_ChildProcess_): The corresponding child process. Don't use it to pilot std* IO objects. Depending on the platforms, this might be nil (always nil for Ruby < 1.9).
  def self.pilot(*iArgs)
    iCmdLine = iArgs
    iOptions = (iArgs[-1].is_a?(Hash)) ? iArgs.pop : {}
    iForceRubyProcessSync = (iOptions[:force_ruby_process_sync] || false)
    iRubyCmdLine = (iOptions[:ruby_cmd_line] || ['ruby'])
    iDebug = (iOptions[:debug] || false)

    if ((iDebug) and (require 'rUtilAnts/Logging'))
      # First time it was required: set it up
      RUtilAnts::Logging::install_logger_on_object(:debug_mode => true)
    end

    # Wrap eventually Ruby command line
    lRealCmdLine = (iForceRubyProcessSync) ? iRubyCmdLine + [ "#{File.dirname(__FILE__)}/wrapper.rb" ] + iCmdLine : iCmdLine

    log_debug "[ProcessPilot] Command line: #{lRealCmdLine.inspect}" if iDebug
    Open3::popen3(*lRealCmdLine) do |oStdIN, iStdOUT, iStdERR, iWaitThread|
      yield(oStdIN, iStdOUT, iStdERR, ChildProcessInfo.new(iWaitThread))
    end
  end

end
