class RenderContext
  def initialize(assigns)
    assigns.each do |name, value|
      instance_variable_set("@#{name}", value)
    end
  end

  def binding
    super
  end
end
