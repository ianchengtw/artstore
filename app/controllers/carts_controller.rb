class CartsController < ApplicationController
  before_action :authenticate_user!, only: [:checkout]

  def index
  end

  def checkout
    @order = current_user.orders.build
    @info = @order.build_info
  end

  def empty
    current_cart.empty!
    flash[:warning] = 'Cart Emptied'
    redirect_to carts_path
  end
end
