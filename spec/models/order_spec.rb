require 'rails_helper'

RSpec.describe Order, type: :model do
  describe "#validations" do
    it "requires shipping_name" do
      order = Order.new(
        product: Product.new,
        shipping_name: nil,
        address: "123 Some Road",
        zipcode: "90210",
        user_facing_id: "890890908980980"
      )

      expect(order.valid?).to eq(false)
      expect(order.errors[:shipping_name].size).to eq(1)
    end

    context "gifted order" do
      let(:child) do
        child = Child.new(
          full_name: "Test Test",
          birthdate: "1111-11-11",
          parent_name: "Test Test Test",
        )
      end
      let(:order) do
        Order.new(
          gift: true,
          product: Product.new,
          shipping_name: "Someone",
          address: "123 Some Road",
          zipcode: "90210",
          user_facing_id: "890890908980980",
          billing_address: "321 somewhere st",
          billing_zipcode: "54321"
        )
      end
      it "success: child exists" do
        child.save
        order.child = child
        expect(order.valid?).to be_truthy
      end
      it "failure: child does not exist" do
        order.child = child
        expect(order.valid?).to be_falsey
      end
    end
  end

  describe "#create_with_params" do
    let(:child) do
      child = Child.create(
        full_name: "Test Test",
        birthdate: "1111-11-11",
        parent_name: "Test Test Test",
      )
    end

    let(:product) do
      product = Product.create(
        name: "product",
        description: "buy it",
        price_cents: 1000,
        age_low_weeks: 21,
        age_high_weeks: 26
      )
    end

    let(:params) do 
      {
        "shipping_name"=>"Duder, Jr", 
        "product_id"=>"#{product.id}", 
        "zipcode"=>"", 
        "address"=>"", 
        "gift"=>"1", 
        "child"=>child,
        "gift_message"=>"duder", 
        "billing_address"=>"321 somewhere st", 
        "billing_zipcode"=>"12345", 
        "paid"=>false,
        "user_facing_id"=>"95ef32ba"
      }
    end

    it "creates a non gifted order" do
      params["gift"] = "0"
      params["address"] = params["billing_address"]
      params["zipcode"] = params["billing_zipcode"]
      params["billing_address"] = params["billing_zipcode"] = ""

      o = Order.create_with_params(params)
      expect(o.valid?).to be_truthy
    end

    it "creates gifted order" do
      o = Order.new(params)
      o.address = o.billing_address
      o.zipcode = o.billing_zipcode
      o.gift = false
      o.billing_address = ""
      o.billing_zipcode = ""
      o.save
      o = Order.create_with_params(params)
      expect(o.valid?).to be_truthy
    end
  end
end
