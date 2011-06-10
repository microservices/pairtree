module Pairtree
  class Identifier
    ENCODE_REGEX = Regexp.compile("[\"*+,<=>?\\\\^|]|[^\x21-\x7e]", nil, 'u')
    DECODE_REGEX = Regexp.compile("\\^(..)", nil, 'u')

    ##
    # Encode special characters within an identifier
    # @param [String] id The identifier
    def self.encode id
      id.gsub(ENCODE_REGEX) { |c| char2hex(c) }.tr('/:.', '=+,')
    end

    ##
    # Decode special characters within an identifier
    # @param [String] id The identifier
    def self.decode id
      id.tr('=+,', '/:.').gsub(DECODE_REGEX) { |h| hex2char(h) } 
    end

    ##
    # Convert a character to its pairtree hexidecimal representation
    # @param [Char] c The character to convert
    def self.char2hex c
      c.unpack('H*')[0].scan(/../).map { |x| "^#{x}"}
    end

    ##
    # Convert a pairtree hexidecimal string to its character representation
    # @param [String] h The hexidecimal string to convert
    def self.hex2char h
       '' << h.delete('^').hex
    end
  end
end
