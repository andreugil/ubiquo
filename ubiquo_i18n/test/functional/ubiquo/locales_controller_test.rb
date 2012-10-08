require File.dirname(__FILE__) + "/../../test_helper"

class Ubiquo::LocalesControllerTest < ActionController::TestCase

  def teardown
    Locale.current = nil
  end

  def test_should_get_show
    assert_not_equal 0, Locale.count
    get :show
    assert_response :success
    assert_not_nil locales = assigns(:locales)
    assert_equal Locale.count, locales.size
  end

  def test_should_update_locales
    assert_not_equal 0, Locale.count
    Locale.update_all :is_active => false
    Locale.update_all :is_default => false
    Locale.first.update_column :is_default, true

    assert_equal [], Locale.active

    selected_locales = Locale.ordered[1..2].map{|l|l.id.to_s}
    default_locale = Locale.ordered[1].id.to_s

    put :update, :selected_locales => selected_locales, :default_locale => default_locale
    assert_redirected_to ubiquo.locales_path

    assert_equal 2, Locale.active.size
    assert_equal Locale.ordered[1].iso_code, Locale.default

  end

  def test_shouldnt_update_locales_if_default_is_not_selected
    previous_default = Locale.default
    selected_locales = Locale.ordered[1..2].map{|l|l.id.to_s}
    default_locale = Locale.ordered[0].id.to_s

    put :update, :selected_locales => selected_locales, :default_locale => default_locale
    assert_redirected_to ubiquo.locales_path

    assert_not_equal previous_default, default_locale
    assert_equal previous_default, Locale.default

  end

  def test_should_have_use_fallbacks_to_true_as_its_an_ubiquo_controller
    Locale.use_fallbacks = false
    get :show
    assert Locale.use_fallbacks
  end

end
