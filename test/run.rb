#--
# Copyright (c) 2012 Muriel Salvan (murielsalvan@users.sourceforge.net)
# Licensed under the terms specified in LICENSE file. No warranty is provided.
#++

$ProcessPilotTest_Debug = true

require 'test/unit'
require 'rUtilAnts/Logging'
RUtilAnts::Logging::initializeLogging('', '')
activateLogDebug($ProcessPilotTest_Debug)
require 'rUtilAnts/Misc'
RUtilAnts::Misc::initializeMisc
require 'rUtilAnts/Platform'
RUtilAnts::Platform::initializePlatform

$ProcessPilotTest_RootPath = File.expand_path("#{File.dirname(__FILE__)}/..")

# Add the test directory to the current load path
$: << "#{$ProcessPilotTest_RootPath}/test"
# And the lib one too
$: << "#{$ProcessPilotTest_RootPath}/lib"

# Require the main library
require 'processpilot/processpilot'

# Load test files to execute
require 'ProcessPilotTest/Common'
require 'ProcessPilotTest/NonRuby'
require 'ProcessPilotTest/Ruby'
