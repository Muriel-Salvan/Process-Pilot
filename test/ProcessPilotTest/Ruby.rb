module ProcessPilotTest

  class Ruby < ::Test::Unit::TestCase

    include ProcessPilotTest::Common

    def testSyncedSTDOUT
      ProcessPilot::pilot(*getSyncedRubyCmdLine) do |oStdIN, iStdOUT, iStdERR, iChildProcess|
        assert_testing_scenario(oStdIN, iStdOUT, iStdERR, iChildProcess)
      end
    end

    def testNormalSTDOUT
      ProcessPilot::pilot(*getNormalRubyCmdLine) do |oStdIN, iStdOUT, iStdERR, iChildProcess|
        assert_raise Timeout::Error do
          iStdOUT.read(1, :time_out_secs => 1)
        end
        iChildProcess.stop
      end
    end

    def testNormalSTDOUTWithForceSync
      ProcessPilot::pilot(*getNormalRubyWithSyncCmdLine) do |oStdIN, iStdOUT, iStdERR, iChildProcess|
        assert_testing_scenario(oStdIN, iStdOUT, iStdERR, iChildProcess)
      end
    end

  end

end
