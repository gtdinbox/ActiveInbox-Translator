class MessagesController < ApplicationController


  def show
    default_locale = Rails.configuration.gtdinbox_master_locale
    params[:lang] = 'it'
    locale = if params.has_key?(:lang)
              Locale.find_by_lang_code(params[:lang])
             else
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

    unless message
       raise "missing record"
      else
       message.save
    end
    message.to_json
  end
end
