class ChangeHitterStats < ActiveRecord::Migration[7.0]
  def change
    remove_column :players, :s, :float
    remove_column :players, :d, :float
    remove_column :players, :t, :float
    remove_column :players, :hbp, :float
    add_column :players, :h, :float
  end
end
