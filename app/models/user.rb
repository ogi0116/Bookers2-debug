class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

 has_many :books, dependent: :destroy
 has_many :book_comments, dependent: :destroy
 has_many :favorites, dependent: :destroy

  has_one_attached :profile_image

  validates :name, length: { minimum: 2, maximum: 20 }, uniqueness: true,  presence: true
  validates :introduction, length: { maximum: 50}


    # フォローするユーザーから見た中間テーブル
  has_many :active_relationships,class_name: "Relationship", foreign_key: "follower_id",dependent: :destroy

  # フォローされているユーザーから見た中間テーブル
  has_many :passive_relationships,class_name: "Relationship",foreign_key: "followed_id", dependent: :destroy

  # 中間テーブルactive_relationshipsを通って、フォローされる側(followed)を集める処理をfollowingsと命名
  # フォローしているユーザーの情報がわかるようになる
  has_many :followers, through: :active_relationships, source: :followed

  # 中間テーブルpassive_relationshipsを通って、フォローする側(follower)を集める処理をfollowingsと命名
  #　フォローされているユーザーの情報がわかるようになる
  has_many :followeds, through: :passive_relationships, source: :follower

  def followed_by?(user)
    # 今自分(引数のuser)がフォローしようとしているユーザー(レシーバー)がフォローされているユーザー(つまりpassive)の中から、引数に渡されたユーザー(自分)がいるかどうかを調べる
    passive_relationships.find_by(follower_id: user.id).present?
  end


   # 検索方法分岐(検索窓の追加)
  def self.looks(search, word)
    if search == "perfect_match"
      @user = User.where("name LIKE?", "#{word}")
    elsif search == "forward_match"
      @user = User.where("name LIKE?","#{word}%")
    elsif search == "backward_match"
      @user = User.where("name LIKE?","%#{word}")
    elsif search == "partial_match"
      @user = User.where("name LIKE?","%#{word}%")
    else
      @user = User.all
    end
  end






  def get_profile_image
    (profile_image.attached?) ? profile_image : 'no_image.jpg'
  end
end
