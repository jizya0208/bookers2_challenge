class Relationship < ApplicationRecord
# followerとfollowedのクラス名(モデル名)を指定し、ユーザテーブルを参照させる
  belongs_to :follower, class_name: "User"
  belongs_to :followed, class_name: "User"
end
