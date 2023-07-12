class Transaction < ApplicationRecord
  validates_presence_of :time, :status
end
