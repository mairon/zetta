class CreateLocalizacaos < ActiveRecord::Migration
  def change
    create_table :localizacaos do |t|
      t.string :ocupacao
      t.string :sigla

      t.timestamps
    end
  end
end
