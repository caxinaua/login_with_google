# frozen_string_literal: true

require 'erb'

module LoginWithGoogle
  class << self
    def config
      project_config.any? ? project_config : yaml_load(default_config_path)
    end

    private

    def yaml_load(path)
      template = ERB.new(File.new(path).read)
      YAML.safe_load(template.result, aliases: true)[ENV.fetch('RAILS_ENV', 'development')]
    end

    def project_config
      @project_tools ||= yaml_load(project_config_path) || {}
    rescue Errno::ENOENT
      {}
    end

    def default_config_path
      File.expand_path('../../config/google_login.yml', __dir__)
    end

    def project_config_path
      "#{Dir.pwd}/config/google_login.yml"
    end
  end
end
