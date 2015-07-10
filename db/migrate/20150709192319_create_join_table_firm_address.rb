class CreateJoinTableFirmAddress < ActiveRecord::Migration
  def change
    create_join_table :firms, :addresses, id: false do |t|
      t.index [:firm_id, :address_id]
      t.index [:address_id, :firm_id]
    end
  end
end
