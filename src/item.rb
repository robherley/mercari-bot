# frozen_string_literal: true

class Item < ActiveRecord::Base
  scope :stale, -> { where('updated_at < ?', 1.day.ago) }

  def create_or_touch
    return if sold

    found_item = Item.find_by(mercari_id: mercari_id)
    if found_item.nil?
      save!
    else
      # item is on same page result, update so we don't get cleaned up
      found_item.touch
    end
  end

  def self.cleanup
    stale.destroy_all
  end
end
