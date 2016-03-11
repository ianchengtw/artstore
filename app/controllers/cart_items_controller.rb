class CartItemsController < ApplicationController
  def update
    @cart = current_cart
    @item = @cart.cart_items.find_by(product_id: params[:id])

    if @item.product.quantity >= item_params[:quantity].to_i
      @item.update(item_params)
      flash[:notice] = 'Update quantity successfully'
    else
      flash[:warning] = "Don't have enough products to offer"
    end

    redirect_to :back
  end

  def destroy
    @cart = current_cart
    @item = @cart.find_cart_item(params[:id])
    @product = @item.product
    @item.destroy

    flash[:warning] = "#{@product.title} has been removed."
    redirect_to :back
  end

  private
    def item_params
      params.require(:cart_item).permit(:quantity)
    end
end
