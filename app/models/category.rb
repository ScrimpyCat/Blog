class Category < ActiveRecord::Base
    validates :name, :presence => true, :length => { :maximum => 50 }, :uniqueness => { :case_sensitive => false }, :unique_link => true, :format => { :with => /\A[^+]*\z/ }

    has_many :tags
    has_many :posts, :through => :tags, :dependent => :destroy
end
