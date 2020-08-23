class Api::V1::UsersController < ApplicationController
  before_action :validates_params

  # POST /api/v1/users email=email_address
  def create
    handle_error do
      user = User.create!(email: params[:email])
      location_url = api_v1_user_url(user.encoded_email)

      render_created(user.response_attributes, location: location_url)
    end
  end

  # GET /api/v1/users/:email?embed=relate_model1,relate_model2.id
  def show
    handle_error do
      user = User.find_by!(email: params[:email])
      response_json = build_relation_response(user.response_attributes)
      render_ok(response_json)
    end
  end

  # PUT /api/v1/users/:email new_email=new@example.com
  def update
    handle_error do
      user = User.find_by!(email: params[:email])
      user.update!(email: params[:new_email])
      render_ok(user.response_attributes)
    end
  end

  # DELETE /api/v1/users/:email
  def destroy
    handle_error do
      user = User.find_by!(email: params[:email])
      User.destroy(user.id)
      render_no_content
    end
  end

  private

  def handle_error
    yield
  rescue ActiveRecord::RecordInvalid
    render_unprocessable_entity('Invalid email address.')
  rescue ActiveRecord::RecordNotUnique
    render_unprocessable_entity('Email address already exist.')
  rescue ActiveRecord::RecordNotFound
    render_not_found("Not fond '#{params[:email]}' user.")
  end

  def validates_params
    return if params[:email]

    render_bad_request('You need "email" param.')
  end
end
