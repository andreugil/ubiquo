module Ubiquo::CategoriesHelper

  def category_filters
    filters_for 'Category' do |f|
      f.text
      uhook_category_filters f
    end
  end

  def category_list(collection, pages, options = {})
    render(:partial => "shared/ubiquo/lists/standard", :locals => {
        :name => 'category',
        :headers => [:name, :description],
        :rows => collection.collect do |category|
          {
            :id => category.id,
            :columns => [
              category.name,
              category.description,
            ],
            :actions => uhook_category_index_actions(options[:category_set], category)
          }
        end,
        :pages => pages,
        :hide_actions => !options[:category_set].is_editable?,
        :link_to_new => (
          link_to(
            t("ubiquo.category.index.new"),
            ubiquo.new_category_set_category_path(params[:category_set_id]), :class => 'new'
          ) if options[:category_set].is_editable?)
      })
  end

  def category_view_link(category, category_set)
    link_to(t("ubiquo.view"), [ubiquo, category_set, category])
  end

  def category_remove_link(category, category_set)
    link_to(t('ubiquo.remove'), [ubiquo, category_set, category], :data => {:confirm => t("ubiquo.category.index.confirm_removal")}, :method => :delete, :class => 'btn-delete')
  end

  def category_edit_link(category, category_set)
    link_to(t("ubiquo.edit"), [ubiquo, :edit, category_set, category], :class => 'btn-edit')
  end

end
