class CreateProdutoBarras < ActiveRecord::Migration
  def change
    create_table :produto_barras do |t|
      t.integer :produto_id
      t.string :produto_nome
      t.string :barra

      t.timestamps
    end
  end
end
