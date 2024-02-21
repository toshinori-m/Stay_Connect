class TeamsController < ApplicationController
  before_action :authenticate, except: [:index]
  
  def create
    team = current_user.teams.new(create_params)
    team.sports_discipline_ids = params[:sports_discipline_ids]
    team.target_age_ids = params[:target_age_ids]
    
    team.save!
    head :ok
  rescue ActiveRecord::RecordInvalid => e
    render json: { error: e.record.errors.messages }, status: :unprocessable_entity 
  end

  def update
    @team = current_user.teams.find(params[:id])
    return render json: { errors: @team.errors.full_messages }, status: 400 unless @team.update(create_params)
  end

  def index
    @teams = current_user.teams
    render json: { message: '成功しました', data: @teams }, status: 200
  end

  def show
    @team = Team.find(params[:id])
  end

  def destroy
    team = Team.find(params[:id])
    team.destroy!
    @teams = Team.eager_load(:sports_disciplines, :target_ages).where(user_id: current_user.id)
  rescue ActiveRecord::RecordNotFound => e
    render json: { error: '対象のチームが見つかりません。' }, status: :not_found
  rescue ActiveRecord::RecordNotDestroyed => e
    render json: { error: '削除に失敗しました。', errors: team.errors.messages }, status: :internal_server_error
  end

  private

  def create_params
    params
    .require(:team)
    .permit(:name, :area, :sex, :track_record, :other_body, :sports_type_id, :prefecture_id, sports_discipline_ids: [], target_age_ids: [])
  end
end
