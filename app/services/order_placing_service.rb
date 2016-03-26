class OrderPlacingService
  def initialize(order, cart)
    @order = order
    @cart = cart
  end

  def place_order!
    @order.build_item_cache_from_cart(@cart)
    @order.calculate_total!(@cart)
    @cart.empty!
    OrderMailer.notify_order_placed(@order).deliver!
  end
end
