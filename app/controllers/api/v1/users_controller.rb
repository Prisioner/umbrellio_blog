class Api::V1::UsersController < Api::V1::BaseController
  api :GET, '/v1/users/ip_groups', I18n.t('doc.v1.users.ip_groups')
  def ip_groups
    @ip_groups = IPGroupsService.execute

    respond_to do |format|
      format.json { render json: { code: 200, data: @ip_groups }, status: 200 }
    end
  end
end
