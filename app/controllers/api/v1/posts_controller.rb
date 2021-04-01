module Api
	module V1
		class PostsController < ApplicationController
      before_action :authorized

      def index
        posts = ::Post.all
        render json: PostsRepresenter.new(posts).as_json , status: :success


      def create
        @post = Post.new(:title=>params[:title],:body=>params[:body])
          if decoded_token
          @post.user_id = decoded_token[0]['user_id']
        end

        @post_user=@post.user
        @post_user.tag(@post, :on => :tags,:with => "#{params[:post_tags]}")
        if params[:post_tags] == ""
          render json: {error: "You Should add at least one post tag"}
        else
          if @post.save
            render json: @post, status: :created
          else
            render json: @post.errors, status: :unprocessable_entity
          end
        end
      end

    def destroy
      if Post.exists?(params[:id])
        @post = Post.find(params[:id])
        if @post.user_id == decoded_token[0]['user_id']
          if @post.destroy
            head(:no_content)
          else
            head(:unproccassable_entity)
          end
        else
          render json: {error: "You not allow to delete this post"}
        end
      else
        render json: {error: "This post not exist"}
      end
    end

    def update
      if Post.exists?(params[:id])
        @post = Post.find(params[:id])
        if @post.user_id == decoded_token[0]['user_id']

          @post.title=params[:title]
          @post.body=params[:body]
          @post.tags.destroy_all
          @post.user.tag(@post, :on => :tags,:with => "#{params[:post_tags]}")

          if @post.save
            render json: @post, status: :ok
          else
            render json: @post.errors, status: :unprocessable_entity
          end
          else
            render json: {error: "You not allow to update this post"}
            end
          else
            render json: {error: "This post not exist"}
          end
        end
      end

    def show
    	@post = Post.where(id: params[:id].first)
        render json: @post, status: :ok
    end


  private

  def post_params
	 params.permit(:title, :body, :post_tags)
  end

end
end
end