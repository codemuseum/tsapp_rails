require 'test_helper'

class <%= controller_class_name %>ControllerTest < ThriveSmart::TestCase
  def test_should_get_index
    get :index
    assert_response :success
    assert_not_nil assigns(:<%= table_name %>)
  end

  def test_should_get_new
    get :new
    assert_response :success
  end

  def test_should_create_<%= file_name %>
    assert_difference('<%= class_name %>.count') do
      post :create, :<%= file_name %> => generate_<%= file_name %>_hash
    end

    assert_response :created
    assert_response_contains <%= file_name %>_hash.values
    assert_equal <%= file_name %>_url(assigns(:<%= file_name %>)), @response.headers['Location']
  end

  def test_should_be_valid_<%= file_name %>_create
    assert_no_difference('<%= class_name %>.count') do
      post :create_valid, :<%= file_name %> => generate_<%= file_name %>_hash
    end

    assert_response :ok
    assert_response_contains <%= file_name %>_hash.values
  end

  def test_should_duplicate_<%= file_name %>
    new_record = {:urn => random_string}
    source = generate_<%= file_name %>

    assert_difference('<%= class_name %>.count') do
      post :duplicate, :<%= file_name %> => new_record, :source => source.urn
    end

    assert_response :created
    #must include the new URN
    assert_response_contains new_record.values
    #must include the source attributes
    assert_response_contains(<%= file_name %>_hash.reject {|k,v| k == :urn}.values)
    assert_equal <%= file_name %>_url(assigns(:<%= file_name %>)), @response.headers['Location']
  end

  def test_should_be_valid_<%= file_name %>_duplicate
    new_record = {:urn => random_string}
    source = generate_<%= file_name %>

    assert_no_difference('<%= class_name %>.count') do
      post :duplicate_valid, :<%= file_name %> => new_record, :source => source.urn
    end

    assert_response :ok
    #must include the new URN
    assert_response_contains new_record.values
    #must include the source attributes
    assert_response_contains(<%= file_name %>_hash.reject {|k,v| k == :urn}.values)
  end

  def test_should_show_<%= file_name %>
    get :show, :id => generate_<%= file_name %>.urn
    assert_response :success
    assert_response_contains <%= file_name %>_hash.values
  end

  def test_should_get_edit
    get :edit, :id => generate_<%= file_name %>.urn
    assert_response :success
    assert_response_contains <%= file_name %>_hash.values
  end

  def test_should_update_<%= file_name %>
    original = generate_<%= file_name %>
    new_values = generate_<%= file_name %>_hash.reject! {|k,v| k == :urn}
    put :update, :id => original.urn, :<%= file_name %> => new_values

    assert_response :success
    original.reload
    new_values.each do |k, value|
      assert_equal value, original.send(k)
    end
  end

  def test_should_be_valid_<%= file_name %>_update
    original = generate_<%= file_name %>
    old_values = <%= file_name %>_hash
    new_values = generate_<%= file_name %>_hash.reject! {|k,v| k == :urn}
    put :update_valid, :id => original.urn, :<%= file_name %> => new_values

    assert_response :success
    original.reload
    old_values.each do |k, value|
      assert_equal value, original.send(k)
    end
  end

  def test_should_destroy_<%= file_name %>
    original = generate_<%= file_name %>
    assert_difference('<%= class_name %>.count', -1) do
      set_headers
      delete :destroy, :format => 'tson', :id => original.urn
    end

    assert_response :success
    assert_nil <%= class_name %>.find_by_urn(original.urn)
  end


  # Mocking for <%= controller_class_name %>s
  attr_reader :<%= file_name %>_hash
  def generate_<%= file_name %>_hash(salt = random_string)
    @<%= file_name %>_hash = {:urn => "PageObjectURN#{salt}",
      :title => "Page Object Title #{salt}",
      :link => "URL to page object #{salt}"
    }
  end

  attr_reader :<%= file_name %>
  def generate_<%= file_name %>
    @<%= file_name %> = <%= class_name %>.create(generate_<%= file_name %>_hash)
  end

  def random_string(length = 10)
    Array.new(length) { (rand(122-97) + 97).chr }.join
  end
end
