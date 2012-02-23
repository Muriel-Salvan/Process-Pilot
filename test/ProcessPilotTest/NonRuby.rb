#--
# Copyright (c) 2012 Muriel Salvan (muriel@x-aeon.com)
# Licensed under the terms specified in LICENSE file. No warranty is provided.
#++

module ProcessPilotTest

  class NonRuby < ::Test::Unit::TestCase

    include ProcessPilotTest::Common

    def testNotInteractiveSTDOUT
      ProcessPilot::pilot(*getNotInteractiveCmdLine) do |oStdIN, iStdOUT, iStdERR, iChildProcess|
        assert_equal "Hello World\n", iStdOUT.gets(:time_out_secs => 1)
        assert_nil iStdERR.gets
        assert iChildProcess.exited?
      end
    end

    def testNotInteractiveSTDOUTEndOfProcess
      ProcessPilot::pilot(*getNotInteractiveCmdLine) do |oStdIN, iStdOUT, iStdERR, iChildProcess|
        assert_equal "Hello World\n", iStdOUT.gets(:time_out_secs => 1)
        assert_equal nil, iStdOUT.gets(:time_out_secs => 1)
        assert_equal nil, iStdERR.gets(:time_out_secs => 1)
        assert iChildProcess.exited?
      end
    end

    def testNotInteractiveSTDERR
      ProcessPilot::pilot(*getNotInteractiveCmdLineSTDERR) do |oStdIN, iStdOUT, iStdERR, iChildProcess|
        assert_equal nil, iStdOUT.gets(:time_out_secs => 1)
        assert_equal "Hello World\n", iStdERR.gets(:time_out_secs => 1)
        assert_equal nil, iStdERR.gets(:time_out_secs => 1)
        assert iChildProcess.exited?
      end
    end

    def testInteractiveSTDOUT
      ProcessPilot::pilot(*getInteractiveCmdLine) do |oStdIN, iStdOUT, iStdERR, iChildProcess|
        assert_equal "Hello World\n", iStdOUT.gets(:time_out_secs => 1)
        assert_raise Timeout::Error do
          iStdOUT.gets(:time_out_secs => 1)
        end
        oStdIN.write "Test String\n"
        assert_equal "Hello Test String\n", iStdOUT.gets(:time_out_secs => 1)
        assert_equal nil, iStdOUT.gets(:time_out_secs => 1)
        assert iChildProcess.exited?
      end
    end

    def testInteractiveSTDERR
      ProcessPilot::pilot(*getInteractiveCmdLineSTDERR) do |oStdIN, iStdOUT, iStdERR, iChildProcess|
        assert_raise Timeout::Error do
          iStdOUT.gets(:time_out_secs => 1)
        end
        assert_equal "Hello World\n", iStdERR.gets(:time_out_secs => 1)
        assert_raise Timeout::Error do
          iStdERR.gets(:time_out_secs => 1)
        end
        oStdIN.write "Test String\n"
        assert_equal nil, iStdOUT.gets(:time_out_secs => 1)
        assert_equal "Hello Test String\n", iStdERR.gets(:time_out_secs => 1)
        assert_equal nil, iStdERR.gets(:time_out_secs => 1)
        assert iChildProcess.exited?
      end
    end

    def testInteractiveWithPromptSTDOUT
      ProcessPilot::pilot(*getInteractivePromptCmdLine) do |oStdIN, iStdOUT, iStdERR, iChildProcess|
        assert_equal "Hello World\n", iStdOUT.gets(:time_out_secs => 1)
        assert_equal 'Enter string: ', iStdOUT.read(14)
        assert_raise Timeout::Error do
          iStdOUT.gets(:time_out_secs => 1)
        end
        oStdIN.write "Test String\n"
        assert_equal "Hello Test String\n", iStdOUT.gets(:time_out_secs => 1)
        assert_equal nil, iStdOUT.gets(:time_out_secs => 1)
        assert iChildProcess.exited?
      end
    end

    def testInteractiveWithPromptSTDERR
      ProcessPilot::pilot(*getInteractivePromptCmdLineSTDERR) do |oStdIN, iStdOUT, iStdERR, iChildProcess|
        assert_equal "Hello World\n", iStdERR.gets(:time_out_secs => 1)
        assert_equal 'Enter string: ', iStdERR.read(14)
        assert_raise Timeout::Error do
          iStdERR.gets(:time_out_secs => 1)
        end
        oStdIN.write "Test String\n"
        assert_equal "Hello Test String\n", iStdERR.gets(:time_out_secs => 1)
        assert_equal nil, iStdERR.gets(:time_out_secs => 1)
        assert iChildProcess.exited?
      end
    end

    def testSeveralPrompts
      ProcessPilot::pilot(*getInteractiveSeveralPrompts) do |oStdIN, iStdOUT, iStdERR, iChildProcess|
        assert_testing_scenario(oStdIN, iStdOUT, iStdERR, iChildProcess)
      end
    end

  end

end
