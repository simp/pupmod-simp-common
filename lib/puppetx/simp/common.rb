module PuppetX
  module SIMP
    module Common

      # Sort a list of values based on usual human sorting semantics.
      #
      # This regex taken from
      # http://www.bofh.org.uk/2007/12/16/comprehensible-sorting-in-ruby
      #
      def self.human_sort(obj)
        obj.to_s.split(/((?:(?:^|\s)[-+])?(?:\.\d+|\d+(?:\.\d+?(?:[eE]\d+)?(?:$|(?![eE\.])))?))/ms).map { |v|
          begin
            Float(v)
          rescue
            v.downcase
          end
        }
      end

      # Determine whether or not the passed value is a valid hostname.
      def self.hostname?(obj)
        # This regex shamelessly lifted from
        # http://stackoverflow.com/questions/106179/regular-expression-to-match-hostname-or-ip-address
        hname_regex = Regexp.new(/^
          (
            ([a-zA-Z0-9]|
            [a-zA-Z0-9][a-zA-Z0-9\-]*[a-zA-Z0-9])\.
          )*
          (
            [A-Za-z0-9]|
            [A-Za-z0-9][A-Za-z0-9\-]*[A-Za-z0-9]
          )((:|\/)?(\d+))?$/x)

        hname_regex.match(obj)
      end
    end
  end
end
