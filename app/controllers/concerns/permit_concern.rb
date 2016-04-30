module PermitConcern
  protected

  def resource_params
    return [] if request.get?
    [ params.require(resource_instance_name.to_sym).permit! ]
  end
end
