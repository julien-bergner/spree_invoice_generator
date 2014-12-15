module Spree
  class InvoiceController < BaseController

    def show
      order_id = params[:order_id].to_i
      @order = Order.find_by_id(order_id)
      @address = @order.bill_address
      @invoice_print = spree_current_user.has_spree_role?(:admin) ? Spree::Invoice.where(:order_id => order_id, :user_id => @order ? @order.user_id : nil).first_or_create : spree_current_user.invoices.where(:order_id => order_id).first_or_create
      if @invoice_print
        respond_to do |format|
          format.pdf  { send_data @invoice_print.generate_pdf, :filename => "#{@order.number}.pdf", :type => 'application/pdf' }
          format.html { render :file => SpreeInvoice.invoice_template_path.to_s, :layout => false }
        end
      else
        if spree_current_user.has_spree_role?(:admin)
          return redirect_to(admin_orders_path, :notice => t(:no_such_order_found, :scope => :spree))
        else
          return redirect_to(orders_path, :alert => t(:no_such_order_found, :scope => :spree))
        end
      end
    end
  end
end
