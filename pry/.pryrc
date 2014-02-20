Pry.config.editor = "mvim"

# To edit the method given by editor mvim
class Object
  def mvim(method_name)
    file, line = method(method_name).source_location
    `mvim '#{file}' +#{line}`
  end
end

begin
  require 'awesome_print'
rescue LoadError
end
