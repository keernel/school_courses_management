module Searchable
  extend ActiveSupport::Concern

  module ClassMethods
    def filter(filter_params)
      filter_params_keys = filter_params.symbolize_keys
      results = self.where(nil)
      filter_params_keys.each do |key, value|
        if key.match(/_id$/) # Hack to check if is an association search
          results = results.where(key => value) if value.present?
        else
          results = results.where(self.arel_table[key].matches("%#{value}%")) if value.present?
        end
      end
      return results
    end
  end
end
