class Api::UsersController < ApplicationController
    before_filter :user_not_there!

    def contacts
	render json: current_user.contacts
    end

    def add_contacts
	email = params[:contact][:email]
	if(current_user.email == email)
	    render :json => {error: "You can't add yourself to your contacts."}
	else
	    @user = User.find_or_create_new_guest_user(email, current_user.email);
	    if(!@user)
		render json: { error: "Not a valid email." }
		return
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
