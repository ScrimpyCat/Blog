require 'rails_helper'

describe Series do
    before { @series = FactoryGirl.build(:series) }
    subject { @series }

    it { is_expected.to respond_to(:name) }

    it { is_expected.to be_valid }

    describe "name is too long" do
        before { @series.name = "a"*101 }
        it { is_expected.to_not be_valid }
    end

    describe "name is already taken" do
        before {
            series_with_same_name = @series.dup
            series_with_same_name.name = series_with_same_name.name.upcase
            series_with_same_name.save
        }

        it { is_expected.to_not be_valid }
    end

    describe "name is nil" do
        before { @series.name = nil }
        it { is_expected.to_not be_valid }
    end

    describe "name is empty" do
        before { @series.name = "" }
        it { is_expected.to_not be_valid }
    end

    describe "name as link is already taken" do
        before {
            @series.name = 'Will look the same'
            series_with_same_link = @series.dup
            series_with_same_link.name.gsub!(/ /, '-')
            series_with_same_link.save
        }

        it { is_expected.to_not be_valid }
    end
end
