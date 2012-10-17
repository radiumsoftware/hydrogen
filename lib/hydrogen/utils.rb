module Hydrogen
  class Utils
    class << self
      def underscore(str)
        return str.downcase if str =~ /^[A-Z_]+$/
        str.gsub(/\B[A-Z]/, '_\&').squeeze('_') =~ /_*(.*)/
        return $+.downcase
      end

      def class_name(klass)
        klass.to_s.split("::").last
      end
    end
  end
end
