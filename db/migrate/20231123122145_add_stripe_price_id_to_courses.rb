class AddStripePriceIdToCourses < ActiveRecord::Migration[7.1]
  def change
    add_column :courses, :stripe_price_id, :string
  end
end
