
require 'sequel'
require 'json'




class Chef11KeyDump

  def self.dump
    Chef11KeyDump.new.create_chef11_key_file
  end

  def key_file
    "key_dump.json"
  end

  def create_chef11_key_file
    sql_host, sql_port, sql_user, sql_password = pull_chef11_db_credentials

    server_string = "#{sql_user}:#{sql_password}@#{sql_host}:#{sql_port}/opscode_chef"
    db = ::Sequel.connect("postgres://#{server_string}")

    sql_user_data = db.select(:username, :id, :public_key, :hashed_password, :salt, :hash_type).from(:osc_users)
    sql_users_json =  sql_user_data.all.to_json
    file_open(key_file, 'w') { |file| file.write(sql_users_json)}
  end
  
  def pull_chef11_db_credentials
    # This code pulled from knife-ec-backup and adapted
    puts "Pulling open source Chef 11 database credentials"
    
    if !File.exists?("/etc/chef-server/chef-server-running.json")
      puts "Failed to find /etc/chef-server/chef-server-running.json"
      exit 1
    end

    running_config = JSON.parse(File.read("/etc/chef-server/chef-server-running.json"))
    sql_host = running_config['chef_server']['postgresql']['vip']
    sql_port = running_config['chef_server']['postgresql']['port']
    sql_user = running_config['chef_server']['postgresql']['sql_user']
    sql_password = running_config['chef_server']['postgresql']['sql_password']
    [sql_host, sql_port, sql_user, sql_password]
  end

  def file_open(file, mode, &block)
    begin
      File.open(file, mode, &block)
    rescue Exception => e
      puts "Received exception #{e.message} when trying to open file #{file}"
      exit 1
    end
  end

end
