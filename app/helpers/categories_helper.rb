module CategoriesHelper
    def generate_color(category_name)
      colors = ['#FF0000', '#00FF00', '#0000FF']  # Example color palette
      index = category_name.length % colors.length
      colors[index]
    end
  end
  
