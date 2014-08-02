class Series < ActiveRecord::Base
    validates :name, :presence => true, :length => { :maximum => 100 }, :uniqueness => { :case_sensitive => false }, :unique_link => true

    has_many :chapters
    has_many :posts, :through => :chapters, :dependent => :destroy
end
