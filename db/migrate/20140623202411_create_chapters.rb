class CreateChapters < ActiveRecord::Migration
    def change
        create_table :chapters do |t|
            t.references :post, :index => false, :null => false
            t.index :post_id, :unique => true
            t.references :series, :index => true, :null => false

            t.timestamps
        end
    end
end
