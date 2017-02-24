ENV['SEED_COUNT'] ||= '50'
# Always clear sample seeds
ListingUnit.joins(:listing_shape).where("listing_shapes.name = 'shipping_seed'").destroy_all
# Category::HABTM_ListingShapes.joins(:listing_shape => {:categories => :translations}).where("category_translations.name like '% Category'").destroy_all
TransactionProcess.joins(:listing_shape).where("listing_shapes.name = 'shipping_seed'").destroy_all
ListingShape.where("listing_shapes.name = 'shipping_seed'").destroy_all
# ListingShape::HABTM_Categories.joins(:category => :translations).where("category_translations.name like '% Category'").destroy_all
Category.joins(:translations).where("category_translations.name like '% Category'").destroy_all
CategoryTranslation.where("name like '% Category'").destroy_all
Listing.where("title like '%I can ship%'").destroy_all
CommunityMembership.where(consent: 'seed_consent0.1').destroy_all
Person.where("phone_number like '%555'").destroy_all
Location.where("address like '% great city'").destroy_all

community_name = ENV['SHARETRIBE_COMMUNITY_NAME'] || "Anapog"
community_locale = ENV['SHARETRIBE_COMMUNITY_LOCALE'] || "en"
community_slogan = ENV['SHARETRIBE_COMMUNITY_SLOGAN'] || "SHIP WITH A TRAVELLER"
community_description = ENV['SHARETRIBE_COMMUNITY_DESCRIPTION'] || "Tired of big expensive shipping fees? Ship with a traveller instead. Find one. Connect. Ship. As easy as 1 2 3!"

if Community.count == 0
  anapog_community = FactoryGirl.create(:community,
    community_customization_name: community_name,
    community_customization_locale: community_locale,
    slogan: community_slogan,
    description: community_description
  )

  marketplace_configurations = FactoryGirl.create(:marketplace_configurations,
    community_id: anapog_community.id
  )
  listing_shape = FactoryGirl.create(:seed_listing_shape,
    community_id: anapog_community.id
  )
  ['Flight/Train', 'Car', 'Metro/Bus', 'Hitchhiking/Bicycle'].each do |name|
    category = FactoryGirl.create(:seed_category,
    community: anapog_community,
    name: name
    )
  end
end

admin_email = ENV['SHARETRIBE_INITIAL_ADMIN_EMAIL'] || "andy.am@gmail.com"
admin_password = ENV['SHARETRIBE_INITIAL_ADMIN_PASSWORD'] || "pass1234"

if Person.joins(:emails).where(:emails => {:address => admin_email}).count == 0
  admin_person = FactoryGirl.create(:seed_person,
    email_address: admin_email,
    password: admin_password,
    given_name: 'Admin',
    family_name: 'Admin',
    phone_number: '000-123-4567',
    is_admin: 1
  )
end


if ENV['SAMPLE_SEEDS'].to_s.downcase == 'true'
  require Rails.root.join('lib', 'factories.rb').to_s

  10.times { FactoryGirl.create(:seed_category) }
  ENV['SEED_COUNT'].to_i.times { FactoryGirl.create(:seed_listing) }
end
