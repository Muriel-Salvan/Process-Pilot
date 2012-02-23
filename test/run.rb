#--
# Copyright (c) 2012 Muriel Salvan (muriel@x-aeon.com)
# Licensed under the terms specified in LICENSE file. No warranty is provided.
#++

$ProcessPilotTest_Debug = false

require 'test/unit'
require 'rUtilAnts/Logging'
RUtilAnts::Logging::install_logger_on_object(:debug_mode => $ProcessPilotTest_Debug)
require 'rUtilAnts/Misc'
RUtilAnts::Misc::install_misc_on_object
require 'rUtilAnts/Platform'
RUtilAnts::Platform::install_platform_on_object

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
