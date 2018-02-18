class IPGroupsService
  def self.execute
    query = <<-SQL
      SELECT DISTINCT uip.ip, u.username
      FROM user_ips AS uip
      INNER JOIN user_ips_users AS uip_u
        ON uip_u.user_ip_id = uip.id
      INNER JOIN users AS u
        ON u.id = uip_u.user_id;
    SQL

    # only uniq pairs username + ip in array like below
    # [{'username' => 'Vasya', 'ip' => '1.2.3.4'}, {'username' => 'Petya', 'ip' => '4.3.2.1'},
    #  {'username' => 'Kolya', 'ip' => '4.3.2.1'}, {'username' => 'Petya', 'ip' => '5.6.7.8'}, ...]
    sql_result = ActiveRecord::Base.connection.execute(query).to_a

    sql_result.
      group_by { |e| e['ip'] }.                     # group by same ip
      each { |_,v| v.map! { |e| e['username'] } }.  # modify values to simple usernames
      reject { |_,v| v.size == 1 }.                 # remove ip with single users
      map { |k,v| { ip: k, users: v } }             # modify to requested format
  end
end
