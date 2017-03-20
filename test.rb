#!/usr/bin/env ruby
system "bundle exec ruby issue.rb 2>&1 | grep 'Nothing registered with the key'"
puts $?.success? ? 'Issue present' : 'Issue fixed'
