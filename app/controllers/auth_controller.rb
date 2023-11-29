class AuthController < ApplicationController
  skip_before_action :require_login, only: [:login, :auto_login]

  def login
    user = User.find_by(username: params[:username])
    if user && user.authenticate(params[:password])
      payload = {user_id: user.id}
      token = encode_token(payload)
      render json: {user: user, jwt: token, success: "Welcome back, #{user.username}"}
    else
      render json: {failure: "Log in failed! Username or password invalid!"},  status: 401
    end
  end

  def auto_login
    if session_user
      render json: session_user, status: 200
    else
      render json: {errors: "No User Logged In"}, status: 500
    end
  end

  def logout
      session_user = nil
      render json: {errors: "No User Logged In"}
  end


  def destroy
    warden.authenticate!(:scope => resource_name, :recall => "#{controller_path}#failure")
    current_user.update_column(:authentication_token, nil)
    render :status => 200,
           :json => { :success => true,
                      :info => "Logged out",
                      :data => {} }
  end

  def failure
    render :status => 401,
           :json => { :success => false,
                      :info => "Login Failed",
                      :data => {} }
  end

end