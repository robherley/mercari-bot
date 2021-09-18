# frozen_string_literal: true

class Database
  attr_reader :file, :connection

  def initialize(file:)
    setup_database file
    migrate
  end

  private

  def setup_database(file)
    @file = File.expand_path(file).freeze

    ActiveRecord::Base.logger = Logger.new($stderr)

    @connection = ActiveRecord::Base.establish_connection(
      adapter: 'sqlite3',
      database: @file
    )
  end

  def migrate
    ActiveRecord::Schema.define do
      create_table :items, if_not_exists: true do |t|
        t.string  :mercari_id, null: false, index: { unique: true }
        t.string  :href
        t.string  :sendico_url
        t.string  :img
        t.string  :price_usd
        t.string  :price_jpy
        t.string  :description
        t.boolean :sold
        t.timestamps
      end
    end
  end
end

