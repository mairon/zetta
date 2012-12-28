class CreateVendasFinancas < ActiveRecord::Migration
  def change
    create_table :vendas_financas do |t|

      t.timestamps
    end
  end
end
