class Api::ResultsController < Api::BaseController
  def create
    player = Player.find_or_initialize_by(uid: extract_uid)

    result = BuildResultForPlayer.call(player)

    if result.save
      render_json({id: result.id}) # .sort_by(&:id)
    else
      json = {id: nil, errors: result.errors.as_json}.to_json.gsub(/player\./, '')
      render_json(json, status: 422)
    end
  end

  def update
    result = Result.with_state(Result::PENDING).joins(:player).where(players: {uid: extract_uid}, id: params[:id]).first
    player = Player.find_or_initialize_by(uid: extract_uid)
    if result
      UpdateResult.call(result, params[:score])
      render_result(result)
      player = Player.all.where(uid:extract_uid)[0]
      update_player_score(player)
    else
      render_json({error: "not found"}, status: 422)
    end
  end

  def update_player_score(player)
    score = player.results.where(:state => Result::DONE).maximum(:score)
    player.score = score
    player.save
  end

  # def publish
  #   result = Result.with_state(Result::CORRECT).joins(:player).where(players: {uid: extract_uid}, id: params[:id]).first

  #   render_json({ok: !!(result && result.publish)})
  # end

  def index
    render_results Result.board
  end

  def all
    render_results Result.board
  end

  private

  def render_result(result)
    render_json({id: result.id, state: result.state, score: result.score})
  end

  def extract_uid
    token = find_or_create_token
    token || logger.warn("Invalid token: #{params.slice(:user_id, :token).inspect}")
    token.presence && token.uid
  end

  def render_results(scope)
    paginated = scope.paginate(page: params[:page])
    results = paginated.each_with_index.map { |r, i| r.as_json(place: paginated.offset + i + 1) }

    render_json({
      results: results,
      total_pages: paginated.total_pages
    })
  end

end
