module VirtusFormHelpers

  protected

  def set_attributes_from_model(model)
    self.attributes.each_key do |key|
      self.send("#{key}=", model.send(key))
    end
  end


  def set_attributes_from_params(params)
    if params
      self.attributes = params
    end
  end

end
