class CreateJoinTableUserIpUser < ActiveRecord::Migration[5.1]
  def self.up
    create_join_table :user_ips, :users do |t|
      t.index [:user_ip_id, :user_id]
      t.index [:user_id, :user_ip_id]
    end

    Post.all.each do |post|
      ip = post.user_ip
      ip.users << post.user unless ip.users.include?(post.user)
    end
  end

  def self.down
    drop_join_table :user_ips, :users
  end
end
