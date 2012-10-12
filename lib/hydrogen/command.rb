module Hydrogen
  class Command < Thor
    class << self
      def description(banner)
        @description = banner
      end

      def description_banner
        @description
      end

      def usage(banner)
        @usage_banner = banner
      end

      def usage_banner
        @usage_banner
      end
    end
  end
end
