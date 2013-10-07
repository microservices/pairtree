# pairtree

Ruby implementation of the [Pairtree](https://confluence.ucop.edu/display/Curation/PairTree) microservice specification from the California Digital Library.

# Usage

```ruby
  # Initiate a tree
  pairtree = Pairtree.at('./data', :prefix => 'pfx:', :create => true)
  
  # Create a ppath
  obj = pairtree.mk('pfx:abc123def')
  
  # Access an existing ppath
  obj = pairtree['pfx:abc123def']
  obj = pairtree.get('pfx:abc123def')
  
  # ppaths are Dir instances with some File and Dir class methods mixed in
  obj.read('content.xml')
  => "<content/>"
  obj.open('my_file.txt','w') { |io| io.write("Write text to file") }
  obj.entries
  => ["content.xml","my_file.txt"]
  obj['*.xml']
  => ["content.xml"]
  obj.each { |file| ... }
  obj.unlink('my_file.txt')
  
  # Delete a ppath and all its contents
  pairtree.purge!('pfx:abc123def')
```
  
##  Copyright

Copyright (c) 2010 Chris Beer. See LICENSE.txt for
further details.

