$:.unshift(File.dirname(__FILE__) + '/../lib')
require 'http_accept_language'
require 'test/unit'

class MockedCgiRequest
  include HttpAcceptLanguage
  def env
    @env ||= {'HTTP_ACCEPT_LANGUAGE' => 'en-us,en-gb;q=0.8,en;q=0.6'}
  end
end

class HttpAcceptLanguageTest < Test::Unit::TestCase
  def test_should_return_empty_array
    request.env['HTTP_ACCEPT_LANGUAGE'] = nil
    assert_equal [], request.user_preferred_languages
  end

  def test_should_properly_split
    assert_equal %w{en-US en-GB en}, request.user_preferred_languages
  end

  def test_should_ignore_jambled_header
    request.env['HTTP_ACCEPT_LANGUAGE'] = 'odkhjf89fioma098jq .,.,'
    assert_equal [], request.user_preferred_languages
  end

  def test_should_find_first_available_language
    assert_equal 'en-GB', request.preferred_language_from(%w{en en-GB})
  end

  def test_should_find_first_compatible_language
    assert_equal nil, request.compatible_language_from(%w{en-HK})
    assert_equal 'en', request.compatible_language_from(%w{en})
  end

  def test_should_find_first_compatible_from_user_preferred1
    request.env['HTTP_ACCEPT_LANGUAGE'] = 'zh-cn,en-us;q=0.7,en;q=0.3'
    assert_equal 'en', request.compatible_language_from(%w{de en zh-TW})
 end

  def test_should_find_first_compatible_from_user_preferred2
    request.env['HTTP_ACCEPT_LANGUAGE'] = 'zh-tw,en-us;q=0.7,en;q=0.3'
    assert_equal 'zh-TW', request.compatible_language_from(%w{de en zh-TW})
  end

  def test_should_find_first_compatible_from_user_preferred3
    request.env['HTTP_ACCEPT_LANGUAGE'] = 'en-US,de,en'
    assert_equal 'en', request.compatible_language_from(%w{de en zh-TW})
  end

  def test_should_find_first_compatible_from_user_preferred4
    request.env['HTTP_ACCEPT_LANGUAGE'] = 'de-de,en-us;q=0.7,en;q=0.3'
    assert_equal 'de', request.compatible_language_from(%w{de en zh-TW})
  end

  private
  def request
    @request ||= MockedCgiRequest.new
  end
end
