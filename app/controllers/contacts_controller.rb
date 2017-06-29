class ContactsController < ApplicationController
  
  #GET request to /contact_us
  #Show new contact form
  def new
    @contact = Contact.new
  end
  
  # A POST request /contacts
  def create
    #Mass assignment of form fields into contact object
    @contact = Contact.new(contact_params)
    #Save the contact object to the database
    if @contact.save
      # Store form fields via parameters, into variables
      name = params[:contact][:name]
      email = params[:contact][:email]
      body = params[:contact][:comments]
      #Plug variables into Contact Mailer
      #email method and send email
      ContactMailer.contact_email(name, email, body).deliver
      #Store succes message in flash hash
      # and redirect to new action
      flash[:success] = "Message sent."
      redirect_to new_contact_path
    else
      #If Contact object doesn't save, 
      #Store errors in flash hash
      #and redirect to new action
      flash[:danger] = @contact.errors.full_messages.join(", ")
       redirect_to new_contact_path
    end
  end
  
  private
    def contact_params
       params.require(:contact).permit(:name, :email, :comments)
    end
end