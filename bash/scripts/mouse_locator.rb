#!/usr/bin/env ruby
require 'rubygems'
require 'pry'

class MouseLocatorRandomizer

  IMAGE_DIRECTORY = '/Users/pete/Pictures/mouse_locators'
  EXECUTABLE = '/Users/pete/Library/PreferencePanes/MouseLocator.prefPane/Contents/Resources/MouseLocatorAgent.app/Contents/MacOS/MouseLocatorAgent -psn_0_6661722'

  def randomize_image
    replace_png_with random_image_file_name 
    restart_mouse_locator
  end

  private

  def random_image_file_name
    files = Dir.glob(File.join(IMAGE_DIRECTORY, "*"))
    files[rand(files.size)]
  end

  def replace_png_with(file_name)
    FileUtils.cp(file_name, '/Users/pete/Pictures/MouseLocator.png')
  end

  def restart_mouse_locator
    if @pipe
      Process.detach(@pipe.pid)
      Process.kill('KILL', @pipe.pid)
    end
    @pipe = IO.popen(EXECUTABLE)
  end
end

randomizer = MouseLocatorRandomizer.new

while true do
  randomizer.randomize_image 
  sleep(60)
end
