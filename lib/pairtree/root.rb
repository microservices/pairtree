require 'find'
require 'fileutils'
module Pairtree
  class Root
    SHORTY_LENGTH = 2

    attr_reader :root
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
        Find.find(*Dir.entries('.').reject { |x| x =~ /^\./ }) do |path|
          if File.directory? path
            Find.prune if File.basename(path).length > @shorty_length
  	        objects << path if Dir.entries(path).any? { |f| f.length > @shorty_length or File.file? File.join(path, f) }
  	        next
          end
  	    end
      end

      objects.map { |x| @prefix + Pairtree::Path.path_to_id(x) }
    end

    def path_for id
      unless id.start_with? @prefix
        raise IdentifierException, "Identifier must start with #{@prefix}"
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
      if exists?
        Pairtree::Path.remove!(path_for(id))
      end
      not exists?
    end

    private

    def pairtree_root
      Dir.new @root
    end

    def pairtree_root? path = @root
      File.directory? path
    end
  end
end
