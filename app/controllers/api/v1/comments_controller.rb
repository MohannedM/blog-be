module Api
	module V1
		class CommentsController < ApplicationController
			      before_action :authorized

			def create

				@comment = Comment.new(comment_params)

				if decoded_token
					@comment.usr_id = decoded_token[0]['user_id']
				end

				if @comment.save
					render json: @comment, status: :created
				else
					render json: @comment.errors, status: :unprocessable_entity
				end
			end

			def destroy
				if Comment.exists?(params[:id])
					@comment = Comment.find(params[:id])
					if @comment.usr_id == decoded_token[0]['user_id']
						if @comment.destroy
							head( status: :no_content)
						else
						    head(:unproccassable_entity)
					    end
				    else
					    render json: {error: "You not allow to delete this comment"}
				    end

				else
					render json: {error: "This comment is not exist"}
					end
				end

			    def update
			    	if Comment.exists?(params[:id])
			    		@comment = Comment.find(params[:id])
			    		if @comment.usr_id == decoded_token[0]['user_id']
			    			@comment.body=params[:body]
			    			if @comment.save
			    				render json: @comment, status: :ok
			    			else
			    				render json: @comment.errors, status: :unprocessable_entity
			    			end
			    		else
			    			render json: {error: "You not allow to update this comment"}
			    		end
			    	else
			    		render json: {error: "This comment not exist"}
			    	end
			    end


				private

				def comment_params
					params.permit(:body, :post_id)
				end

		end
	end
end
