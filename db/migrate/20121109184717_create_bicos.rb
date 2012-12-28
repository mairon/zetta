class CreateBicos < ActiveRecord::Migration
  def change
    create_table :bicos do |t|
      t.string :nome, :limit => 25
      t.decimal :vazao
      t.string :codigo_tec, :limit => 15

      t.timestamps
    end
  end
end
