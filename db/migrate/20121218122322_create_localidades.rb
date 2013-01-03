class CreateLocalidades < ActiveRecord::Migration
  def change
    create_table :localidades do |t|
      t.string :codigo, :limit => 50
      t.string :ocupacao, :limit => 120
      t.integer :status

      t.timestamps
    end
  end
end
