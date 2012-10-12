module Hydrogen
  class Utils
    def self.underscore(str)
      return str.downcase if str =~ /^[A-Z_]+$/
      str.gsub(/\B[A-Z]/, '_\&').squeeze('_') =~ /_*(.*)/
      return $+.downcase
    end

    def self.class_name(klass)
      klass.to_s.split("::").last
    end
  end
end
