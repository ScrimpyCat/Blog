require 'rails_helper'

describe Chapter do
    before { @chapter = FactoryGirl.build(:chapter) }
    subject { @chapter }

    it { is_expected.to respond_to(:post) }
    it { is_expected.to respond_to(:series) }

    it { is_expected.to be_valid }

    describe "is already used" do
        before { @chapter.dup.save }
        it { is_expected.to_not be_valid }
    end

    describe "post is nil" do
        before { @chapter.post = nil }
        it { is_expected.to_not be_valid }
    end

    describe "series is nil" do
        before { @chapter.series = nil }
        it { is_expected.to_not be_valid }
    end
end
