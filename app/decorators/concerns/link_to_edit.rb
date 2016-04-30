module LinkToEdit
  def link_to_edit(name, options = {})
    h.link_to(model.send(name), h.edit_resource_path(model), options)
  end
end
