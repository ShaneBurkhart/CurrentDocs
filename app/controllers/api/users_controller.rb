class Api::UsersController < ApplicationController
    before_filter :user_not_there!

    def contacts
	render json: current_user.contacts
    end

    def add_contacts
	if(current_user.email == params[:contact][:email])
	    render :json => {error: "You can't add yourself to your contacts."}
	else
	    @user = User.find_by_email(params[:contact][:email]);
	    if(!@user)
		# Arbitrary password.  We will change it with signup_link.
		pass = ('a'..'z').to_a.shuffle[0,8].join
		@user = User.new_guest_user(params[:contact], pass)
		@user.send_new_guest_user_notification(@user, pass, current_user.email)
		@user.save
	    end

	    @contact = Contact.find_by_user_id_and_contact_id(current_user.id, @user.id)
	    if(!@contact)
		@contact = Contact.create(user_id: current_user.id, contact_id: @user.id)
		render json: @contact
	    else
		render json: { error: "Contact already exists." }
	    end
	end
    end
end
