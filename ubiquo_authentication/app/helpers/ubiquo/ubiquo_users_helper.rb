module Ubiquo::UbiquoUsersHelper

  def ubiquo_user_filters
    filters_for 'UbiquoUser' do |f|
      f.text if Ubiquo::Settings.context(:ubiquo_authentication).get(:ubiquo_users_string_filter_enabled)
      f.boolean(:admin, {
        :caption       => t('ubiquo.auth.user_type'),
        :caption_true  => t('ubiquo.auth.user_admin'),
        :caption_false => t('ubiquo.auth.user_non_admin'),
      }) if Ubiquo::Settings.context(:ubiquo_authentication).get(:ubiquo_users_admin_filter_enabled)
    end
  end

  #renders the ubiquo_user list
  def ubiquo_user_list(collection, pages, options = {}, &block)
    render(:partial => "shared/ubiquo/lists/boxes", :locals => {
      :name => 'ubiquo_user',
      :rows => collection.collect do |ubiquo_user|
        {
          :id => ubiquo_user.id,
          :content => capture(ubiquo_user, &block),
          :actions => ubiquo_user_actions(ubiquo_user)
        }
      end,
      :pages => pages,
      :link_to_new => link_to(t("ubiquo.auth.new_user"),
                      ubiquo.new_ubiquo_user_path, :class => 'new')
    })
  end

  private

  #return the actions related to an ubiquo_user
  def ubiquo_user_actions(ubiquo_user, options = {})
    [
      link_to(t("ubiquo.edit"), ubiquo.edit_ubiquo_user_path(ubiquo_user), :class => "btn-edit"),
      link_to(t("ubiquo.remove"), ubiquo.ubiquo_user_path(ubiquo_user),
        :data => {:confirm => t("ubiquo.auth.confirm_user_removal")},
        :method => :delete, :class => "btn-delete")
    ]
  end

end
