namespace :misc do
  desc "Dump current food panel"
  task :dumpdata => :environment do
    dd = Dumpdata.new
    dd.dump
  end
end
