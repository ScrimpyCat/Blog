class AddLinkToPosts < ActiveRecord::Migration
    def change
        add_column :posts, :link, :string, :limit => 250

        Post.all.each do |post|
            post.update_attribute(:link, post.title.linkify)
        end
    end
end
