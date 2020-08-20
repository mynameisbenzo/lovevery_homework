class Order < ApplicationRecord
  belongs_to :product
  belongs_to :child

  validates :shipping_name, presence: true
  validates_presence_of :billing_address, if: Proc.new { |o| o.gift? }
  validates_presence_of :billing_zipcode, if: Proc.new { |o| o.gift? }

  validate :child_exists_for_gift?

  def self.create_with_params(params)
    current_order = Order.new(params)
    return current_order unless current_order.valid?
    unless current_order.gift?
      current_order.save
      return current_order
    end
    last_order_for_child = Order.where(child_id: params["child"].id).last
    current_order.address = last_order_for_child.address
    current_order.zipcode = last_order_for_child.zipcode
    current_order.save
    current_order
  end

  def to_param
    user_facing_id
  end

  private

  def child_exists_for_gift?
    if gift && !child_id
      self.errors.add(:base, "Child #{child.full_name} does not exist in the system")
    end
    true
  end
end
