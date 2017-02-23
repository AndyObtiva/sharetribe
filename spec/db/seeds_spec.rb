require 'spec_helper'

describe 'Seeds' do
  let!(:initial_community_membership_count) {CommunityMembership.count}
  let!(:initial_transaction_process_count) {TransactionProcess.count}
  let!(:initial_listing_shape_count) {ListingShape.count}
  let!(:initial_category_listing_shape_count) {ListingShape::HABTM_Categories.count}
  let!(:initial_listing_count) {Listing.count}
  let!(:initial_listing_image_count) {ListingImage.count}
  let!(:initial_location_count) {Location.count}
  let!(:initial_person_count) {Person.count}
  let!(:initial_category_count) {Category.count}
  let!(:initial_category_translation_count) {CategoryTranslation.count}
  let!(:initial_email_count) {Email.count}
  let!(:excluded_models) {
    Dir.glob(Rails.root.join('app', 'models', '**', '*.rb')).each {|f| require(f.sub(/.rb/,'')) rescue nil}
    excluded_models = ActiveRecord::Base.subclasses - [
      Category, CategoryTranslation, Listing, Location, Person, Email,
      ListingShape, ListingShape::HABTM_Categories, Category::HABTM_ListingShapes,
      CategoryListingShape, CommunityMembership, ListingImage, TransactionProcess
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
    ENV['SEED_COUNT'] = '10' #small to speed up tests
    load Rails.root.join('db', 'seeds.rb').to_s
    load Rails.root.join('db', 'seeds.rb').to_s
  end
  it "adds 10 categories and #{ENV['SEED_COUNT']} listings with their associations" do
    # expect(ListingShape::HABTM_Categories.count).to eq(initial_category_listing_shape_count + 10)
    # expect(Category::HABTM_ListingShapes.count).to eq(initial_category_listing_shape_count + 10)
    expect(ListingShape.count).to eq(initial_listing_shape_count + 1)
    expect(TransactionProcess.count).to eq(initial_transaction_process_count + 1)
    expect(Category.count).to eq(initial_category_count + 10)
    expect(CategoryTranslation.count).to eq(initial_category_translation_count + 10)
    expect(Listing.count).to eq(initial_listing_count + ENV['SEED_COUNT'].to_i)
    expect(ListingImage.count).to eq(initial_listing_image_count + ENV['SEED_COUNT'].to_i)
    expect(Location.count).to eq(initial_listing_count + 2*ENV['SEED_COUNT'].to_i) #origins and destinations
    expect(Person.count).to eq(initial_person_count + ENV['SEED_COUNT'].to_i)
    expect(CommunityMembership.count).to eq(initial_person_count + ENV['SEED_COUNT'].to_i)
    expect(Email.count).to eq(initial_email_count + ENV['SEED_COUNT'].to_i)

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
