class AddMaqToRodado < ActiveRecord::Migration
  def change
    add_column :rodados, :capacidade, :decimal, :scale => 4, :precision => 15, :default => 0
    add_column :rodados, :mq, :integer
  end
end
