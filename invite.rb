class Invite
  include DataMapper::Resource
  
  property :id, Serial
  property :created_at, DateTime
  property :email, String, 
    :nullable => false, 
    :unique => true, 
    :format => :email_address,
    :messages => {
      :presence => "We need your email address.",
      :is_unique => "We already have that email. Thank you!",
      :format => "Doesn't look like an email address to me ..."
    }
end

DataMapper::setup(:default, "sqlite3://#{Dir.pwd}/invites.db")