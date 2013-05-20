require 'rake/testtask'

task :default => [:test]

Rake::TestTask.new do |t|
  t.libs << "./"
  t.pattern = '*_spec.rb'
end
