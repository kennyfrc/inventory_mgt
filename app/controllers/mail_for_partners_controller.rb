class MailForPartnersController < ApplicationController
  def new
    @mail_for_partner = MailForPartner.new
    @purchase_order = PurchaseOrder.new
    @sales_order = SalesOrder.new
  end

  def create
    if params[:sales_order_id].nil? || params[:purchase_order_id]
      @order = PurchaseOrder.find(params[:purchase_order_id])
    else
      @order = SalesOrder.find(params[:sales_order_id])
    end

    if @order.class == SalesOrder.new.class
      @mail_for_partner = MailForPartner.new(mail_for_partner_params)
      @user = current_user

      respond_to do |format|
        if @mail_for_partner.save
          pdf = SoPdf.new(@order, view_context) # initialize the SalesOrder class # pass an argument as this is required in the class that you've made
          pdf.render_file File.join(Rails.root, "tmp", "x.pdf")
          current_user.certificate = File.open("#{Rails.root}/tmp/x.pdf")
          current_user.save!
          OrderMailer.email_pdf(@mail_for_partner, @user).deliver

          format.html { redirect_to sales_order_mail_for_partner_path(@order, @mail_for_partner), notice: "Successfully sent" }
          format.json { render :show, status: :created, location: @mail_for_partner }
        else
          format.html { render :new }
          format.json { render json: @mail_for_partner.errors, status: :unprocessable_entity }
        end
      end

    elsif @order.class == PurchaseOrder.new.class
      @mail_for_partner = MailForPartner.new(mail_for_partner_params)
      @user = current_user

      respond_to do |format|
        if @mail_for_partner.save
          pdf = PoPdf.new(@order, view_context) # initialize the PurchaseOrder class # pass an argument as this is required in the class that you've made
          pdf.render_file File.join(Rails.root, "tmp", "x.pdf")
          current_user.certificate = File.open("#{Rails.root}/tmp/x.pdf")
          current_user.save!
          OrderMailer.email_pdf(@mail_for_partner, @user).deliver

          format.html { redirect_to purchase_order_mail_for_partner_path(@order, @mail_for_partner), notice: "Successfully sent" }
          format.json { render :show, status: :created, location: @mail_for_partner }
        else
          format.html { render :new }
          format.json { render json: @mail_for_partner.errors, status: :unprocessable_entity }
        end
      end
    end
  end

  def show
    @mail_for_partner = MailForPartner.find(params[:id])
  end

  private

    def mail_for_partner_params
      params.require(:mail_for_partner).permit(:email, :subject, :content, :user_id)
    end

end
