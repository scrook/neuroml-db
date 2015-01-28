class SessionsController < ApplicationController
def new
  end

  def create
    user = Curationuser.find_by_name(params[:session][:userid])
	
    if user && user.authenticate(params[:session][:password])
	puts "usr authenticated"
	 sign_in user
      redirect_to '/browse_models'
    else
	puts "usr not authenticated"
      flash[:error] = 'Invalid email/password combination' # Not quite right!
      render 'new'
    end
  end
  
  def destroy
    sign_out
    redirect_to root_url
  end
end
