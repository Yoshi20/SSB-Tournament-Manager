# frozen_string_literal: true
{
  de: {
    number: {
      nth: {
        ordinals: lambda do |_key, number:, **_options|
          abs_number = number.to_i.abs
          "."
        end,

        ordinalized: lambda do |_key, number:, **_options|
          "#{number}#{ActiveSupport::Inflector.ordinal(number)}"
        end
      }
    }
  }
}
