# frozen_string_literal: true

require 'active_support/core_ext/module'

class Session
  include Singleton

  attr_accessor :s

  class << self
    delegate :s, to: :instance
  end

  def initialize
    @s = {}
  end
end
