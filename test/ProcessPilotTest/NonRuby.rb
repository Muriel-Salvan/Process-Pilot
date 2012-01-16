#--
# Copyright (c) 2012 Muriel Salvan (murielsalvan@users.sourceforge.net)
# Licensed under the terms specified in LICENSE file. No warranty is provided.
#++

module ProcessPilotTest

  class NonRuby < ::Test::Unit::TestCase

    include ProcessPilotTest::Common

    def testNotInteractiveSTDOUT
      ProcessPilot::pilot(*getNotInteractiveCmdLine) do |oStdIN, iStdOUT, iStdERR, iChildProcess|
        assert_equal "Hello World\n", iStdOUT.gets_blocking(:TimeOutSecs => 1)
        assert_raise IO::TimeOutError do
          iStdERR.gets_blocking(:TimeOutSecs => 1)
        end
        assert iChildProcess.exited?
        next true
      end
    end

    def testNotInteractiveSTDOUTEndOfProcess
      ProcessPilot::pilot(*getNotInteractiveCmdLine) do |oStdIN, iStdOUT, iStdERR, iChildProcess|
        assert_equal "Hello World\n", iStdOUT.gets_blocking(:TimeOutSecs => 1, :ChildProcess => iChildProcess)
        assert_equal '', iStdOUT.gets_blocking(:TimeOutSecs => 1, :ChildProcess => iChildProcess)
        assert_equal '', iStdERR.gets_blocking(:TimeOutSecs => 1, :ChildProcess => iChildProcess)
        assert iChildProcess.exited?
        next true
      end
    end

    def testNotInteractiveSTDERR
      ProcessPilot::pilot(*getNotInteractiveCmdLineSTDERR) do |oStdIN, iStdOUT, iStdERR, iChildProcess|
        assert_equal '', iStdOUT.gets_blocking(:TimeOutSecs => 1, :ChildProcess => iChildProcess)
        assert_equal "Hello World\n", iStdERR.gets_blocking(:TimeOutSecs => 1, :ChildProcess => iChildProcess)
        assert_equal '', iStdERR.gets_blocking(:TimeOutSecs => 1, :ChildProcess => iChildProcess)
        assert iChildProcess.exited?
        next true
      end
    end

    def testInteractiveSTDOUT
      ProcessPilot::pilot(*getInteractiveCmdLine) do |oStdIN, iStdOUT, iStdERR, iChildProcess|
        assert_equal "Hello World\n", iStdOUT.gets_blocking(:TimeOutSecs => 1, :ChildProcess => iChildProcess)
        assert_raise IO::TimeOutError do
          iStdOUT.gets_blocking(:TimeOutSecs => 1, :ChildProcess => iChildProcess)
        end
        oStdIN.write_flushed "Test String\n"
        assert_equal "Hello Test String\n", iStdOUT.gets_blocking(:TimeOutSecs => 1, :ChildProcess => iChildProcess)
        assert_equal '', iStdOUT.gets_blocking(:TimeOutSecs => 1, :ChildProcess => iChildProcess)
        assert iChildProcess.exited?
        next true
      end
    end

    def testInteractiveSTDERR
      ProcessPilot::pilot(*getInteractiveCmdLineSTDERR) do |oStdIN, iStdOUT, iStdERR, iChildProcess|
        assert_raise IO::TimeOutError do
          iStdOUT.gets_blocking(:TimeOutSecs => 1, :ChildProcess => iChildProcess)
        end
        assert_equal "Hello World\n", iStdERR.gets_blocking(:TimeOutSecs => 1, :ChildProcess => iChildProcess)
        assert_raise IO::TimeOutError do
          iStdERR.gets_blocking(:TimeOutSecs => 1, :ChildProcess => iChildProcess)
        end
        oStdIN.write_flushed "Test String\n"
        assert_equal '', iStdOUT.gets_blocking(:TimeOutSecs => 1, :ChildProcess => iChildProcess)
        assert_equal "Hello Test String\n", iStdERR.gets_blocking(:TimeOutSecs => 1, :ChildProcess => iChildProcess)
        assert_equal '', iStdERR.gets_blocking(:TimeOutSecs => 1, :ChildProcess => iChildProcess)
        assert iChildProcess.exited?
        next true
      end
    end

    def testInteractiveWithPromptSTDOUT
      ProcessPilot::pilot(*getInteractivePromptCmdLine) do |oStdIN, iStdOUT, iStdERR, iChildProcess|
        assert_equal "Hello World\n", iStdOUT.gets_blocking(:TimeOutSecs => 1, :ChildProcess => iChildProcess)
        assert_equal 'Enter string: ', iStdOUT.read_blocking(14, :ChildProcess => iChildProcess)
        assert_raise IO::TimeOutError do
          iStdOUT.gets_blocking(:TimeOutSecs => 1, :ChildProcess => iChildProcess)
        end
        oStdIN.write_flushed "Test String\n"
        assert_equal "Hello Test String\n", iStdOUT.gets_blocking(:TimeOutSecs => 1, :ChildProcess => iChildProcess)
        assert_equal '', iStdOUT.gets_blocking(:TimeOutSecs => 1, :ChildProcess => iChildProcess)
        assert iChildProcess.exited?
        next true
      end
    end

    def testInteractiveWithPromptSTDERR
      ProcessPilot::pilot(*getInteractivePromptCmdLineSTDERR) do |oStdIN, iStdOUT, iStdERR, iChildProcess|
        assert_equal "Hello World\n", iStdERR.gets_blocking(:TimeOutSecs => 1, :ChildProcess => iChildProcess)
        assert_equal 'Enter string: ', iStdERR.read_blocking(14, :ChildProcess => iChildProcess)
        assert_raise IO::TimeOutError do
          iStdERR.gets_blocking(:TimeOutSecs => 1, :ChildProcess => iChildProcess)
        end
        oStdIN.write_flushed "Test String\n"
        assert_equal "Hello Test String\n", iStdERR.gets_blocking(:TimeOutSecs => 1, :ChildProcess => iChildProcess)
        assert_equal '', iStdERR.gets_blocking(:TimeOutSecs => 1, :ChildProcess => iChildProcess)
        assert iChildProcess.exited?
        next true
      end
    end

    def testSeveralPrompts
      ProcessPilot::pilot(*getInteractiveSeveralPrompts) do |oStdIN, iStdOUT, iStdERR, iChildProcess|
        assert_testing_scenario(oStdIN, iStdOUT, iStdERR, iChildProcess)
        next true
      end
    end

  end

end
