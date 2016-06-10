class TopicsController < ApplicationController

  before_action :set_topic, only: [:show, :edit, :update, :destroy ,:comment]
  before_action :authenticate_user! , only: [:comment ,:up_vote ,:down_vote]

  # GET /topics
  # GET /topics.json
  def index
    @topics = Topic.all
  end

  # GET /topics/1
  # GET /topics/1.json
  def show
    @comments = @topic.comments.select(:id ,:content_less ,:email).page(params[:page]).per(10) || []
    if @comments.present?
      @comments.reject { |e|  e.up_votes.count - e.down_votes.count  >= -10 }
    end
    respond_to do |format|
      format.html
      format.json {render json: @comments}
    end
  end

  # GET /topics/new
  def new
  end

  # GET /topics/1/edit
  def edit
  end

  # POST /topics
  # POST /topics.json
  def create

  end

  # PATCH/PUT /topics/1
  # PATCH/PUT /topics/1.json
  def update

  end

  # DELETE /topics/1
  # DELETE /topics/1.json
  def destroy

  end

  def comment
    if current_user.present?
      begin
        data=comment_params
        @comment = @topic.comments.new(
                                      {
                                          content_less: data['content'][0..400],
                                          content_more: data['content'][401..-1] || nil,
                                          email:data[:email]
                                      }
        )
        respond_to do |format|
          if @comment.save
            format.html { redirect_to @topic, notice: 'Comment was saved successfuly' }
            format.json { render :show, status: :created, location: @topic }
          else
            format.html { redirect_to @topic ,alert: 'Unable to save comment' }
            format.json { render json: @comment.errors, status: :unprocessable_entity }
          end
        end
      rescue StandardError=>e
        puts " Error occured: #{e} "
        render json: {msg:' exception occured'}
      end
    else
      redirect_to new_user_session_path, :notice => 'Please Login To Comment'
    end
  end

  def up_vote
    begin
      if current_user.present?
        vote = Vote.find_by(user_id:current_user.id ,comment_id:params[:id].to_i)
        if vote.present?
          if vote.up
            render json: { msg:'Already Upvoted'  }
            return
          else
            vote.up = true
            if vote.save
              render json: { do:1 , change:1 }
              return
            else
              render json: {msg:'error'}
              return
            end
          end
        else
          vote = Vote.new(
              {
                  up:true,
                  user_id:current_user.id,
                  comment_id:params[:id]
              }
          )
          if vote.save
            render json: { do:1 }
            return
          else
            render json: {msg:'error'}
            return
          end
        end
      else
        flash[:alert] = 'Login to vote'
        render json: {msg:'Login first' ,login:1}
        return
      end
    rescue StandardError=>e
      puts " Error occured: #{e} "
      render json: {msg:' exception occured'}
      return
    end

  end
  def down_vote
    begin
      if current_user.present?
        vote = Vote.find_by(user_id:current_user.id ,comment_id:params[:id].to_i)
        if vote.present?
          unless vote.up
            render json: { msg:'Already Downvoted'  }
            return
          else

            if vote.update(up:false)
              render json: { do:1 , change:1 }
              return
            else
              render json: {msg:'error'}
              return
            end
          end
        else
          vote = Vote.new(
              {
                  up:false,
                  user_id:current_user.id,
                  comment_id:params[:id]
              }
          )
          if vote.save
            render json: { do:1 }
            return
          else
            render json: {msg:'error'}
            return
          end
        end
      else
        flash[:alert] = 'Login to vote'
        render json: {msg:'Login first'}
        return
      end
    rescue StandardError=>e
      puts " Error occured: #{e} "
      render json: {msg:' exception occured'}
      return
    end

  end

  def more_comment
    begin
      comment = Comment.find(params[:id].to_i)
      more_content = comment.present? ? comment.content_more: '' || ''
      render json: { more:more_content }
    rescue StandardError=>e
      puts " Error occured: #{e} "
      render json: {msg:' exception occured'}
    end
  end
  private
    # Use callbacks to share common setup or constraints between actions.
    def set_topic
      @topic = Topic.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def topic_params
      params.require(:topic).permit(:name)
    end

    def comment_params
      params.require(:comment).permit(:content,:email)
    end
end
