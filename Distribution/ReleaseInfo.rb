RubyPackager::ReleaseInfo.new.
  author(
    :name => 'Muriel Salvan',
    :email => 'muriel@x-aeon.com',
    :web_page_url => 'http://murielsalvan.users.sourceforge.net'
  ).
  project(
    :name => 'Process Pilot',
    :web_page_url => 'http://processpilot.sourceforge.net/',
    :summary => 'Ruby library to pilot interactive command line processes in real time.',
    :description => 'Ruby library giving a simple way to pilot an external process\' stdin, stdout and stderr in real time. Very useful for interactive processes testing or automation.',
    :image_url => 'http://processpilot.sourceforge.net/wiki/images/c/c9/Logo.png',
    :favicon_url => 'http://processpilot.sourceforge.net/wiki/images/2/26/Favicon.png',
    :browse_source_url => 'http://processpilot.git.sourceforge.net/',
    :dev_status => 'Beta'
  ).
  add_core_files( [
    'lib/**/*'
  ] ).
  add_test_files( [
    'test/**/*'
  ] ).
  add_additional_files( [
    'README',
    'LICENSE',
    'AUTHORS',
    'Credits',
    'ChangeLog'
  ] ).
  gem(
    :gem_name => 'ProcessPilot',
    :gem_platform_class_name => 'Gem::Platform::RUBY',
    :require_path => 'lib',
    :has_rdoc => true,
    :test_file => 'test/run.rb',
    :gem_dependencies => [
      [ 'rUtilAnts', '>= 1.0' ]
    ]
  ).
  source_forge(
    :login => 'murielsalvan',
    :project_unix_name => 'processpilot',
    :ask_for_key_passphrase => true
  ).
  ruby_forge(
    :project_unix_name => 'processpilot'
  )
