class PageController < ApplicationController

  def edit
    locale = get_locale
    @is_default_locale = locale.id === Rails.configuration.gtdinbox_master_locale.id
    @page = Page.find(params[:id])
  end


  def index
    @locale = get_locale
    @pages = Page.locale_or_masterlist(params[:lang])
  end

  def update
    page = Page.find(params[:id])
    page.update_or_translate(params[:lang], params[:page])
    redirect_to pages_url(params[:lang]), :notice => "Page updated"
  end

  private
  def find_or_create
    page = Page.find(params[:id])
  end
end
