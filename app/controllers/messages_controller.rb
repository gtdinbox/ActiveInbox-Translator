class MessagesController < ApplicationController


  def index
    locale = get_locale

    unless locale
      raise "Undefined locale"
    else
      @messages = Message.locale_with_masterlist(locale.id)
    end
  end

  def update
    message = Message.find_by_id(params[:id])

    if message
       message.value = params[:value]
       message.in_sync = true
       message.save
      else
       rise "Record not found"
    end
    render :json => Message.translation_stats(message.locale)
  end

  def create
    locale = Locale.find_by_lang_code(params[:lang])
    message = Message.create(
      :locale_id => locale.id,
      :name => params[:name],
      :value => params[:value]
    )
    render :json => Message.translation_stats(locale)
  end
end
