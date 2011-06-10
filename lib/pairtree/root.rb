require 'fileutils'
module Pairtree
  class Root
    SHORTY_LENGTH = 2

    attr_reader :root, :prefix
    
    def initialize root, args = {}
      @root = root
      
      @shorty_length = args.delete(:shorty_length) || SHORTY_LENGTH
      @prefix = args.delete(:prefix) || ''

      @options = args
    end

    def list          
      objects = []
      return [] unless pairtree_root? @root

      Dir.chdir(@root) do
        possibles = Dir['**/?'] + Dir['**/??']
        possibles.each { |path|
          contents = Dir.entries(path).reject { |x| x =~ /^\./ }
          objects << path unless contents.all? { |f| f.length <= @shorty_length and File.directory?(File.join(path, f)) }
        }
      end
      objects.map { |x| @prefix + Pairtree::Path.path_to_id(x) }
    end

    def path
      File.dirname(root)
    end
    
    def path_for id
      unless id.start_with? @prefix
        raise IdentifierError, "Identifier must start with #{@prefix}"
      end
      path_id = id[@prefix.length..-1]
      File.join(@root, Pairtree::Path.id_to_path(path_id))
    end
    
    def exists? id
      File.directory?(path_for(id))
    end
    
    def get id
      Pairtree::Obj.new path_for(id)
    end
    alias_method :[], :get
    
    def mk id
      FileUtils.mkdir_p path_for(id)
      get(id)
    end
    
    def purge! id
      if exists?(id)
        Pairtree::Path.remove!(path_for(id))
      end
      not exists?(id)
    end

    def pairtree_root
      Dir.new @root
    end

    def pairtree_root? path = @root
      File.directory? path
    end
  end
end
