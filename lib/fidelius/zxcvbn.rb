require 'zxcvbn'

module Fidelius
  ##
  # Complexity validator
  # Checks password for repetition, patterns, and other weakness
  class Zxcvbn < Validator
    def validate(password)
      results = ::Zxcvbn.test(password)
      return { safe: true } if results.score == 4
      time = results.crack_time_display
      time = 'an instant' if time == 'instant'
      { safe: false, reason: "Password vulnerable to brute force in #{time}" }
    end
  end
end
