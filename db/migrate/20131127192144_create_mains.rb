class CreateMains < ActiveRecord::Migration
  def change
    create_table :mains do |t|
      t.string :index

      t.timestamps
    end
  end
end
