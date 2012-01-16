#--
# Copyright (c) 2012 Muriel Salvan (murielsalvan@users.sourceforge.net)
# Licensed under the terms specified in LICENSE file. No warranty is provided.
#++

# Disable STDOUT caching
$stdout.sync = true

# Get the rb file to execute
iRBFileName = ARGV[0]

# Adapt ARGV for this rb file to get its arguments correctly
# TODO: Maybe adapt other variables ...
ARGV.replace(ARGV[1..-1])

load iRBFileName
