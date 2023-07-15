module ExpensesHelper
    def generate_color(category_name)
        @color_cache ||= {}
        @color_cache[category_name] ||= generate_random_color
      end
    
      private
    
      def generate_random_color
        pastel_colors = ['#ffb6c1', '#b0e0e6', '#98fb98', '#e6e6fa']
        unused_colors = pastel_colors - @color_cache.values
        if unused_colors.empty?
          @color_cache.clear
          unused_colors = pastel_colors
        end
        color = unused_colors.sample
        @color_cache.invert[color] = color
      end
end
