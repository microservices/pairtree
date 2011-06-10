require 'pairtree/identifier'
require 'pairtree/path'
require 'pairtree/obj'
require 'pairtree/root'

require 'fileutils'

module Pairtree
  class IdentifierError < Exception; end
  class PathError < Exception; end
  class VersionMismatch < Exception; end

  SPEC_VERSION = 0.1
  
  ##
  # Instantiate a pairtree at a given path location
  # @param [String] path The path in which the pairtree resides
  # @param [Hash] args Pairtree options
  # @option args [String] :prefix (nil) the identifier prefix used throughout the pairtree
  # @option args [String] :version (Pairtree::SPEC_VERSION) the version of the pairtree spec that this tree conforms to
  # @option args [Boolean] :create (false) if true, create the pairtree and its directory structure if it doesn't already exist
  def self.at path, args = {}
    args = { :prefix => nil, :version => nil, :create => false }.merge(args)
    args[:version] ||= SPEC_VERSION
    args[:version] = args[:version].to_f
    
    root_path = File.join(path, 'pairtree_root')
    prefix_file = File.join(path, 'pairtree_prefix')
    version_file = File.join(path, pairtree_version_filename(args[:version]))
    existing_version_file = Dir[File.join(path, "pairtree_version*")].sort.last
    
    if args.delete(:create)
      if File.exists?(path) and not File.directory?(path)
        raise PathError, "#{path} exists, but is not a valid pairtree root"
      end
      FileUtils.mkdir_p(root_path)

      unless File.exists? prefix_file
        File.open(prefix_file, 'w') { |f| f.write(args[:prefix].to_s) }
      end
      
      if existing_version_file
        if existing_version_file != version_file
          stored_version = existing_version_file.scan(/([0-9]+)_([0-9]+)/).flatten.join('.').to_f
          raise VersionMismatch, "Version #{args[:version]} specified, but #{stored_version} found."
        end
      else
        args[:version] ||= SPEC_VERSION
        version_file = File.join(path, pairtree_version_filename(args[:version]))
        File.open(version_file, 'w') { |f| f.write %{This directory conforms to Pairtree Version #{args[:version]}. Updated spec: http://www.cdlib.org/inside/diglib/pairtree/pairtreespec.html} }
        existing_version_file = version_file
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

    stored_version = existing_version_file.scan(/([0-9]+)_([0-9]+)/).flatten.join('.').to_f
    args[:version] ||= stored_version
    unless args[:version] == stored_version
      raise VersionMismatch, "Version #{args[:version]} specified, but #{stored_version} found."
    end
        
    Pairtree::Root.new(File.join(path, 'pairtree_root'), args)
  end

  private
  def self.pairtree_version_filename(version)
    "pairtree_version#{version.to_s.gsub(/\./,'_')}"
  end
end
