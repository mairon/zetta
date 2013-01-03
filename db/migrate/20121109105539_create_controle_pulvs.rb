class CreateControlePulvs < ActiveRecord::Migration
  def change
    create_table :controle_pulvs do |t|
      t.date :data
      t.integer :persona_id
      t.string :persona_name, :limit => 150
      t.decimal :area, :scale => 3, :precision => 15, :default => 0
      t.string :direcao, :limit => 120

      t.timestamps
    end
  end
end
