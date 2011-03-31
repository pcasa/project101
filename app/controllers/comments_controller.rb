class CommentsController < ApplicationController
  
  
  def index
    @comments = Comment.all
  end
  
  def show
    @comment = Comment.find(params[:id])
  end

  def new
    @comment = Comment.new
  end
  
  def create
    @comment = Comment.new(params[:comment])
    if @comment.save
      
      flash[:notice] = "Successfully created comment."
      respond_to do |format|  
        format.html { 
          if @comment.commentable == current_company
            redirect_to company_dashboard_url(current_company)
          else
            redirect_to [current_company, @comment.commentable]
          end
          
        }  
        format.js if request.xhr? {
          respond_with(@comment)
        }
      end
    else
      redirect_to company_dashboard_url(current_company), :notice => "It Failed"
    end
  end
  
  
  def destroy
    @comment = Comment.find(params[:id])
    @comment.destroy
    respond_to do |format|  
      format.html { redirect_to [current_company, @comment.commentable], :notice => "Successfully destroyed comment." }  
      format.js if request.xhr?
    end
  end

  
end