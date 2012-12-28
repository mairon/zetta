class CreateSafras < ActiveRecord::Migration
  def change
    create_table :safras do |t|
      t.string :descricao, :limit => 50
      t.date :inicio
      t.date :final

      t.timestamps
    end
  end
end
