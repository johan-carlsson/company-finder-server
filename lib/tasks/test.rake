namespace :test do

  desc "Test services source"
  Rake::TestTask.new(:services) do |t|    
    t.libs << "test"
    t.pattern = 'test/services/**/*_test.rb'
    t.verbose = true    
  end

end

Rake::Task[:test].enhance { Rake::Task["test:services"].invoke }
