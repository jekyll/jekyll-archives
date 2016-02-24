--- archive.rb
+++ (clipboard)
@@ -17,7 +17,6 @@
         name
         path
         url
-        permalink
       ]
 
       # Initialize a new Archive page
@@ -35,19 +34,24 @@
         @config = site.config['jekyll-archives']
 
         # Generate slug if tag or category (taken from jekyll/jekyll/features/support/env.rb)
-        if title.is_a? String
-          @slug = Utils.slugify(title)
+        if title.to_s.length
+          @slug = Utils.slugify(title.to_s)
         end
 
         # Use ".html" for file extension and url for path
         @ext  = File.extname(relative_path)
-        @path = site.in_dest_dir(relative_path)
+        @path = relative_path
         @name = File.basename(relative_path, @ext)
 
         @data = {
           "layout" => layout
         }
         @content = ""
+        
+       # set up dependencies
+        posts.each do |post|
+          site.regenerator.add_dependency(self.path, post.path)
+        end
       end
 
       # The template of the permalink.
@@ -91,10 +95,6 @@
         raise ArgumentError.new "Template \"#{template}\" provided is invalid."
       end
 
-      def permalink
-        data && data.is_a?(Hash) && data['permalink']
-      end
-
       # Add any necessary layouts to this post
       #
       # layouts      - The Hash of {"name" => "layout"}.
@@ -109,15 +109,6 @@
         do_layout(payload, layouts)
       end
 
-      # Add dependencies for incremental mode
-      def add_dependencies
-        archive_path = site.in_dest_dir(relative_path)
-        site.regenerator.add(archive_path)
-        @posts.each do |post|
-          site.regenerator.add_dependency(archive_path, post.path)
-        end
-      end
-      
       # Convert this Convertible's data to a Hash suitable for use by Liquid.
       #
       # Returns the Hash representation of this Convertible.
@@ -169,10 +160,6 @@
         path
       end
 
-      def regenerate?
-        site.regenerator.regenerate?(self)
-      end
-
       # Returns the object as a debug String.
       def inspect
         "#<Jekyll:Archive @type=#{@type.to_s} @title=#{@title} @data=#{@data.inspect}>"
