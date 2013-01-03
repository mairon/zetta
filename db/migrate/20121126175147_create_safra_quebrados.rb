class CreateSafraQuebrados < ActiveRecord::Migration
  def change
    create_table :safra_quebrados do |t|
      t.integer :safra_produto_id
      t.integer :safra_id
      t.integer :produto_id
      t.decimal :informado, :decimal, :scale => 2, :precision => 15, :default => 0
      t.decimal :desconto, :decimal, :scale => 2, :precision => 15, :default => 0

      t.timestamps
    end
  end
end
