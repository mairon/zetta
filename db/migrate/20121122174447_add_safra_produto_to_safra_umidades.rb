class AddSafraProdutoToSafraUmidades < ActiveRecord::Migration
  def change
    add_column :safra_umidades, :safra_produto_id, :integer
  end
end
