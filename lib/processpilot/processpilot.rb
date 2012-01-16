#--
# Copyright (c) 2012 Muriel Salvan (murielsalvan@users.sourceforge.net)
# Licensed under the terms specified in LICENSE file. No warranty is provided.
#++

require 'childprocess'
require 'tempfile'

module ProcessPilot

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
  # ** *iChildProcess* (_ChildProcess_): The corresponding child process. Don't use it to pilot std* IO objects.
  # ** Return:
  # ** _Boolean_: Do we have to wait until the process' completion ?
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
    lProcess = ChildProcess.build(*lRealCmdLine)

    # Indication of stdin usage
    lProcess.duplex = true

    # Specify files for stdout/stderr
    # ! Use w+ mode to make it possible for our monitoring thread to reopen the file in r mode
    Tempfile.open('processpilot.stdout') do |oStdOUT|
      logDebug "[ProcessPilot] STDOUT file: #{oStdOUT.path}" if iDebug
      lProcess.io.stdout = oStdOUT
      Tempfile.open('processpilot.stderr') do |oStdERR|
        logDebug "[ProcessPilot] STDERR file: #{oStdERR.path}" if iDebug
        lProcess.io.stderr = oStdERR

        # Start the process: this creates the background thread running our command
        lProcess.start

        # In our main thread: open the STDOUT/ERR files
        lStdOUT = File.open(oStdOUT.path, 'r')
        lStdERR = File.open(oStdERR.path, 'r')
        lStdIN = lProcess.io.stdin

        # Call client code
        lWaitUntilCompletion = yield(lStdIN, lStdOUT, lStdERR, lProcess)

        # Wait for the process termination in case it is late
        if (lWaitUntilCompletion)
          while (!lProcess.exited?)
            sleep 1
          end
        end
      end
    end

  end

end

# Define some helpers that can be handy in case of process piloting from IO
class IO

  # Exception thrown when timeout has been reached
  class TimeOutError < RuntimeError
  end

  # Implement a blocking read of a new string ending with newline.
  # Make sure we wait for the end of a string before returning.
  # This is done to ensure we will get the new string we are expecting.
  # If the timeout is reached, an exception is thrown.
  #
  # Parameters:
  # * *iOptions* (<em>map<Symbol,Object></em>): Optional arguments [optional = {}]:
  # ** *:TimeOutSecs* (_Integer_): Time out in seconds (nil = no timeout) [optional = nil]
  # ** *:PollingIntervalSecs* (_Float_): Polling interval in seconds [optional = 0.1]
  # ** *:ChildProcess* (_ChildProcess_): Corresponding child process linked to this IO. Can be used to detect the end of IO. [optional = nil]
  # Return:
  # * _String_: The next string from IO (separator is $/). Can be empty if the corresponding child process has exited already.
  def gets_blocking(iOptions = {})
    return get_data_blocking(
      Proc.new { |iStr| iStr[-1..-1] == $/ },
      iOptions
    ) do |iStr|
      next self.gets
    end
  end

  # Implement a blocking read of a given size.
  # Make sure we wait for the end of a string before returning.
  # This is done to ensure we will get the new string we are expecting.
  # If the timeout is reached, an exception is thrown.
  #
  # Parameters:
  # * *iSize* (_Integer_): Size of the data to read
  # * *iOptions* (<em>map<Symbol,Object></em>): Optional arguments [optional = {}]:
  # ** *:TimeOutSecs* (_Integer_): Time out in seconds (nil = no timeout) [optional = nil]
  # ** *:PollingIntervalSecs* (_Float_): Polling interval in seconds [optional = 0.1]
  # ** *:ChildProcess* (_ChildProcess_): Corresponding child process linked to this IO. Can be used to detect the end of IO. [optional = nil]
  # Return:
  # * _String_: The next string from IO (separator is $/). Can be empty if the corresponding child process has exited already.
  def read_blocking(iSize, iOptions = {})
    return get_data_blocking(
      Proc.new { |iStr| iStr.size == iSize },
      iOptions
    ) do |iStr|
      next self.read(iSize-iStr.size)
    end
  end

  # Send a synchronized input to an IO.
  # Make sure it will be flushed.
  #
  # Parameters:
  # * *iStr* (_String_): The string to send
  def write_flushed(iStr)
    self.write iStr
    self.flush
  end

  private

  # Implement a blocking read of a data unless the data read conforms to a given validation code.
  # Take a validation proc to know if the data was read correctly, and yields code to read effectively data.
  # Proper implementation should have a more efficient algo.
  # If the timeout is reached, an exception is thrown.
  #
  # Parameters:
  # * *iProcValidation* (_Proc_): The validation proc:
  # ** Parameters:
  # ** *iData* (_String_): The data to validate
  # ** Return:
  # ** _Boolean_: Is the data valid ?
  # * *iOptions* (<em>map<Symbol,Object></em>): Optional arguments [optional = {}]:
  # ** *:TimeOutSecs* (_Integer_): Time out in seconds (nil = no timeout) [optional = nil]
  # ** *:PollingIntervalSecs* (_Float_): Polling interval in seconds [optional = 0.1]
  # ** *:ChildProcess* (_ChildProcess_): Corresponding child process linked to this IO. Can be used to detect the end of IO. [optional = nil]
  # * _CodeBlock_: Code called to read data effectively:
  # ** Parameters:
  # ** *iStr* (_String_): The data already read
  # ** Return:
  # ** _String_: String of data read (can be nil if no data was read)
  # Return:
  # * _String_: The next string from IO (separator is $/). Can be empty if the corresponding child process has exited already.
  def get_data_blocking(iProcValidation, iOptions = {})
    rStr = ''
    iPollingInterval = (iOptions[:PollingIntervalSecs] || 0.1)
    iTimeOutSecs = iOptions[:TimeOutSecs]
    iChildProcess = iOptions[:ChildProcess]

    require 'time' if (iTimeOutSecs != nil)

    # Concatenate chunks unless we have the separator.
    # As we deal with stdin flow, it is possible to have a line without ending already written in the file and already flushed by the IO.
    lTimeOut = (iTimeOutSecs == nil) ? nil : Time.now + iTimeOutSecs
    while (!iProcValidation.call(rStr))
      lNewChunk = nil
      while (lNewChunk == nil)
        lNewChunk = yield(rStr)
        #$stdout.puts "===== Read #{lNewChunk.inspect}"
        break if ((iChildProcess != nil) and (iChildProcess.exited?))
        if (lNewChunk == nil)
          sleep iPollingInterval
          raise TimeOutError.new("Timeout of #{iTimeOutSecs} secs reached while waiting for data.") if ((lTimeOut != nil) and (Time.now > lTimeOut))
        end
      end
      rStr.concat(lNewChunk) if (lNewChunk != nil)
      break if ((iChildProcess != nil) and (iChildProcess.exited?))
    end

    return rStr
  end

end
