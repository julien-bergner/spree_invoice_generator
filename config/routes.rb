Spree::Core::Engine.routes.draw do
  match '/invoice/show/:order_id' => 'invoice#show', :as => :pdf_invoice, via: [:get, :post] 
end
