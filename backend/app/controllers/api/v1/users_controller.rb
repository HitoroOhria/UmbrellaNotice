class Api::V1::UsersController < ApplicationController
  # POST /api/v1/users email=email_address
  def create
    user_validator = UserValidator.init_with(params)
    return render_400(user_validator) if user_validator.invalid?
    return render_422(user_validator) unless (user = user_validator.save)

    location_url = api_v1_user_url(user.encoded_email)
    render_201('SUCCESS', location: location_url)
  end

  # GET /api/v1/users/:email?embed=*,relate_model
  def show
    user_validator = UserValidator.init_with(params)
    return render_400(user_validator) if user_validator.invalid?
    return render_404(user_validator) unless (@user = user_validator.find_by_email)

    render_200(@user, params[:embed].to_s) # change '' if params[:embed] is nil.
  end

  # PUT /api/v1/users/:email new_email=new@example.com
  def update
    user_validator = UserValidator.init_with(params)
    return render_400(user_validator) if user_validator.invalid?
    return render_400(user_validator) unless (@user = user_validator.update)

    render_200(@user)
  end

  # DELETE /api/v1/users/:email
  def destroy
    user_validator = UserValidator.init_with(params)
    return render_400(user_validator) if user_validator.invalid?
    return render_404(user_validator) unless user_validator.destroy

    render_204
  end

  # POST /api/v1/users/:email/relate_line_user
  # PARAMS inherit_token
  def relate_line_user
    user_validator = UserValidator.init_with(params)
    return render_400(user_validator) if user_validator.invalid?
    return render_404(user_validator) unless user_validator.relate_line_user

    render_200('SUCCESS')
  end
end
