class CreateTags < ActiveRecord::Migration
    def change
        create_table :tags do |t|
            t.references :post, :index => true, :null => false
            t.references :category, :index => true, :null => false

            t.timestamps
        end

        add_index :tags, [:post_id, :category_id], :unique => true
    end
end
