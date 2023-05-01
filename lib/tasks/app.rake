desc "Run the application"
task run: :environment do
  App.call
end
