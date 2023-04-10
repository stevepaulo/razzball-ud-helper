class CreatePlayers < ActiveRecord::Migration[7.0]
  def change
    create_table :players do |t|
      t.string :udid
      t.string :name
      t.string :position
      t.string :team
      t.float :w
      t.float :qs
      t.float :k
      t.float :ip
      t.float :er
      t.float :s
      t.float :d
      t.float :t
      t.float :hr
      t.float :bb
      t.float :hbp
      t.float :rbi
      t.float :r
      t.float :sb

      t.timestamps
    end
  end
end
