require 'open-uri'
require 'set'

module Fidelius
  ##
  # List validator
  # Uses leaked password list to match against input
  class List < Validator
    def initialize(params = {})
      @uri = params[:uri] || raise('No source provided for list')
    end

    def validate(password)
      return { safe: true } unless list.include? password
      { safe: false, reason: 'Password included in compromised lists' }
    end

    private

    def list
      @list ||= open(@uri) do |fh| # rubocop:disable Security/Open
        fh.each_line.each_with_object(Set.new) do |line, set|
          set << line.strip
        rescue ArgumentError
          nil
        end
      end
    end
  end
end
