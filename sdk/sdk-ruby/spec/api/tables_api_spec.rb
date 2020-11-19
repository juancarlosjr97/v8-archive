=begin
#directus.io

#API for directus.io

OpenAPI spec version: 1.1

Generated by: https://github.com/swagger-api/swagger-codegen.git
Swagger Codegen version: 3.0.0-SNAPSHOT

=end

require 'spec_helper'
require 'json'

# Unit tests for DirectusSDK::TablesApi
# Automatically generated by swagger-codegen (github.com/swagger-api/swagger-codegen)
# Please update as you see appropriate
describe 'TablesApi' do
  before do
    # run before each test
    @instance = DirectusSDK::TablesApi.new
  end

  after do
    # run after each test
  end

  describe 'test an instance of TablesApi' do
    it 'should create an instance of TablesApi' do
      expect(@instance).to be_instance_of(DirectusSDK::TablesApi)
    end
  end

  # unit tests for add_column
  # Create a column in a given table
  # 
  # @param table_id ID of table to return rows from
  # @param [Hash] opts the optional parameters
  # @option opts [String] :table_name Name of table to add
  # @option opts [String] :column_name The unique name of the column to create
  # @option opts [String] :type The datatype of the column, eg: INT
  # @option opts [String] :ui The Directus Interface to use for this column
  # @option opts [BOOLEAN] :hidden_input Whether the column will be hidden (globally) on the Edit Item page
  # @option opts [BOOLEAN] :hidden_list Whether the column will be hidden (globally) on the Item Listing page
  # @option opts [BOOLEAN] :required Whether the column is required. If required, the interface&#39;s validation function will be triggered
  # @option opts [Integer] :sort The sort order of the column used to override the column order in the schema
  # @option opts [String] :comment A helpful note to users for this column
  # @option opts [String] :relationship_type The column&#39;s relationship type (only used when storing relational data) eg: ONETOMANY, MANYTOMANY or MANYTOONE
  # @option opts [String] :related_table The table name this column is related to (only used when storing relational data)
  # @option opts [String] :junction_table The pivot/junction table that joins the column&#39;s table with the related table (only used when storing relational data)
  # @option opts [String] :junction_key_left The column name in junction that is related to the column&#39;s table (only used when storing relational data)
  # @option opts [String] :junction_key_right The column name in junction that is related to the related table (only used when storing relational data)
  # @return [nil]
  describe 'add_column test' do
    it "should work" do
      # assertion here. ref: https://www.relishapp.com/rspec/rspec-expectations/docs/built-in-matchers
    end
  end

  # unit tests for add_row
  # Add a new row
  # 
  # @param table_id ID of table to return rows from
  # @param custom_data Data based on your specific schema eg: active&#x3D;1&amp;title&#x3D;LoremIpsum
  # @param [Hash] opts the optional parameters
  # @return [nil]
  describe 'add_row test' do
    it "should work" do
      # assertion here. ref: https://www.relishapp.com/rspec/rspec-expectations/docs/built-in-matchers
    end
  end

  # unit tests for add_table
  # Add a new table
  # 
  # @param [Hash] opts the optional parameters
  # @option opts [String] :name Name of table to add
  # @return [nil]
  describe 'add_table test' do
    it "should work" do
      # assertion here. ref: https://www.relishapp.com/rspec/rspec-expectations/docs/built-in-matchers
    end
  end

  # unit tests for delete_column
  # Delete row
  # 
  # @param table_id ID of table to return rows from
  # @param column_name Name of column to return
  # @param [Hash] opts the optional parameters
  # @return [nil]
  describe 'delete_column test' do
    it "should work" do
      # assertion here. ref: https://www.relishapp.com/rspec/rspec-expectations/docs/built-in-matchers
    end
  end

  # unit tests for delete_row
  # Delete row
  # 
  # @param table_id ID of table to return rows from
  # @param row_id ID of row to return from rows
  # @param [Hash] opts the optional parameters
  # @return [nil]
  describe 'delete_row test' do
    it "should work" do
      # assertion here. ref: https://www.relishapp.com/rspec/rspec-expectations/docs/built-in-matchers
    end
  end

  # unit tests for delete_table
  # Delete Table
  # 
  # @param table_id ID of table to return rows from
  # @param [Hash] opts the optional parameters
  # @return [nil]
  describe 'delete_table test' do
    it "should work" do
      # assertion here. ref: https://www.relishapp.com/rspec/rspec-expectations/docs/built-in-matchers
    end
  end

  # unit tests for get_table
  # Returns specific table
  # 
  # @param table_id ID of table to return rows from
  # @param [Hash] opts the optional parameters
  # @return [GetTable]
  describe 'get_table test' do
    it "should work" do
      # assertion here. ref: https://www.relishapp.com/rspec/rspec-expectations/docs/built-in-matchers
    end
  end

  # unit tests for get_table_column
  # Returns specific table column
  # 
  # @param table_id ID of table to return rows from
  # @param column_name Name of column to return
  # @param [Hash] opts the optional parameters
  # @return [GetTableColumn]
  describe 'get_table_column test' do
    it "should work" do
      # assertion here. ref: https://www.relishapp.com/rspec/rspec-expectations/docs/built-in-matchers
    end
  end

  # unit tests for get_table_columns
  # Returns table columns
  # 
  # @param table_id ID of table to return rows from
  # @param [Hash] opts the optional parameters
  # @return [GetTableColumns]
  describe 'get_table_columns test' do
    it "should work" do
      # assertion here. ref: https://www.relishapp.com/rspec/rspec-expectations/docs/built-in-matchers
    end
  end

  # unit tests for get_table_row
  # Returns specific table row
  # 
  # @param table_id ID of table to return rows from
  # @param row_id ID of row to return from rows
  # @param [Hash] opts the optional parameters
  # @return [GetTableRow]
  describe 'get_table_row test' do
    it "should work" do
      # assertion here. ref: https://www.relishapp.com/rspec/rspec-expectations/docs/built-in-matchers
    end
  end

  # unit tests for get_table_rows
  # Returns table rows
  # 
  # @param table_id ID of table to return rows from
  # @param [Hash] opts the optional parameters
  # @return [GetTableRows]
  describe 'get_table_rows test' do
    it "should work" do
      # assertion here. ref: https://www.relishapp.com/rspec/rspec-expectations/docs/built-in-matchers
    end
  end

  # unit tests for get_tables
  # Returns tables
  # 
  # @param [Hash] opts the optional parameters
  # @return [GetTables]
  describe 'get_tables test' do
    it "should work" do
      # assertion here. ref: https://www.relishapp.com/rspec/rspec-expectations/docs/built-in-matchers
    end
  end

  # unit tests for update_column
  # Update column
  # 
  # @param table_id ID of table to return rows from
  # @param column_name Name of column to return
  # @param [Hash] opts the optional parameters
  # @option opts [String] :data_type The datatype of the column, eg: INT
  # @option opts [String] :ui The Directus Interface to use for this column
  # @option opts [BOOLEAN] :hidden_input Whether the column will be hidden (globally) on the Edit Item page
  # @option opts [BOOLEAN] :hidden_list Whether the column will be hidden (globally) on the Item Listing page
  # @option opts [BOOLEAN] :required Whether the column is required. If required, the interface&#39;s validation function will be triggered
  # @option opts [Integer] :sort The sort order of the column used to override the column order in the schema
  # @option opts [String] :comment A helpful note to users for this column
  # @option opts [String] :relationship_type The column&#39;s relationship type (only used when storing relational data) eg: ONETOMANY, MANYTOMANY or MANYTOONE
  # @option opts [String] :related_table The table name this column is related to (only used when storing relational data)
  # @option opts [String] :junction_table The pivot/junction table that joins the column&#39;s table with the related table (only used when storing relational data)
  # @option opts [String] :junction_key_left The column name in junction that is related to the column&#39;s table (only used when storing relational data)
  # @option opts [String] :junction_key_right The column name in junction that is related to the related table (only used when storing relational data)
  # @return [nil]
  describe 'update_column test' do
    it "should work" do
      # assertion here. ref: https://www.relishapp.com/rspec/rspec-expectations/docs/built-in-matchers
    end
  end

  # unit tests for update_row
  # Update row
  # 
  # @param table_id ID of table to return rows from
  # @param row_id ID of row to return from rows
  # @param custom_data Data based on your specific schema eg: active&#x3D;1&amp;title&#x3D;LoremIpsum
  # @param [Hash] opts the optional parameters
  # @return [nil]
  describe 'update_row test' do
    it "should work" do
      # assertion here. ref: https://www.relishapp.com/rspec/rspec-expectations/docs/built-in-matchers
    end
  end

end