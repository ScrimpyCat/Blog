class PostController < ApplicationController
    BATCH_MAX = 10

    def view_single
        if params[:title] != nil
            @post = Post.where("replace(lower(title), ' ', '-') = :title", { :title => params[:title].downcase.gsub(/ /, '-') }).first
        else
            @post = Post.find_by(:id => params[:id])
        end

        redirect_to('/404.html') if @post == nil
    end

    def view_category
        @categories = Category.order(:name => :asc)

        if params[:tags] != nil
            if params[:last_post_id] != nil
                respond_to do |format|
                    posts = Post.order(:date => :desc).where('posts.date < :last_post_id', { :last_post_id => Time.at(params[:last_post_id][5..-1].to_f / 1000).to_datetime }).joins(:categories).where("replace(lower(categories.name), ' ', '-') IN (:tags)", { :tags => params[:tags].downcase.gsub(/ /, '-').split('+') }).uniq.limit(BATCH_MAX)

                    html = render_to_string(:partial => 'post/posts', :locals => { :posts => posts })
                    format.json { render :json => { :finished => (posts.count == 0 or posts.last == Post.order(:date => :asc).joins(:categories).where("replace(lower(categories.name), ' ', '-') IN (:tags)", { :tags => params[:tags].downcase.gsub(/ /, '-').split('+') }).uniq.first), :posts => html } }
                end
            else
                @posts = Post.order(:date => :desc).joins(:categories).where("replace(lower(categories.name), ' ', '-') IN (:tags)", { :tags => params[:tags].downcase.gsub(/ /, '-').split('+') }).uniq.limit(BATCH_MAX)
            end
        else
            @posts = []
        end
    end

    def view_series
        if params[:series] != nil
            series_name = params[:series].downcase.gsub(/ /, '-')
            @series = Series.where("replace(lower(series.name), ' ', '-') = :series", { :series => series_name }).first.name

            if params[:last_post_id] != nil
                respond_to do |format|
                    posts = Post.order(:date => :desc).where('posts.date < :last_post_id', { :last_post_id => Time.at_timestamp(params[:last_post_id][5..-1]).to_datetime }).joins(:series).where("replace(lower(series.name), ' ', '-') = :series", { :series => series_name }).uniq.limit(BATCH_MAX)

                    html = render_to_string(:partial => 'post/posts', :locals => { :posts => posts })
                    format.json { render :json => { :finished => (posts.count == 0 or posts.last == Post.order(:date => :asc).joins(:series).where("replace(lower(series.name), ' ', '-') = :series", { :series => series_name }).uniq.first), :posts => html } }
                end
            else
                @posts = Post.order(:date => :desc).joins(:series).where("replace(lower(series.name), ' ', '-') = :series", { :series => series_name }).uniq.limit(BATCH_MAX)
            end
        else
            @series = Series.order(:name => :asc)
            @posts = []
        end
    end

    def view_all
        if params[:last_post_id] != nil
            respond_to do |format|
                posts = Post.order(:date => :desc).where('date < :last_post_id', { :last_post_id => Time.at_timestamp(params[:last_post_id][5..-1]).to_datetime }).limit(BATCH_MAX)

                html = render_to_string(:partial => 'post/posts', :locals => { :posts => posts })
                format.json { render :json => { :finished => (posts.count == 0 or posts.last == Post.order(:date => :asc).first), :posts => html } }
            end
        else
            @posts = Post.order(:date => :desc).limit(BATCH_MAX)
        end
    end
end
