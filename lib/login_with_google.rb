# frozen_string_literal: true

require 'yaml'
require 'login_with_google/version'

module LoginWithGoogle; end

require 'login_with_google/config'
require 'login_with_google/api_base'
require 'login_with_google/google_api'
require 'helper/login_with_google_helper'

ActionView::Base.send :include, LoginWithGoogleHelper if defined?(ActionView)
