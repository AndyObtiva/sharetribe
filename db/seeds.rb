Category.joins(:translations).where("category_translations.name like '% Category'").destroy_all
CategoryTranslation.where("name like '% Category'").destroy_all
Listing.where("title like '%I can carry%'").destroy_all
Person.where("phone_number like '%555'").destroy_all

10.times.map do |n|
  FactoryGirl.create(:seed_category)
end
100.times.map do |n|
  FactoryGirl.create(:seed_listing)
end
