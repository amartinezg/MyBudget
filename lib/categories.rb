module Categories
  def categories
    load_categories.keys
  end

  def sub_categories_for(category)
    load_categories[category]
  end

  private
  def load_categories
    YAML.load_file Rails.root.join('config', 'categories.yaml')
  end
end