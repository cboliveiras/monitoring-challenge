class Alert < ActiveRecord::Base
  validates_presence_of :time, :status, :message
end
