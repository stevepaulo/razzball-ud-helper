class App
  def self.call
    Player.import_from_ud
    Player.add_stats_from_razzball
    Player.generate_output
  end
end
