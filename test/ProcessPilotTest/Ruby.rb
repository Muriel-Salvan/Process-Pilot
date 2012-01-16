#--
# Copyright (c) 2012 Muriel Salvan (murielsalvan@users.sourceforge.net)
# Licensed under the terms specified in LICENSE file. No warranty is provided.
#++

module ProcessPilotTest

  class Ruby < ::Test::Unit::TestCase

    include ProcessPilotTest::Common

    def testSyncedSTDOUT
      ProcessPilot::pilot(*getSyncedRubyCmdLine) do |oStdIN, iStdOUT, iStdERR, iChildProcess|
        assert_testing_scenario(oStdIN, iStdOUT, iStdERR, iChildProcess)
        next true
      end
    end

    def testNormalSTDOUT
      ProcessPilot::pilot(*getNormalRubyCmdLine) do |oStdIN, iStdOUT, iStdERR, iChildProcess|
        assert_raise IO::TimeOutError do
          iStdOUT.read_blocking(1, :TimeOutSecs => 1, :ChildProcess => iChildProcess)
        end
        iChildProcess.stop
        next true
      end
    end

    def testNormalSTDOUTWithForceSync
      ProcessPilot::pilot(*getNormalRubyWithSyncCmdLine) do |oStdIN, iStdOUT, iStdERR, iChildProcess|
        assert_testing_scenario(oStdIN, iStdOUT, iStdERR, iChildProcess)
        next true
      end
    end

  end

end
