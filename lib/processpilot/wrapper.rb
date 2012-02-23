#--
# Copyright (c) 2012 Muriel Salvan (muriel@x-aeon.com)
# Licensed under the terms specified in LICENSE file. No warranty is provided.
#++

# Disable STDOUT caching
$stdout.sync = true

# Get the rb file to execute
iRBFileName = ARGV[0]

# Adapt ARGV for this rb file to get its arguments correctly
# Adapt variables modified by the wrapper
# ARGV
ARGV.replace(ARGV[1..-1])
# $0
$__ProcessPilot__RealProgramName = File.expand_path(iRBFileName)
alias $0 $__ProcessPilot__RealProgramName

# Execute the normal program
load iRBFileName
