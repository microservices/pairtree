module Pairtree  
  class Obj < ::Dir
    
    FILE_METHODS = [:atime, :open, :read, :file?, :directory?, :exist?, :exists?, :file?, :ftype, :lstat, 
      :mtime, :readable?, :size, :stat, :truncate, :writable?, :zero?]
    FILE_METHODS.each do |file_method|
      define_method file_method do |fname,*args,&block|
        File.send(file_method, File.join(self.path, fname), *args, &block)
      end
    end

    def delete *args
      File.delete(*(prepend_filenames(args)))
    end
    alias_method :unlink, :delete

    def link *args
      File.link(*(prepend_filenames(args)))
    end

    def rename *args
      File.rename(*(prepend_filenames(args)))
    end
    
    def utime atime, mtime, *args
      File.utime(atime, mtime, *(prepend_filenames(args)))
    end
    
    def entries
      super - ['.','..']
    end
    
    def each &block
      super { |entry| yield(entry) unless entry =~ /^\.{1,2}$/ }
    end
    
    def glob(string, flags = 0)
      result = Dir.glob(File.join(self.path, string), flags) - ['.','..']
      result.collect { |f| f.sub(%r{^#{self.path}/},'') }
    end
    
    def [](string)
      glob(string, 0)
    end
    
    private
    def prepend_filenames(files)
      files.collect { |fname| File.join(self.path, fname) }
    end
    
  end
end
