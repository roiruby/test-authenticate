class SessionsController < ApplicationController
  def new
  end

  def create
    @user = User.find_by(email: params[:session][:email].downcase)
    if @user && @user.authenticate(params[:session][:password])
      if @user.activated?
        log_in @user
        params[:session][:remember_me] == '1' ? remember(@user) : forget(@user)
        redirect_to @user
      else
        message   = "アカウントは有効ではありません"
        message  += "メールで送られたURLから有効化してください"
        flash[:warning] = message
        redirect_to root_url
      end
    else
      flash.now[:danger] = 'ログインに失敗しました。'
      render :new
    end
  end
  

  def destroy
    log_out if logged_in?
    redirect_to root_url
  end

  private

  # def login(email, password)
  #   @user = User.find_by(email: email)
  #   if @user && @user.authenticate(password)
  #     # ログイン成功
  #     session[:user_id] = @user.id
  #     return true
  #   else
  #     # ログイン失敗
  #     return false
  #   end
  # end
end
