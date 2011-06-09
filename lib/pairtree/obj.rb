module Pairtree  
  class Obj < ::Dir
    
    # Alias certain class methods from File to instance methods of Pairtree::Obj
    # Methods that require a filename, 0..n additional args, and maybe a block
    FILE_METHODS = [:atime, :open, :read, :file?, :directory?, :exist?, :exists?, :file?, :ftype, :lstat, 
      :mtime, :readable?, :size, :stat, :truncate, :writable?, :zero?]
    FILE_METHODS.each do |file_method|
      define_method file_method do |fname,*args,&block|
        File.send(file_method, File.join(self.path, fname), *args, &block)
      end
    end

    # Methods that require multiple filenames
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
    
    # Methods that require non-filename args, followed by filenames
    def utime atime, mtime, *args
      File.utime(atime, mtime, *(prepend_filenames(args)))
    end
    
    # Alias File.open to Pairtree::Obj#file
    def file fname, *args, &block
      File.open(File.join(self.path, fname), *args, &block)
    end
    
    # Override Dir#entries and Dir#each to remove the dotfiles
    def entries
      super - ['.','..']
    end
    
    def each &block
      super { |entry| yield(entry) unless entry =~ /^\.{1,2}$/ }
    end
    
    # Basic globbing
    def glob(string, flags = 0)
      entries.select { |entry| File.fnmatch(string, entry, flags) }
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
