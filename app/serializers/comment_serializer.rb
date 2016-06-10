class CommentSerializer < ActiveModel::Serializer
  attributes :id ,:content_less  ,:email , :up_votes , :down_votes

  def up_votes
    Vote.where(comment_id: object.id,up:true).count || 0
  end

  def down_votes
    Vote.where(comment_id: object.id,up:false).count || 0
  end
end
