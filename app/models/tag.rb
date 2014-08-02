class Tag < ActiveRecord::Base
    belongs_to :post
    belongs_to :category

    validates :post, :uniqueness => { :scope => :category }
    validates :category, :presence => true
    # validates :post, :presence => true #can't have it as it messes up untagged posts

    after_update :destroy_references
    after_destroy :destroy_references
    def destroy_references
        if category.posts.count == 0 #after_destroy
            category.destroy
        elsif changes['category_id'] #after_update
            prev_category = Category.find(changes['category_id'][0])
            prev_category.destroy if prev_category.posts.count == 0
        end
    end
end
