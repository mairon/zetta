class AddVendaToContas < ActiveRecord::Migration
  def change
    add_column :contas, :venda, :smallint
  end
end
