=begin
#directus.io

#API for directus.io

OpenAPI spec version: 1.1

Generated by: https://github.com/swagger-api/swagger-codegen.git
Swagger Codegen version: 3.0.0-SNAPSHOT

=end

require 'spec_helper'
require 'json'
require 'date'

# Unit tests for DirectusSDK::GetSettingsDataFiles
# Automatically generated by swagger-codegen (github.com/swagger-api/swagger-codegen)
# Please update as you see appropriate
describe 'GetSettingsDataFiles' do
  before do
    # run before each test
    @instance = DirectusSDK::GetSettingsDataFiles.new
  end

  after do
    # run after each test
  end

  describe 'test an instance of GetSettingsDataFiles' do
    it 'should create an instance of GetSettingsDataFiles' do
      expect(@instance).to be_instance_of(DirectusSDK::GetSettingsDataFiles)
    end
  end
  describe 'test attribute "allowed_thumbnails"' do
    it 'should work' do
       # assertion here. ref: https://www.relishapp.com/rspec/rspec-expectations/docs/built-in-matchers
    end
  end

  describe 'test attribute "thumbnail_quality"' do
    it 'should work' do
       # assertion here. ref: https://www.relishapp.com/rspec/rspec-expectations/docs/built-in-matchers
    end
  end

  describe 'test attribute "thumbnail_size"' do
    it 'should work' do
       # assertion here. ref: https://www.relishapp.com/rspec/rspec-expectations/docs/built-in-matchers
    end
  end

  describe 'test attribute "file_naming"' do
    it 'should work' do
       # assertion here. ref: https://www.relishapp.com/rspec/rspec-expectations/docs/built-in-matchers
    end
  end

  describe 'test attribute "thumbnail_crop_enabled"' do
    it 'should work' do
       # assertion here. ref: https://www.relishapp.com/rspec/rspec-expectations/docs/built-in-matchers
    end
  end

  describe 'test attribute "youtube_api_key"' do
    it 'should work' do
       # assertion here. ref: https://www.relishapp.com/rspec/rspec-expectations/docs/built-in-matchers
    end
  end

end

