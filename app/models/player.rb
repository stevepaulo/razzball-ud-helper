require "csv"
require "i18n"

class Player < ApplicationRecord
  TEAM_MAP = {
    "Arizona Diamondbacks" => "ARI",
    "Atlanta Braves" => "ATL",
    "Baltimore Orioles" => "BAL",
    "Boston Red Sox" => "BOS",
    "Chicago Cubs" => "CHC",
    "Chicago White Sox" => "CHW",
    "Cincinnati Reds" => "CIN",
    "Cleveland Guardians" => "CLE",
    "Colorado Rockies" => "COL",
    "Detroit Tigers" => "DET",
    "Houston Astros" => "HOU",
    "Kansas City Royals" => "KC",
    "Los Angeles Angels" => "LAA",
    "Los Angeles Dodgers" => "LAD",
    "Miami Marlins" => "MIA",
    "Milwaukee Brewers" => "MIL",
    "Minnesota Twins" => "MIN",
    "New York Mets" => "NYM",
    "New York Yankees" => "NYY",
    "Oakland Athletics" => "OAK",
    "Philadelphia Phillies" => "PHI",
    "Pittsburgh Pirates" => "PIT",
    "San Diego Padres" => "SD",
    "San Francisco Giants" => "SF",
    "Seattle Mariners" => "SEA",
    "St. Louis Cardinals" => "STL",
    "Tampa Bay Rays" => "TB",
    "Texas Rangers" => "TEX",
    "Toronto Blue Jays" => "TOR",
    "Washington Nationals" => "WSH"
  }

  SCORING_MAP = {
    w: 2.0,
    qs: 3.0,
    k: 1.0,
    ip: 1.0,
    er: -1.0,
    h: 3.75,
    hr: 10.0,
    bb: 3.0,
    rbi: 2.0,
    r: 2.0,
    sb: 4.0
  }

  def self.import_from_ud
    Player.destroy_all

    CSV.foreach("data/underdog.csv", headers: true) do |row|
      Player.create(
        udid: row["id"],
        name: I18n.transliterate("#{row['firstName']} #{row['lastName']}"),
        team: TEAM_MAP[row["teamName"]],
        position: row["slotName"]
      )
    end
  end

  def self.add_stats_from_razzball
    CSV.foreach("data/hitters.csv", headers: true) do |row|
      p = Player.find_by(name: I18n.transliterate(row["Name"]), team: row["Team"])
      if p.nil?
        puts "Couldn't find #{row["Name"]} (#{row["Team"]})"
        next
      end

      p.update(
        h: row["H"],
        hr: row["HR"],
        bb: row["BB"],
        rbi: row["RBI"],
        r: row["R"],
        sb: row["SB"],
        w: 0.0,
        qs: 0.0,
        k: 0.0,
        ip: 0.0,
        er: 0.0
      )
    end

    CSV.foreach("data/pitchers.csv", headers: true) do |row|
      next if row["Name"] == "Shohei Ohtani"

      p = Player.find_by(name: I18n.transliterate(row["Name"]), team: row["Team"])
      if p.nil?
        puts "Couldn't find #{row["Name"]} (#{row["Team"]})"
        next
      end

      p.update(
        h: 0.0,
        hr: 0.0,
        bb: 0.0,
        rbi: 0.0,
        r: 0.0,
        sb: 0.0,
        w: row["W"],
        qs: row["QS"],
        k: row["K"],
        ip: row["IP"],
        er: row["ER"]
      )
    end
  end

  def self.generate_output
    players = Player.all.sort_by(&:points).reverse

    CSV.open("output/rankings.csv", 'w', write_headers: true, headers: ["id"]) do |writer|
      players.each do |p|
        writer << [p.udid]
      end
    end
    true
  end

  def points
    return 0.0 if self.w.nil?

    (self.w * SCORING_MAP[:w]) + (self.qs * SCORING_MAP[:qs]) + (self.k * SCORING_MAP[:k]) + (self.ip * SCORING_MAP[:ip]) + (self.er * SCORING_MAP[:er]) + (self.h * SCORING_MAP[:h]) + (self.hr * SCORING_MAP[:hr]) + (self.bb * SCORING_MAP[:bb]) + (self.rbi * SCORING_MAP[:rbi]) + (self.r * SCORING_MAP[:r]) + (self.sb * SCORING_MAP[:sb]) || 0.0
  rescue
    byebug
  end
end
