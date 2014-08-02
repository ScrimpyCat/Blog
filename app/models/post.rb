class Post < ActiveRecord::Base
    validates :author, :length => { :maximum => 50 }
    validates :title, :length => { :maximum => 250 }, :allow_nil => true, :allow_blank => true, :uniqueness => { :case_sensitive => false }, :unique_link => true, :exclusion => { :in => %w[category series] }

    has_many :tags
    has_many :categories, :through => :tags, :dependent => :destroy

    has_one :chapter, :dependent => :destroy
    has_one :series, :through => :chapter

    def self.hash_from_info(info = {})
        post = {}

        if info['series']
            post[:series] = Series.where("replace(lower(name), ' ', '-') = :series", { :series => info['series'].to_s.downcase.gsub(/ /, '-') }).first || Series.create!({ :name => info['series'].to_s })
        else
            post[:series] = nil
        end

        if info['tags']
            if info['tags'].kind_of? Array
                post[:categories] = info['tags'].map { |t| Category.where("replace(lower(name), ' ', '-') = :tag", { :tag => t.to_s.downcase.gsub(/ /, '-') }).first || Category.create!({ :name => t.to_s }) }
            else
                post[:categories] = [Category.where("replace(lower(name), ' ', '-') = :tag", { :tag => info['tags'].to_s.downcase.gsub(/ /, '-') }).first || Category.create!({ :name => info['tags'].to_s })]
            end
        else
            post[:categories] = []
        end

        post[:title] = info['title'] ? info['title'].to_s : nil
        post[:author] = info['author'] ? info['author'].to_s : nil
        post[:date] = info['date']
        post[:content] = info['content'].to_s

        post
    end

    def self.create_with_info(info = {})
        create(hash_from_info(info))
    rescue ActiveRecord::RecordInvalid, ActiveRecord::UnknownAttributeError
        nil
    end

    def self.create_with_info!(info = {})
        create!(hash_from_info(info))
    end

    def update_with_info(info = {})
        post = self.class.hash_from_info(info)
        update(post)
    rescue ActiveRecord::RecordInvalid, ActiveRecord::UnknownAttributeError
        false
    end

    def update_with_info!(info = {})
        post = self.class.hash_from_info(info)
        update!(post)
    end

    def content_html
        file = Blog::Application.assets.find_asset(content)
        file ? file.source.html_safe : nil
    end
end
