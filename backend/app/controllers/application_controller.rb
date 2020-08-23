class ApplicationController < ActionController::API
  # include Lineable

  # @param [Hash] main_hash is response Model.
  # @option relation_hash [Hash]  Model relate to main_hash. like { line_user: LineUser }
  # @return [Hash] like { **User, line_user: LineUser, weather: Weather }
  # @solve main_hash[:relation] = { **relation_hash }  && main_hash
  #          #=> { user: User, relation: {...} } {...} is infinite loop.
  def build_relation_response(main_hash, **relation_hash)
    { **main_hash, **relation_hash }
  end

  def render_json(code, response_json, location: nil)
    render status: code, json: response_json, location: location
  end

  def render_ok(response_json = nil)
    render_json(200, response_json)
  end

  def render_created(response_json = nil, location: nil)
    response.location = location
    render_json(201, response_json, location: location)
  end

  def render_no_content
    render_json(204, nil)
  end

  # invalid data
  def render_bad_request(response_json = nil)
    render_json(400, response_json)
  end

  # Not found resource.
  def render_not_found(response_json = nil)
    render_json(404, response_json)
  end

  # validation error
  def render_unprocessable_entity(response_json = nil)
    render_json(422, response_json)
  end
end
