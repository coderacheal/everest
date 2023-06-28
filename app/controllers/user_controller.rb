class UserController < ApplicationController

    def index
        @user = current_user
    end

    private

    def category_params
      params.require(:category).permit(:name, :image)
    end
end
