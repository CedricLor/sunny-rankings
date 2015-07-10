class CreateJoinTableProfileAddress < ActiveRecord::Migration
  def change
    create_join_table :profiles, :addresses, id: false do |t|
      t.index [:profile_id, :address_id]
      t.index [:address_id, :profile_id]
    end
  end
end
