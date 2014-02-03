Pry.config.editor = "mvim"

# Launch Pry with access to the entire Rails stack.
# If you have Pry in your Gemfile, you can pass: ./script/console --irb=pry instead.
# If you don't, you can load it through the lines below :)
rails = File.join Dir.getwd, 'config', 'environment.rb'


Pry.commands.alias_command 'c', 'continue'
Pry.commands.alias_command 's', 'step'
Pry.commands.alias_command 'n', 'next'

if File.exist?(rails) && ENV['SKIP_RAILS'].nil?
  require rails

  if Rails.version[0..0] == "2"
    require 'console_app'
    require 'console_with_helpers'
  elsif Rails.version[0..0] == "3"
    require 'rails/console/app'
    require 'rails/console/helpers'
    # Show sql output
    #ActiveRecord::Base.logger = Logger.new(STDOUT) if defined? ActiveRecord::Base
    # Add reload! command if rails version > 3.2
    if Rails.version[2..2].to_i >= 2
      include Rails::ConsoleMethods
    end
  else
    warn "[WARN] cannot load Rails console commands (Not on Rails2 or Rails3?)"
  end
end


# To edit the method given by editor mvim
class Object
  def mvim(method_name)
    file, line = method(method_name).source_location
    `mvim '#{file}' +#{line}`
  end
end


# Break out of the Bundler jail
# from https://github.com/ConradIrwin/pry-debundle/blob/master/lib/pry-debundle.rb
if defined? Bundler
  Gem.post_reset_hooks.reject! { |hook| hook.source_location.first =~ %r{/bundler/} }
  Gem::Specification.reset
  load 'rubygems/custom_require.rb'
end

if defined? Rails
  begin
    require 'hirb'
  rescue LoadError
  end

  if defined? Hirb
    # Dirty hack to support in-session Hirb.disable/enable
    Hirb::View.instance_eval do
      def enable_output_method
        @output_method = true
        Pry.config.print = proc do |output, value|
          Hirb::View.view_or_page_output(value) || Pry::DEFAULT_PRINT.call(output, value)
        end
      end

      def disable_output_method
        Pry.config.print = proc { |output, value| Pry::DEFAULT_PRINT.call(output, value) }
        @output_method = nil
      end
    end

    Hirb.enable
  end
end

begin
  require 'awesome_print'
rescue LoadError
end
if defined? Authorization && defined? User
  Authorization.current_user = User.first
end
