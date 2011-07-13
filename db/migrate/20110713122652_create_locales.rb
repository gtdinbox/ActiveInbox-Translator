class CreateLocales < ActiveRecord::Migration
  def self.up
    create_table :locales do |t|
      t.string :name
      t.string :lang_code
      t.boolean :is_master
      t.timestamps
    end

    %w[ar bg bn-IN bs ca cs cy da de de-AT de-CH
    dsb el en-AU en-GB en-US eo es es-AR es-CL
    es-CO es-MX es-PE et eu fa fi fr fr-CA fr-CH
    fur gl-ES gsw-CH he hi-IN hr hsb hu id is
    it ja kn ko lo lt lv mk mn nb nl nn pl
    pt-BR pt-PT rm ro ru sk sl sr sr-Latn sv-SE
    sw th tr uk vi zh-CN zh-TW].collect {
      |lang_code| lang_code.gsub('-','_')

    }.each do |lang_code|
      puts "creating.." + lang_code
      Locale.create :lang_code => lang_code,
                    :is_master => lang_code === 'en_US'

    end
  end

  def self.down
    drop_table :locales
  end
end
