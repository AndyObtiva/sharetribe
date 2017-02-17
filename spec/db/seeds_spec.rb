require 'spec_helper'

describe 'Seeds' do
  let!(:initial_listing_count) {Listing.count}
  let!(:initial_person_count) {Person.count}
  let!(:initial_category_count) {Category.count}
  let!(:initial_category_translation_count) {CategoryTranslation.count}
  let!(:initial_email_count) {Email.count}
  let!(:excluded_models) {
    Dir.glob(Rails.root.join('app', 'models', '**', '*.rb')).each {|f| require(f.sub(/.rb/,'')) rescue nil}
    excluded_models = ActiveRecord::Base.subclasses - [Category, CategoryTranslation, Listing, Person, Email]
  }
  let!(:initial_excluded_model_counts) {
    excluded_models.inject({}) do |output, excluded_model|
      output.merge(excluded_model => excluded_model.count)
    end
  }
  before do
    # Run twice to ensure it refreshes data and does not destroy data available
    # before seeding
    load Rails.root.join('db', 'seeds.rb').to_s
    load Rails.root.join('db', 'seeds.rb').to_s
  end
  it 'adds 10 categories with translatios and 100 listings with 100 people and emails' do
    expect(Category.count).to eq(initial_category_count + 10)
    expect(CategoryTranslation.count).to eq(initial_category_translation_count + 10)
    expect(Listing.count).to eq(initial_listing_count + 100)
    expect(Person.count).to eq(initial_person_count + 100)
    expect(Email.count).to eq(initial_email_count + 100)

    initial_excluded_model_counts.each do |excluded_model, initial_excluded_model_count|
      expect("#{excluded_model} count: #{excluded_model.count}").to eq("#{excluded_model} count: #{initial_excluded_model_count}")
    end
  end
end
