module ProcessPilotTest

  module Common

    # Get the OS dependant command line for testing non interactive processes
    #
    # Return::
    # * <em>list<String></em>: Command line
    def getNotInteractiveCmdLine
      rCmdLine = nil

      case os
      when RUtilAnts::Platform::OS_WINDOWS
        rCmdLine = ["#{$ProcessPilotTest_RootPath}/test/Programs/Windows/NotInteractive.bat"]
      when RUtilAnts::Platform::OS_LINUX
        rCmdLine = ["#{$ProcessPilotTest_RootPath}/test/Programs/Bash/NotInteractive.sh"]
      when RUtilAnts::Platform::OS_CYGWIN
        rCmdLine = ["#{$ProcessPilotTest_RootPath}/test/Programs/Bash/NotInteractive.sh"]
      else
        rCmdLine = ["#{$ProcessPilotTest_RootPath}/test/Programs/Bash/NotInteractive.sh"]
      end
      rCmdLine << { :debug => true } if ($ProcessPilotTest_Debug)

      return rCmdLine
    end

    # Get the OS dependant command line for testing non interactive processes on STDERR
    #
    # Return::
    # * <em>list<String></em>: Command line
    def getNotInteractiveCmdLineSTDERR
      rCmdLine = nil

      case os
      when RUtilAnts::Platform::OS_WINDOWS
        rCmdLine = ["#{$ProcessPilotTest_RootPath}/test/Programs/Windows/NotInteractiveSTDERR.bat"]
      when RUtilAnts::Platform::OS_LINUX
        rCmdLine = ["#{$ProcessPilotTest_RootPath}/test/Programs/Bash/NotInteractiveSTDERR.sh"]
      when RUtilAnts::Platform::OS_CYGWIN
        rCmdLine = ["#{$ProcessPilotTest_RootPath}/test/Programs/Bash/NotInteractiveSTDERR.sh"]
      else
        rCmdLine = ["#{$ProcessPilotTest_RootPath}/test/Programs/Bash/NotInteractiveSTDERR.sh"]
      end
      rCmdLine << { :debug => true } if ($ProcessPilotTest_Debug)

      return rCmdLine
    end

    # Get the OS dependant command line for testing interactive processes
    #
    # Return::
    # * <em>list<String></em>: Command line
    def getInteractiveCmdLine
      rCmdLine = nil

      case os
      when RUtilAnts::Platform::OS_WINDOWS
        rCmdLine = ["#{$ProcessPilotTest_RootPath}/test/Programs/Windows/Interactive.bat"]
      when RUtilAnts::Platform::OS_LINUX
        rCmdLine = ["#{$ProcessPilotTest_RootPath}/test/Programs/Bash/Interactive.sh"]
      when RUtilAnts::Platform::OS_CYGWIN
        rCmdLine = ["#{$ProcessPilotTest_RootPath}/test/Programs/Bash/Interactive.sh"]
      else
        rCmdLine = ["#{$ProcessPilotTest_RootPath}/test/Programs/Bash/Interactive.sh"]
      end
      rCmdLine << { :debug => true } if ($ProcessPilotTest_Debug)

      return rCmdLine
    end

    # Get the OS dependant command line for testing interactive processes on STDERR
    #
    # Return::
    # * <em>list<String></em>: Command line
    def getInteractiveCmdLineSTDERR
      rCmdLine = nil

      case os
      when RUtilAnts::Platform::OS_WINDOWS
        rCmdLine = ["#{$ProcessPilotTest_RootPath}/test/Programs/Windows/InteractiveSTDERR.bat"]
      when RUtilAnts::Platform::OS_LINUX
        rCmdLine = ["#{$ProcessPilotTest_RootPath}/test/Programs/Bash/InteractiveSTDERR.sh"]
      when RUtilAnts::Platform::OS_CYGWIN
        rCmdLine = ["#{$ProcessPilotTest_RootPath}/test/Programs/Bash/InteractiveSTDERR.sh"]
      else
        rCmdLine = ["#{$ProcessPilotTest_RootPath}/test/Programs/Bash/InteractiveSTDERR.sh"]
      end
      rCmdLine << { :debug => true } if ($ProcessPilotTest_Debug)

      return rCmdLine
    end

    # Get the OS dependant command line for testing interactive processes with a prompt
    #
    # Return::
    # * <em>list<String></em>: Command line
    def getInteractivePromptCmdLine
      rCmdLine = nil

      case os
      when RUtilAnts::Platform::OS_WINDOWS
        rCmdLine = ["#{$ProcessPilotTest_RootPath}/test/Programs/Windows/InteractivePrompt.bat"]
      when RUtilAnts::Platform::OS_LINUX
        rCmdLine = ["#{$ProcessPilotTest_RootPath}/test/Programs/Bash/InteractivePrompt.sh"]
      when RUtilAnts::Platform::OS_CYGWIN
        rCmdLine = ["#{$ProcessPilotTest_RootPath}/test/Programs/Bash/InteractivePrompt.sh"]
      else
        rCmdLine = ["#{$ProcessPilotTest_RootPath}/test/Programs/Bash/InteractivePrompt.sh"]
      end
      rCmdLine << { :debug => true } if ($ProcessPilotTest_Debug)

      return rCmdLine
    end

    # Get the OS dependant command line for testing interactive processes with a prompt on STDERR
    #
    # Return::
    # * <em>list<String></em>: Command line
    def getInteractivePromptCmdLineSTDERR
      rCmdLine = nil

      case os
      when RUtilAnts::Platform::OS_WINDOWS
        rCmdLine = ["#{$ProcessPilotTest_RootPath}/test/Programs/Windows/InteractivePromptSTDERR.bat"]
      when RUtilAnts::Platform::OS_LINUX
        rCmdLine = ["#{$ProcessPilotTest_RootPath}/test/Programs/Bash/InteractivePromptSTDERR.sh"]
      when RUtilAnts::Platform::OS_CYGWIN
        rCmdLine = ["#{$ProcessPilotTest_RootPath}/test/Programs/Bash/InteractivePromptSTDERR.sh"]
      else
        rCmdLine = ["#{$ProcessPilotTest_RootPath}/test/Programs/Bash/InteractivePromptSTDERR.sh"]
      end
      rCmdLine << { :debug => true } if ($ProcessPilotTest_Debug)

      return rCmdLine
    end

    # Get the OS dependant command line for testing interactive processes with several prompts
    #
    # Return::
    # * <em>list<String></em>: Command line
    def getInteractiveSeveralPrompts
      rCmdLine = nil

      case os
      when RUtilAnts::Platform::OS_WINDOWS
        rCmdLine = ["#{$ProcessPilotTest_RootPath}/test/Programs/Windows/InteractiveSeveralPrompts.bat"]
      when RUtilAnts::Platform::OS_LINUX
        rCmdLine = ["#{$ProcessPilotTest_RootPath}/test/Programs/Bash/InteractiveSeveralPrompts.sh"]
      when RUtilAnts::Platform::OS_CYGWIN
        rCmdLine = ["#{$ProcessPilotTest_RootPath}/test/Programs/Bash/InteractiveSeveralPrompts.sh"]
      else
        rCmdLine = ["#{$ProcessPilotTest_RootPath}/test/Programs/Bash/InteractiveSeveralPrompts.sh"]
      end
      rCmdLine << { :debug => true } if ($ProcessPilotTest_Debug)

      return rCmdLine
    end

    # Get the command line for testing synced Ruby programs
    #
    # Return::
    # * <em>list<String></em>: Command line
    def getSyncedRubyCmdLine
      rCmdLine = ['ruby', "#{$ProcessPilotTest_RootPath}/test/Programs/Ruby/SyncedSTDOUT.rb"]

      rCmdLine << { :debug => true } if ($ProcessPilotTest_Debug)

      return rCmdLine
    end

    # Get the command line for testing normal Ruby programs
    #
    # Return::
    # * <em>list<String></em>: Command line
    def getNormalRubyCmdLine
      rCmdLine = ['ruby', "#{$ProcessPilotTest_RootPath}/test/Programs/Ruby/NormalSTDOUT.rb"]

      rCmdLine << { :debug => true } if ($ProcessPilotTest_Debug)

      return rCmdLine
    end

    # Get the command line for testing normal Ruby programs and forcing them to sync
    #
    # Return::
    # * <em>list<String></em>: Command line
    def getNormalRubyWithSyncCmdLine
      rCmdLine = ["#{$ProcessPilotTest_RootPath}/test/Programs/Ruby/NormalSTDOUT.rb"]

      lOptions = {
        :force_ruby_process_sync => true
      }
      lOptions[:debug] = true if ($ProcessPilotTest_Debug)
      rCmdLine << lOptions

      return rCmdLine
    end

    # Assert a common given scenario.
    # This has been put in such a method as the same scenario is used in different scripts.
    #
    # Parameters::
    # * *oStdIN* (_IO_): STDIN
    # * *iStdOUT* (_IO_): STDOUT
    # * *iStdERR* (_IO_): STDERR
    # * *iChildProcess* (_ChildProcess_): Corresponding ChildProcess
    def assert_testing_scenario(oStdIN, iStdOUT, iStdERR, iChildProcess)
      assert_equal "STDOUT Line 1.\n", iStdOUT.gets(:time_out_secs => 1)
      assert_equal 'Enter string 1 from STDOUT: ', iStdOUT.read(28)
      assert_raise Timeout::Error do
        iStdERR.read(1, :time_out_secs => 1)
      end
      assert_raise Timeout::Error do
        iStdOUT.read(1, :time_out_secs => 1)
      end
      oStdIN.write "Test String 1\n"
      assert_equal "STDOUT Line 2: Test String 1\n", iStdOUT.gets(:time_out_secs => 1)
      assert_equal "STDERR Line 1.\n", iStdERR.gets(:time_out_secs => 1)
      assert_equal 'Enter string 2 from STDERR: ', iStdERR.read(28)
      assert_raise Timeout::Error do
        iStdERR.read(1, :time_out_secs => 1)
      end
      assert_raise Timeout::Error do
        iStdOUT.read(1, :time_out_secs => 1)
      end
      oStdIN.write "Test String 2\n"
      assert_equal "STDOUT Line 3: Test String 2\n", iStdOUT.gets(:time_out_secs => 1)
      assert_equal "STDERR Line 2.\n", iStdERR.gets(:time_out_secs => 1)
      assert_equal nil, iStdOUT.gets(:time_out_secs => 1)
      assert_equal nil, iStdERR.gets(:time_out_secs => 1)
      assert iChildProcess.exited?
    end

  end

end
