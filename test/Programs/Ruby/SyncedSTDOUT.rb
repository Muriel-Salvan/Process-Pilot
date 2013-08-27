$stdout.sync = true

require "#{File.dirname(__FILE__)}/Scenario.rb"

ProcessPilotTest::Scenario::run
