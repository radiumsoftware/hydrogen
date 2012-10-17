module Hydrogen
  class Command < Thor
    class << self
      def description(banner = nil)
        @description = banner if banner
        @description
      end
    end
  end
end
