class OrderMailer < ApplicationMailer
  def notify_order_placed(order)
    @order = order
    @user = @order.user
    @order_items = @order.items
    @order_info = @order.info

    mail(to: @user.email, subject: "[Artstore] Thank you for the order, this is your order details #{order.token}")
  end
end
