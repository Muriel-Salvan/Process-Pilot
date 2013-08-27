module ProcessPilotTest

  module Scenario

    # Execute the testing scenario
    def self.run
      $stdout.puts 'STDOUT Line 1.'
      $stdout.write 'Enter string 1 from STDOUT: '
      lVar = $stdin.gets
      $stdout.puts "STDOUT Line 2: #{lVar}"
      $stderr.puts 'STDERR Line 1.'
      $stderr.write 'Enter string 2 from STDERR: '
      lVar = $stdin.gets
      $stdout.puts "STDOUT Line 3: #{lVar}"
      $stderr.puts 'STDERR Line 2.'
    end

  end

end
