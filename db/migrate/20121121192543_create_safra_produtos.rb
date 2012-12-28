class CreateSafraProdutos < ActiveRecord::Migration
  def change
    create_table :safra_produtos do |t|
      t.integer :safra_id
      t.integer :produto_id
      t.string :produto_nome

      t.timestamps
    end
  end
end
