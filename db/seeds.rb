SEED_COUNT = ENV['SEED_COUNT'] || 50
# Always clear sample seeds
ListingUnit.joins(:listing_shape).where("listing_shapes.name = 'shipping_seed'").destroy_all
# Category::HABTM_ListingShapes.joins(:listing_shape => {:categories => :translations}).where("category_translations.name like '% Category'").destroy_all
ListingShape.where("listing_shapes.name = 'shipping_seed'").destroy_all
# ListingShape::HABTM_Categories.joins(:category => :translations).where("category_translations.name like '% Category'").destroy_all
Category.joins(:translations).where("category_translations.name like '% Category'").destroy_all
CategoryTranslation.where("name like '% Category'").destroy_all
Listing.where("title like '%I can ship%'").destroy_all
CommunityMembership.where(consent: 'seed_consent0.1').destroy_all
Person.where("phone_number like '%555'").destroy_all
Location.where("address like '% great city'").destroy_all

if ENV['SAMPLE_SEEDS'].to_s.downcase == 'true'
  require Rails.root.join('lib', 'factories.rb').to_s

  10.times { FactoryGirl.create(:seed_category) }
  SEED_COUNT.times { FactoryGirl.create(:seed_listing) }
end
