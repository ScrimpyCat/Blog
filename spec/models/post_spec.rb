require 'rails_helper'


def test_max_length(attribute, length)
    describe "when #{attribute.to_s} is too long" do
        before { @post.send((attribute.to_s << '=').to_sym, "a"*(length+1)) }
        it { is_expected.to_not be_valid }
    end
end

describe Post do
    before { @post = FactoryGirl.build(:tagged_post) }
    subject { @post }

    it { is_expected.to respond_to(:author) }
    it { is_expected.to respond_to(:date) }
    it { is_expected.to respond_to(:title) }
    it { is_expected.to respond_to(:content) }
    it { is_expected.to respond_to(:categories) }

    it { is_expected.to be_valid }

    test_max_length(:author, 50)
    test_max_length(:title, 250)

    describe "content has no limit" do
        before { @post.content = "a"*10000 }
        it { is_expected.to be_valid }
    end

    describe "title is already taken" do
        before {
            post_with_same_title = @post.dup
            post_with_same_title.title = post_with_same_title.title.upcase
            post_with_same_title.save
        }

        it { is_expected.to_not be_valid }
    end

    describe "title is nil" do
        before { @post.title = nil }
        it { is_expected.to be_valid }
    end

    describe "title is empty" do
        before { @post.title = "" }
        it { is_expected.to be_valid }
    end

    describe "title is empty for two posts" do
        before {
            post_with_same_title = @post.dup
            post_with_same_title.title = ""
            post_with_same_title.save

            @post.title = ""
        }

        it { is_expected.to be_valid }
    end

    describe "not using tags" do
        before { @post = FactoryGirl.build(:post) }
        it { is_expected.to be_valid }
    end

    describe "not apart of a series" do
        before { @post = FactoryGirl.build(:post) }
        it { is_expected.to be_valid }
    end

    %w[category series].each { |reserved|
        describe "title is reserved name '#{reserved}'" do
            before { @post.title = reserved }
            it { is_expected.to_not be_valid }
        end
    }

    describe "title as link is already taken" do
        before {
            @post.title = 'Will look the same'
            post_with_same_link = @post.dup
            post_with_same_link.title.gsub!(/ /, '-')
            post_with_same_link.save
        }

        it { is_expected.to_not be_valid }
    end

    describe "destroying hanging category and series references" do
        before {
            @post.save
            @post.destroy
        }

        specify { expect(Category.where(:name => FactoryGirl.attributes_for(:category)[:name]).first).to be_nil }
        specify { expect(Series.where(:name => FactoryGirl.attributes_for(:series)[:name]).first).to be_nil }
    end

    describe "destroying active category and series references" do
        before {
            active = Post.create
            active.categories = @post.categories
            active.series = @post.series
            active.save

            @post.save
            @post.destroy
        }

        specify { expect(Category.where(:name => FactoryGirl.attributes_for(:category)[:name]).first).to_not be_nil }
        specify { expect(Series.where(:name => FactoryGirl.attributes_for(:series)[:name]).first).to_not be_nil }
    end
end
