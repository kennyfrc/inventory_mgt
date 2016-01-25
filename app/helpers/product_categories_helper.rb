module ProductCategoriesHelper

  def array_of_arrays_categories
    categories = ProductCategory.all.map{|pc| [pc.category.capitalize,pc.id]}
    categories << ['New Category','pop_out_form']
  end

end
