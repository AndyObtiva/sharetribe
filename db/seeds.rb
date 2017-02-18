Category.joins(:translations).where("category_translations.name like '% Category'").destroy_all
CategoryTranslation.where("name like '% Category'").destroy_all
Listing.where("title like '%I can ship%'").destroy_all
Person.where("phone_number like '%555'").destroy_all

10.times { FactoryGirl.create(:seed_category) }
100.times { FactoryGirl.create(:seed_listing) }
