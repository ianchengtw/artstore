class OrdersController < ApplicationController
  before_action :authenticate_user!, except: :pay2go_cc_notify
  protect_from_forgery except: :pay2go_cc_notify

  def show
    @order = Order.find_by_token(params[:id])
    @order_info = @order.info
    @order_items = @order.items
  end

  def create
    @order = current_user.orders.build(order_params)

    if @order.save
      @order.build_item_cache_from_cart(current_cart)
      @order.calculate_total!(current_cart)
      current_cart.empty!
      # OrderMailer.notify_order_placed(@order).deliver!

      redirect_to order_path(@order.token)
    else
      flash[:warning] = 'Order information is incorrect.'
      render 'carts/checkout'
    end
  end

  def pay_with_credit_card
    @order = Order.find_by_token(params[:id])
    @order.reserve_goods!
    @order.set_payment_with!('credit_card')
    @order.make_payment!
    redirect_to order_path(@order.token), notice: 'Pay successfully'
  end

  def pay_with_atm
    @order = Order.find_by_token(params[:id])
    @order.reserve_goods!
    @order.set_payment_with!('atm')
    @order.make_payment!
    redirect_to order_path(@order.token), notice: 'Pay successfully'
  end

  def pay2go_cc_notify
    @order = Order.find_by_token(params[:id])

    if params['Status'] == 'SUCCESS'
      @order.reserve_goods!
      @order.set_payment_with!('credit_card')
      @order.make_payment!

      if @order.is_paid?
        flash[:notice] = 'Pay with credit card successfully'
        redirect_to account_orders_path
      else
        render text: 'Pay with credit card failed'
      end
    else
      render text: 'Trade failed'
    end
  end

  private
    def order_params
      params.require(:order).permit(info_attributes: [:billing_name,
                                                      :billing_address,
                                                      :shipping_name,
                                                      :shipping_address])
    end
end
