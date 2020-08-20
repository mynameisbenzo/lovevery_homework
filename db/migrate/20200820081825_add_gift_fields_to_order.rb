class AddGiftFieldsToOrder < ActiveRecord::Migration[6.0]
  def change
    add_column :orders, :gift, :boolean
    add_column :orders, :gift_message, :string
    add_column :orders, :billing_address, :string, comment: "Street Address for billing"
    add_column :orders, :billing_zipcode, :string, comment: "Zip Code for billing"
  end
end
