class ChatsController < ApplicationController

before_action :reject_non_related, only: [:show]


  def show
    @user = User.find(params[:id]) #チャットする相手のユーザーidを特定
    rooms = current_user.user_rooms.pluck(:room_id) #ログイン中のユーザーが持つ部屋情報を全て習得
    user_rooms = UserRoom.find_by(user_id: @user.id, room_id: rooms) #上記の記述内容から、チャット相手のルーム情報があるか確認

    unless user_rooms.nil?
      @room = user_rooms.room #変数@roomにユーザー(自分と相手)と紐づいているroomを代入
    else
      @room = Room.new
      @room.save
      UserRoom.create(user_id: current_user.id, room_id: @room.id)
      UserRoom.create(user_id: @user.id, room_id: @room.id)
    end
    @chats = @room.chats
    @chat = Chat.new(room_id: @room.id) #チャットの投稿
  end

  def create
    @chat = current_user.chats.new(chat_params)
    @room = @chat.room
    @chats = @room.chats
    render :validater unless @chat.save
  end

  private
  def chat_params
    params.require(:chat).permit(:message, :room_id)
  end

  def reject_non_related
    user = User.find(params[:id])
    unless current_user.followed_by?(user) && user.followed_by?(current_user)
      redirect_to books_path
    end
  end

end
