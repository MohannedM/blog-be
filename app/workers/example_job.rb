class ExampleJob 
	include Sidekiq::Worker

    #queue_as :default
    def perform
     # do some stuff
     #puts "I am here"
     Post.delete_old_posts.destroy_all
 end
end