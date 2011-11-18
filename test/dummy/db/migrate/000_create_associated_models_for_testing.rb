class CreateAssociatedModelsForTesting < ActiveRecord::Migration
  def self.up
    create_table :users
    create_table :users_groups do |t|
      t.text :users
      t.text :users_in_mailing_list
    end
  end
  def self.down
    drop_table :users
    drop_table :users_groups
  end
end
