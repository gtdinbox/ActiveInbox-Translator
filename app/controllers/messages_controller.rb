class MessagesController < ApplicationController


  def show
    default_locale = Rails.configuration.gtdinbox_master_locale

    locale = if params.has_key?(:lang)
      Locale.find_by_lang_code(params[:lang])
    else
      @is_default_locale = true
      default_locale
    end

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
