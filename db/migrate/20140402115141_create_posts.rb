class CreatePosts < ActiveRecord::Migration
    def change
        create_table :posts do |t|
            t.string :author, :limit => 50
            t.datetime :date
            t.string :title, :limit => 250
            t.text :content

            t.timestamps
        end
    end
end
