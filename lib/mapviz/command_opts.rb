# frozen_string_literal: true

module Mapviz
  # Mapping row converted to Object with a method created for each Hash key
  class CommandOpts < Thor
    class << self
      def shared_options_config
        {
          exclude_omitted: {
            default: true,
            aliases: "-o",
            type: :boolean
          },
          exclude_unmapped: {
            default: true,
            aliases: "-u",
            type: :boolean
          }
        }
      end

      def shared_options(*option_names)
        option_names.each do |option_name|
          opt = shared_options_config[option_name]
          if opt.nil?
            raise "Tried to access shared option '#{option_name}' but it "\
              "was not previously defined"
          end

          option option_name, opt
        end
      end

      def shared_option(option_name, **overrides)
        opt = shared_options_config[option_name]
        if opt.nil?
          raise "Tried to access shared option '#{option_name}' but it "\
            "was not previously defined"
        end

        option option_name, opt.merge(overrides)
      end
    end
  end
end
