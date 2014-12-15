module Spree
  class Invoice < ActiveRecord::Base
    belongs_to :user
    belongs_to :order
    
    before_create :generate_invoice_number
    
    scope :from_current_year, -> { where(["created_at > ? AND created_at < ?", Time.now.at_beginning_of_year, Time.now.at_end_of_year]) }

    #attr_accessible :user, :order, :order_id, :user_id, :invoice_number, :counter

    def generate_pdf
      self.update_attribute(:counter, self.counter + 1)
      WickedPdf.new.pdf_from_string(
        StaticRender.render_erb(SpreeInvoice.invoice_template_path, {
          :@order => self.order,
          :@address => self.order.bill_address,
          :@invoice_print => self
        }), {
          :margin => SpreeInvoice.wkhtmltopdf_margin
        }
      )
    end
    
    private
    def generate_invoice_number
      write_attribute(:invoice_number, SpreeInvoice.invoice_number_generation_method.call(Spree::Invoice.from_current_year.length + 1))
    end
  end
  
  class StaticRender < ActionController::Base
    def self.render_erb(template_path, locals = {})
      view = ActionView::Base.new(ActionController::Base.view_paths, {})
      class << view
        include ApplicationHelper
        include WickedPdfHelper::Assets
        include Spree::BaseHelper
      end
      view.render(:file => template_path, :locals => locals, :layout => nil)
    end
  end
end
