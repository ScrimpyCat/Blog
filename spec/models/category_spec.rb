require 'rails_helper'

describe Category do
    before { @category = FactoryGirl.build(:category) }
    subject { @category }

    it { is_expected.to respond_to(:name) }

    it { is_expected.to be_valid }

    describe "name is too long" do
        before { @category.name = "a"*51 }
        it { is_expected.to_not be_valid }
    end

    describe "name is already taken" do
        before {
            category_with_same_name = @category.dup
            category_with_same_name.name = category_with_same_name.name.upcase
            category_with_same_name.save
        }

        it { is_expected.to_not be_valid }
    end

    describe "name is nil" do
        before { @category.name = nil }
        it { is_expected.to_not be_valid }
    end

    describe "name is empty" do
        before { @category.name = "" }
        it { is_expected.to_not be_valid }
    end

    describe "name as link is already taken" do
        before {
            @category.name = 'Will look the same'
            category_with_same_link = @category.dup
            category_with_same_link.name.gsub!(/ /, '-')
            category_with_same_link.save
        }

        it { is_expected.to_not be_valid }
    end

    describe "name containing a '+'" do
        before { @category.name = 'this+that' }

        it { is_expected.to_not be_valid }
    end
end
