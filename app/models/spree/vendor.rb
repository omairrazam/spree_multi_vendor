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


    has_one_attached :logo_image # one-to-one
    has_many :users, through: :vendor_users

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
