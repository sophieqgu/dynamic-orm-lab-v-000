require_relative "../config/environment.rb"
require 'active_support/inflector'

class InteractiveRecord
  
  def self.table_name
    self.to_s.downcase.pluralize
  end 
  
  
  def self.column_names
    DB[:conn].results_as_hash = true 
    
    sql = "PRAGMA table_info ('#{table_name}')"
    table_info = DB[:conn].execute(sql)
    
    table_info.map do |column| 
      column["name"]
    end.compact 
  end 
  
  
  def initialize(attributes = {})
    attributes.each do |k, v|
      self.send("#{k}=", v)
    end 
  end 
  
  
  def table_name_for_insert 
    self.class.table_name 
  end 
  
  
  def col_names_for_insert 
    self.class.column_names.delete_if {|column_name| column_name == "id"}.join(", ")
  end 
  
  
  def values_for_insert 
    self.class.column_names.delete_if {|column_name| column_name == "id"}.map do |column_name|
      "'#{send(column_name)}'" unless send(column_name).nil?
    end.join(", ")
  end 
  
end