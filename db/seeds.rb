# Always clear sample seeds
Category.joins(:translations).where("category_translations.name like '% Category'").destroy_all
CategoryTranslation.where("name like '% Category'").destroy_all
Listing.where("title like '%I can ship%'").destroy_all
Person.where("phone_number like '%555'").destroy_all

if ENV['SAMPLE_SEEDS'].to_s.downcase == 'true'
  require Rails.root.join('lib', 'factories.rb').to_s

  10.times { FactoryGirl.create(:seed_category) }
  100.times { FactoryGirl.create(:seed_listing) }
end
