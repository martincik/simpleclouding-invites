require 'simpleclouding'
require 'nokogiri'
require 'test/unit'
require 'rack/test'

set :environment, :test

class SimpleCloudingTest < Test::Unit::TestCase
  include Rack::Test::Methods

  def app
    Sinatra::Application
  end
  
  def setup
    Invite.all.destroy!
  end

  def test_it_returns_form_with_email
    get '/'
    assert last_response.ok?
    assert_not_nil last_response.body
  end
  
  def test_it_adds_email_to_database_and_prints_flash
    pre_count = Invite.count
    post '/', :email => 'ladislav.martincik@gmail.com'

    assert last_response.redirect?
    assert_equal pre_count + 1, Invite.count
    
    follow_redirect!
    assert last_response.ok?
    assert_equal "Invite added successfully. Well done! &#63743;", flash_notice(last_response.body).strip
  end
  
  def test_it_rejects_wrong_email
    pre_count = Invite.count
    post '/', :email => 'ladislav.martincikgmail.com'
    
    assert last_response.redirect?
    assert_not_nil last_response.body
    assert_equal pre_count, Invite.count
    
    follow_redirect!
    assert last_response.ok?
    assert_equal "Doesn't look like an email address to me ...", flash_error(last_response.body).strip
  end

  def test_it_rejects_empty_email
    pre_count = Invite.count
    post '/', :email => ''
    
    assert last_response.redirect?
    assert_not_nil last_response.body
    assert_equal pre_count, Invite.count
    
    follow_redirect!
    assert last_response.ok?
    assert_equal "We need your email address., Doesn't look like an email address to me ...", flash_error(last_response.body).strip
  end

  def test_it_doesnt_add_already_added_email
    Invite.create!(:email => 'ladislav.martincik@gmail.com')
    pre_count = Invite.count
    
    post '/', :email => 'ladislav.martincik@gmail.com'
  
    assert last_response.redirect?
    assert_not_nil last_response.body
    assert_equal pre_count, Invite.count
    
    follow_redirect!
    assert last_response.ok?
    assert_equal "We already have that email. Thank you!", flash_error(last_response.body).strip
  end
  
  private
  
    def flash_notice(html)
      flash_message('notice', html)
    end
    
    def flash_error(html)
      flash_message('error', html)
    end
    
    def flash_message(flash_type, html)
      doc = Nokogiri::HTML(html)
      doc.search("##{flash_type}").inner_html
    end

end