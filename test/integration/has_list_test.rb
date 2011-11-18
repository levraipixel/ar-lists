require 'test_helper'

class User < ActiveRecord::Base
end
class UsersGroup < ActiveRecord::Base
	has_list :users
	has_list :users_in_mailing_list, :class_name => 'User', :uniq => true
end

class HasListTest < ActiveSupport::IntegrationCase

  test "has_list should be able to simulate a list behaviour" do

  	users = {}
  	(1..9).each do |i|
  		users[i] = User.create
  		assert (users[i].id == i)
  	end
  	group = UsersGroup.new
  	group.users = [users[1], users[2], users[3], users[2]]
  	assert (group.users == [users[1], users[2], users[3], users[2]])
  	group.save!
  	assert (group.id == 1)
  	group2 = UsersGroup.create(:users => [users[2], users[3]])
  	assert (group2.id == 2)
  	assert (UsersGroup.with_users_containing(users[1]) == [group])
  	assert (UsersGroup.with_users_containing(users[2]) == [group, group2])
  end

  test "has_list should be able to simulate a set behaviour" do

  	users = {}
  	(1..9).each do |i|
  		users[i] = User.create
  		assert (users[i].id == i)
  	end
  	group = UsersGroup.new
  	group.users_in_mailing_list = [users[1], users[2], users[3], users[2]]
  	assert (group.users_in_mailing_list == [users[1], users[2], users[3]])
  end

end
