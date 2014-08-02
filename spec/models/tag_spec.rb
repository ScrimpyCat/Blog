require 'rails_helper'

describe Tag do
    before { @tag = FactoryGirl.build(:tags) }
    subject { @tag }

    it { is_expected.to respond_to(:post) }
    it { is_expected.to respond_to(:category) }

    it { is_expected.to be_valid }

    describe "is already used" do
        before { @tag.dup.save }
        it { is_expected.to_not be_valid }
    end

    # describe "post is nil" do
    #     before { @tag.post = nil }
    #     it { is_expected.to_not be_valid }
    # end

    describe "category is nil" do
        before { @tag.category = nil }
        it { is_expected.to_not be_valid }
    end
end
