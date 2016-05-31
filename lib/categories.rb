module Categories
  class InvalidCategoryError < StandardError; end
  class InvalidSubCategoryError < StandardError; end

  def categories
    load_categories.keys
  end

  def valid_category?(category)
    return false unless category
    categories.include?(category)
  end

  def valid_subcategory?(category, subcategory)
    return false unless category && subcategory
    sub_categories_for(category).try(:include?, subcategory)
  end

  def sub_categories_for(category)
    load_categories[category] if valid_category?(category)
  end

  private
  def load_categories
    YAML.load_file Rails.root.join('config', 'categories.yaml')
  end
end