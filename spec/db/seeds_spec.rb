require 'spec_helper'

describe 'Seeds' do
  let!(:initial_listing_shape_count) {ListingShape.count}
  let!(:initial_category_listing_shape_count) {ListingShape::HABTM_Categories.count}
  let!(:initial_listing_count) {Listing.count}
  let!(:initial_location_count) {Location.count}
  let!(:initial_person_count) {Person.count}
  let!(:initial_category_count) {Category.count}
  let!(:initial_category_translation_count) {CategoryTranslation.count}
  let!(:initial_email_count) {Email.count}
  let!(:initial_community_membership_count) {CommunityMembership.count}
  let!(:excluded_models) {
    Dir.glob(Rails.root.join('app', 'models', '**', '*.rb')).each {|f| require(f.sub(/.rb/,'')) rescue nil}
    excluded_models = ActiveRecord::Base.subclasses - [
      Category, CategoryTranslation, Listing, Location, Person, Email,
      ListingShape, ListingShape::HABTM_Categories, Category::HABTM_ListingShapes,
      CategoryListingShape, CommunityMembership
    ]
  }
  let!(:initial_excluded_model_counts) {
    excluded_models.inject({}) do |output, excluded_model|
      output.merge(excluded_model => excluded_model.count)
    end
  }
  before do
    # Run twice to ensure it refreshes data and does not destroy data available
    # before seeding
    ENV['SAMPLE_SEEDS'] = 'true'
    load Rails.root.join('db', 'seeds.rb').to_s
    load Rails.root.join('db', 'seeds.rb').to_s
  end
  it 'adds 10 categories and 100 listings with their associations' do
    # expect(ListingShape::HABTM_Categories.count).to eq(initial_category_listing_shape_count + 10)
    # expect(Category::HABTM_ListingShapes.count).to eq(initial_category_listing_shape_count + 10)
    expect(ListingShape.count).to eq(initial_listing_shape_count + 1)
    expect(Category.count).to eq(initial_category_count + 10)
    expect(CategoryTranslation.count).to eq(initial_category_translation_count + 10)
    expect(Listing.count).to eq(initial_listing_count + 100)
    expect(Location.count).to eq(initial_listing_count + 200) #origins and destinations
    expect(Person.count).to eq(initial_person_count + 100)
    expect(CommunityMembership.count).to eq(initial_person_count + 100)
    expect(Email.count).to eq(initial_email_count + 100)

    initial_excluded_model_counts.each do |excluded_model, initial_excluded_model_count|
      expect("#{excluded_model} count: #{excluded_model.count}").to eq("#{excluded_model} count: #{initial_excluded_model_count}")
    end

    Category.
      joins(:translations).
      where("category_translations.name like '% Category'").
      each do |category|
        expect(category.url).to end_with('-category')
      end
  end
end
