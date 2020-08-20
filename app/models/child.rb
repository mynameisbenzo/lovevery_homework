class Child < ApplicationRecord
  has_many :orders

  def self.find_or_create_with_params(params, gift)
    if gift
      child = Child.find_by(
                        full_name: params[:full_name], 
                        birthdate: params[:birthdate],
                        parent_name: params[:parent_name],
                      )
      child_new = Child.new(params)
      return (child.nil?) ? Child.new(params) : child
    else
      return Child.find_or_create_by(params)
    end 
  end
end
