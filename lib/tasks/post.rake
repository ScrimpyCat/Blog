namespace :post do
    POST_DIR = "#{Rails.root}/app/assets/posts"

    desc "Create a new post"
    task :create, [:file] do |t, args|
        if filename = args[:file]
            if !Dir.exists?(POST_DIR) then Dir.mkdir(posts) end
            if !File.exists?(file = "#{POST_DIR}/#{filename}.post")
                File.write(file,
                    """
                    ---
                    title: 
                    author: 
                    date: #{DateTime.now}
                    series: 
                    tags: 
                    ---
                    """.strip.gsub(/^[[:blank:]]*/, ''))

                puts "Created post: #{file}"
            else
                puts "Error: Already exists. #{file}"
            end
        else
            puts "Error: Missing filename of the post. #{t}[filename]"
        end
    end

    desc "Insert post into database"
    task :insert, [:file] => :environment do |t, args|
        if filename = args[:file]
            if !Post.where('lower(content) = :file', :file => file = (filename + '.post')).first
                if File.exists?(file = "#{POST_DIR}/#{file}")
                    info = AssetTemplate::PostTemplate.extract_info(File.read(file))
                    Post.create_with_info!(info.merge('content' => filename + '.post'))
                else
                    puts "Error: File does not exist. post:create[#{filename}]"
                end
            else
                puts "Error: Already exists. Use post:update[#{filename}] instead"
            end
        else
            puts "Error: Missing filename of the post. #{t}[filename]"
        end
    end

    desc "Update post in database"
    task :update, [:file] => :environment do |t, args|
        if filename = args[:file]
            if post = Post.where('lower(content) = :file', :file => file = (filename + '.post')).first
                if File.exists?(file = "#{POST_DIR}/#{file}")
                    info = AssetTemplate::PostTemplate.extract_info(File.read(file))
                    Post.where('lower(content) = :file', { :file => filename + '.post' }).first.update_with_info!(info.merge('content' => filename + '.post'))
                else
                    puts "Error: File does not exist. To remove the database reference use post:remove[#{filename}]"
                end
            else
                puts "Error: Not added. Use post:insert[#{filename}] first"
            end
        else
            puts "Error: Missing filename of the post. #{t}[filename]"
        end
    end

    desc "Remove post from database"
    task :remove, [:file] => :environment do |t, args|
        if filename = args[:file]
            if post = Post.where('lower(content) = :file', :file => file = (filename + '.post')).first
                post.destroy
            else
                puts "Warning: No database reference exists for #{filename}"
            end
        else
            puts "Error: Missing filename of the post. #{t}[filename]"
        end
    end

    desc "Delete post"
    task :delete, [:file] => :environment do |t, args|
        if filename = args[:file]
            if !Post.where('lower(content) = :file', :file => file = (filename + '.post')).first
                if File.exists?(file = "#{POST_DIR}/#{filename}.post")
                    File.delete(file)
                    puts "Deleted post: #{file}"
                else
                    puts "Error: File does not exist. #{file}"
                end
            else
                puts "Error: Database reference exists for #{filename}. Remove that reference first post:remove[#{filename}]"
            end
        else
            puts "Error: Missing filename of the post. #{t}[filename]"
        end
    end
end
