class Api::V1::LineUsersController < ApplicationController
  # GET /api/v1/line_users/:id?embed=*,relate_model2.id
  def show
    line_user_validator = LineUserValidator.init_with(params)
    return render_400(line_user_validator) if line_user_validator.invalid?
    return render_404(line_user_validator) unless (@line_user = line_user_validator.find_by_id)

    render_200(@line_user, params)
  end

  # PUT /api/v1/line_users/:id
  # PARAMS notice_time silent_notice
  def update
    line_user_validator = LineUserValidator.init_with(params)
    return render_400(line_user_validator) if line_user_validator.invalid?
    return render_400(line_user_validator) unless (@line_user = line_user_validator.update)

    render_200(@line_user)
  end

  # DELETE /api/v1/line_users/:id
  def destroy
    line_user_validator = LineUserValidator.init_with(params)
    return render_400(line_user_validator) if line_user_validator.invalid?
    return render_404(line_user_validator) unless line_user_validator.destroy

    render_204
  end
end
