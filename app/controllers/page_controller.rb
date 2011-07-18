class PageController < ApplicationController

  def edit
    locale = get_locale
    debugger
    @page = fetch_one(locale)
  end


  def index
    @locale = get_locale
    @pages = Page.where(:locale_id => @locale.id)
  end

  def update
    locale = get_locale
    page = fetch_one(locale)
    page.save
    redirect_to :action => 'show'
  end

  private
  def fetch_one(locale)
    Page.where(
      :id => params[:id]
    ).first
  end
end
