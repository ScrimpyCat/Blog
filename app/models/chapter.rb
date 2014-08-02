class Chapter < ActiveRecord::Base
    belongs_to :post
    belongs_to :series

    validates :post, :presence => true, :uniqueness => true
    validates :series, :presence => true

    after_update :destroy_references
    after_destroy :destroy_references
    def destroy_references
        if series.posts.count == 0 #after_destroy
            series.destroy
        elsif changes['series_id'] #after_update
            prev_series = Series.find(changes['series_id'][0])
            prev_series.destroy if prev_series.posts.count == 0
        end
    end
end
