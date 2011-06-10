require 'fileutils'
module Pairtree
  class Root
    SHORTY_LENGTH = 2

    attr_reader :root, :prefix
    
    ##
    # @param [String] root The pairtree_root directory within the pairtree home
    # @param [Hash] args Pairtree options
    # @option args [String] :prefix (nil) the identifier prefix used throughout the pairtree
    # @option args [String] :version (Pairtree::SPEC_VERSION) the version of the pairtree spec that this tree conforms to
    def initialize root, args = {}
      @root = root
      
      @shorty_length = args.delete(:shorty_length) || SHORTY_LENGTH
      @prefix = args.delete(:prefix) || ''

      @options = args
    end

    ##
    # Get a list of valid existing identifiers within the pairtree
    # @return [Array]
    def list          
      objects = []
      return [] unless File.directory? @root

      Dir.chdir(@root) do
        possibles = Dir['**/?'] + Dir['**/??']
        possibles.each { |path|
          contents = Dir.entries(path).reject { |x| x =~ /^\./ }
          objects << path unless contents.all? { |f| f.length <= @shorty_length and File.directory?(File.join(path, f)) }
        }
      end
      objects.map { |x| @prefix + Pairtree::Path.path_to_id(x) }
    end

    ##
    # Get the path containing the pairtree_root
    # @return [String]
    def path
      File.dirname(root)
    end
    
    ##
    # Get the full path for a given identifier (whether it exists or not)
    # @param [String] id The full, prefixed identifier
    # @return [String]
    def path_for id
      unless id.start_with? @prefix
        raise IdentifierError, "Identifier must start with #{@prefix}"
      end
      path_id = id[@prefix.length..-1]
      File.join(@root, Pairtree::Path.id_to_path(path_id))
    end

    ##
    # Determine if a given identifier exists within the pairtree
    # @param [String] id The full, prefixed identifier
    # @return [Boolean]
    def exists? id
      File.directory?(path_for(id))
    end
    
    ##
    # Get an existing ppath
    # @param [String] id The full, prefixed identifier
    # @return [Pairtree::Obj] The object encapsulating the identifier's ppath
    def get id
      Pairtree::Obj.new path_for(id)
    end
    alias_method :[], :get
    
    ##
    # Create a new ppath
    # @param [String] id The full, prefixed identifier
    # @return [Pairtree::Obj] The object encapsulating the newly created ppath
    def mk id
      FileUtils.mkdir_p path_for(id)
      get(id)
    end
    
    ##
    # Delete a ppath
    # @param [String] id The full, prefixed identifier
    # @return [Boolean]
    def purge! id
      if exists?(id)
        Pairtree::Path.remove!(path_for(id))
      end
      not exists?(id)
    end

    ##
    # Get the version of the pairtree spec that this pairtree conforms to
    # @return [String]
    def pairtree_version
      @options[:version]
    end
    
  end
end
