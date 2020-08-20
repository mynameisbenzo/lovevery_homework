require 'rails_helper'

RSpec.describe Child, type: :model do
    context "#find_or_create_with_params" do
        let(:child_params) do
            {
                full_name: "Test test",
                parent_name: "Test test test",
                birthdate: "2020-01-01"
            }
        end

        it "creates a child (Non-gifted workflow)" do
            child = Child.find_or_create_with_params(child_params, false)
            expect(child.id).to be_present
        end

        describe "Gifting" do
            it "returns a non-persisted order" do
                child = Child.find_or_create_with_params(child_params, true)
                expect(child.id).to_not be_present
            end
            it "returns an existing order" do
                Child.create(child_params)
                child = Child.find_or_create_with_params(child_params, true)
                expect(child.id).to be_present
            end
        end
    end
end
