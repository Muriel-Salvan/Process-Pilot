#--
# Copyright (c) 2009 - 2012 Muriel Salvan (murielsalvan@users.sourceforge.net)
# Licensed under the terms specified in LICENSE file. No warranty is provided.
#++

RubyPackager::ReleaseInfo.new.
  author(
    :Name => 'Muriel Salvan',
    :EMail => 'muriel@x-aeon.com',
    :WebPageURL => 'http://murielsalvan.users.sourceforge.net'
  ).
  project(
    :Name => 'Process Pilot',
    :WebPageURL => 'http://processpilot.sourceforge.net/',
    :Summary => 'Ruby library to pilot interactive command line processes in real time.',
    :Description => 'Ruby library giving a simple way to pilot an external process\' stdin, stdout and stderr in real time. Very useful for interactive processes testing or automation.',
    :ImageURL => 'http://processpilot.sourceforge.net/wiki/images/c/c9/Logo.png',
    :FaviconURL => 'http://processpilot.sourceforge.net/wiki/images/2/26/Favicon.png',
    :SVNBrowseURL => 'http://processpilot.git.sourceforge.net/',
    :DevStatus => 'Beta'
  ).
  addCoreFiles( [
    'lib/**/*'
  ] ).
  addTestFiles( [
    'test/**/*'
  ] ).
  addAdditionalFiles( [
    'README',
    'LICENSE',
    'AUTHORS',
    'Credits',
    'ChangeLog'
  ] ).
  gem(
    :GemName => 'ProcessPilot',
    :GemPlatformClassName => 'Gem::Platform::RUBY',
    :RequirePath => 'lib',
    :HasRDoc => true,
    :TestFile => 'test/run.rb',
    :GemDependencies => [
      [ 'rUtilAnts', '>= 0.3' ],
      [ 'childprocess', '>= 0.2.3' ]
    ]
  ).
  sourceForge(
    :Login => 'murielsalvan',
    :ProjectUnixName => 'processpilot'
  ).
  rubyForge(
    :ProjectUnixName => 'processpilot'
  )
