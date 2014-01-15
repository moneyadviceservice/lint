module Mas
  module Lint

    class CssErrorParser

      def parse(raw_errors)
        error_messages = ErrorMessage.from_collection(@raw_errors)
        error_messages
      end

      private

      def build_messages
        split_errors_and_warings.map do |errors_or_warnings|
          errors_or_warnings.map do |error_or_warning|
            format_message(error_or_warning)
          end
        end
      end

    end

  end
end
