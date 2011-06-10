require 'pairtree/identifier'
require 'pairtree/path'
require 'pairtree/obj'
require 'pairtree/root'

require 'fileutils'

module Pairtree
  class IdentifierError < Exception; end
  class PathError < Exception; end
  
  def self.at path, args = {}
    args = { :prefix => nil, :version => nil, :create => false }.merge(args)
    
    root_path = File.join(path, 'pairtree_root')
    prefix_file = File.join(path, 'pairtree_prefix')
    
    
    if args.delete(:create)
      if File.exists?(path) and not File.directory?(path)
        raise PathError, "#{path} exists, but is not a valid pairtree root"
      end
      FileUtils.mkdir_p(root_path)

      unless File.exists? prefix_file
        File.open(prefix_file, 'w') { |f| f.write(args[:prefix].to_s) }
      end
    else
      unless File.directory? root_path
        raise PathError, "#{path} does not point to an existing pairtree"
      end
    end

    stored_prefix = File.read(prefix_file)
    unless args[:prefix].nil? or args[:prefix].to_s == stored_prefix
      raise IdentifierError, "Specified prefix #{args[:prefix].inspect} does not match stored prefix #{stored_prefix.inspect}"
    end
    args[:prefix] = stored_prefix
        
    Pairtree::Root.new(File.join(path, 'pairtree_root'), args)
  end
  
end
