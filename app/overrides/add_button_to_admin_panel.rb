# Admin Panel buttons
Deface::Override.new(:virtual_path => %q{spree/admin/orders/index},
                     :insert_before => "[data-hook='admin_orders_index_header_actions']",
                     :name => "invoice_print_header",
                     :text => "<th><%= t(:invoice, :scope => :spree) %></th>")

Deface::Override.new(:virtual_path => %q{spree/admin/orders/index},
                     :insert_before => "[data-hook='admin_orders_index_row_actions']",
                     :name => "invoice_print_link",
                     :text => %q{<td><%= link_to "#{image_tag('admin/icons/receipt.png')} #{t(:show, :scope => :spree)}".html_safe, pdf_invoice_path(:order_id => order.id, :format => :pdf), :onclick => "window.open(this.href, '#{t(:invoice, :scope => :spree)}', 'width=745,height=892,left=100,top=100,menubar=no,toolbar=yes,scrollbars=yes,location=no,hotkeys=yes'); return false;" %></td>})

Deface::Override.new(:virtual_path => %q{spree/admin/orders/show},
                     :insert_bottom => "[data-hook='admin_order_show_buttons']",
                     :name => "invoice_print_show_link",
                     :text => %q{<%= button_link_to t(:print_invoice, :scope => :spree), pdf_invoice_path(:order_id => @order.id, :format => :pdf), :icon => 'pdf' %>})
