Blog::Application.routes.draw do
    scope :controller => :page do
        get '/about', :to => :view_about, :as => 'blog_about'
    end

    scope :controller => :post do
        get '/category/(:tags)', :to => :view_category, :as => 'blog_category'
        get '/series/(:series)', :to => :view_series, :as => 'blog_series'
        get '/:title', :to => :view_single, :as => 'blog_post'
        get '/', :to => :view_single, :constraints => lambda { |request| request.query_string[/(?<=id=)\d+$/] }, :as => 'blog_post_id'
        get '/', :to => :view_all, :as => 'blog'
    end
end
