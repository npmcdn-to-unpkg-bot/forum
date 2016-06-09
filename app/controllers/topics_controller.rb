class TopicsController < ApplicationController

  before_action :set_topic, only: [:show, :edit, :update, :destroy ,:comment]

  # GET /topics
  # GET /topics.json
  def index
    @topics = Topic.all
  end

  # GET /topics/1
  # GET /topics/1.json
  def show
    @comments = Topic.find(params[:id]).comments || []
  end

  # GET /topics/new
  def new
    @topic = Topic.new
  end

  # GET /topics/1/edit
  def edit
  end

  # POST /topics
  # POST /topics.json
  def create
    @topic = Topic.new(topic_params)

    respond_to do |format|
      if @topic.save
        format.html { redirect_to @topic, notice: 'Topic was successfully created.' }
        format.json { render :show, status: :created, location: @topic }
      else
        format.html { render :new }
        format.json { render json: @topic.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /topics/1
  # PATCH/PUT /topics/1.json
  def update
    respond_to do |format|
      if @topic.update(topic_params)
        format.html { redirect_to @topic, notice: 'Topic was successfully updated.' }
        format.json { render :show, status: :ok, location: @topic }
      else
        format.html { render :edit }
        format.json { render json: @topic.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /topics/1
  # DELETE /topics/1.json
  def destroy
    @topic.destroy
    respond_to do |format|
      format.html { redirect_to topics_url, notice: 'Topic was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def comment
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
  end

  def vote
    begin
      if current_user.present?
        ucount = dcount = 0
        vote = Vote.find_by(user_id:current_user.id ,comment_id:params[:id].to_i)
        ucount = Comment.find(params[:id]).up_votes.count
        dcount = Comment.find(params[:id]).down_votes.count
        if vote.present?
          if params[:up] == 'true'
            up = true
          elsif params[:up] == 'false'
            up = false
          else
            render json: {msg:'error'}
            return
          end
          if vote.up  == up
            render json: { do:0 ,more:ucount  }
            return
          else
            vote.up = up
            if vote.save
              render json: { do:1 ,more: ucount+1 }
              return
            else
              render json: {msg:'error'}
              return
            end
          end
        else
          if params[:up] == 'true'
            up = true
          elsif params[:up] == 'false'
            up = false
          else
            render json: {msg:'error'}
            return
          end
          vote = Vote.new(
                                 {
                                     up:up,
                                     user_id:current_user.id,
                                     comment_id:params[:id]
                                 }
          )
          if vote.save
            render json: { do:1,more: ucount+1  }
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
