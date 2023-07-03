class GroupUsersController < ApplicationController
 before_action :authenticate_user!

  def create #現在のユーザーを取得して、group_usersにnewメソッドで新しいコードを生成する
    group_user = current_user.group_users.new(group_id: params[:group_id])
    group_user.save
    redirect_to request.referer
  end
  
  def destroy #アソシエーションでgrouo_usersを作ったものから、その中から自分のidを見つけて削除する
    group_user = current_user.group_users.find_by(group_id: params[:group_id])
    group_user.destroy
    redirect_to request.referer
  end
  
end
