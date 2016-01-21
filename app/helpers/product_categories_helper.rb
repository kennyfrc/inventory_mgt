module ProductCategoriesHelper

  def category_select
    categories = ProductCategory.all.map{|pc| [pc.category.capitalize,pc.id]}
    categories << ['Other','other']
  end

end
