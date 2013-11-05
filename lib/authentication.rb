require 'authentication/controller'
require 'authentication/model'

module Authentication
  def self.included(base)
    base.send(:include, Controller) if base < ActionController::Base
    base.send(:include, Model) if base < ActiveRecord::Base
  end
end
