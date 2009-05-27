class ThriveSmart::TestCase < ActionController::TestCase

  #Assertion helpers
  def assert_response_contains *args
    args.flatten.each do |value|
      assert @response.body.include?(value), "value:#{value} was not present in the response"
    end
  end

  # Headers and Format helpers
  def get_with_headers_and_format *args
    set_headers_and_add_format_argument args
    get_without_headers_and_format(*args)
  end
  alias_method_chain :get, :headers_and_format

  def post_with_headers_and_format *args
    set_headers_and_add_format_argument args
    post_without_headers_and_format(*args)
  end
  alias_method_chain :post, :headers_and_format

  def put_with_headers_and_format *args
    set_headers_and_add_format_argument args
    put_without_headers_and_format(*args)
  end
  alias_method_chain :put, :headers_and_format

  def set_headers_and_add_format_argument args
    set_headers
    args << {} if !args.last.is_a?(Hash)
    args.last[:format] = 'tson' if args.last[:format].nil?
  end

  def set_headers
    set_raw_signature
    @request.env[ThriveSmart::Constants.ts_signature_headers_key] = "#{@raw_signature_string}&ts_sig=#{CGI::escape(compute_signature)}"
  end

  def set_raw_signature
    @raw_signature_string = "ts_sig_api_key=#{CGI::escape(ThriveSmart::Constants.config['api_key'])}&ts_sig_time=#{CGI::escape(Time.now.to_f.to_s)}"
  end

  def compute_signature
    Digest::MD5.hexdigest([@raw_signature_string, ThriveSmart::Constants.config['secret_key']].join)
  end
end