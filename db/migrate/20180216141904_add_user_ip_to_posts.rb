class AddUserIpToPosts < ActiveRecord::Migration[5.1]
  def self.up
    add_reference :posts, :user_ip, index: true, foreign_key: true

    Post.all.each do |post|
      post.update(user_ip: UserIp.find_or_create_by(ip: post.ip))
    end

    remove_index :posts, :ip
    remove_column :posts, :ip
  end

  def self.down
    add_column :posts, :ip, :string
    add_index :posts, :ip

    Post.all.each do |post|
      post.update(ip: post.user_ip.ip)
    end

    remove_reference :posts, :user_ip, index: true, foreign_key: true
  end
end
