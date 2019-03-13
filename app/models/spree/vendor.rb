module Spree
  class Vendor < Spree::Base
    extend FriendlyId

    acts_as_paranoid
    friendly_id :name, use: :slugged

    validates :name, presence: true, uniqueness: { case_sensitive: false }
    validates :slug, uniqueness: true

    with_options dependent: :destroy do
      has_many :option_types
      has_many :products
      has_many :properties
      has_many :shipping_methods
      has_many :stock_locations
      has_many :variants
      has_many :vendor_users
    end


    has_many :orders
    has_many :products
    has_many :shipping_methods, class_name: Spree::ShippingMethod
    has_many :stock_locations, class_name: Spree::StockLocation
    has_many :users, through: :vendor_users
    has_many :vendor_users, class_name: Spree::VendorUser

    after_create :create_stock_location

    state_machine :state, initial: :pending do
      event :activate do
        transition to: :active
      end

      event :block do
        transition to: :blocked
      end
    end

    self.whitelisted_ransackable_attributes = %w[name state]

    private

    def create_stock_location
      stock_locations.where(name: name, country: Spree::Country.default).first_or_create!
    end
  end
end
