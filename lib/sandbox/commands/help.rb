
# require 'sandbox/command'

class Sandbox::Commands::HelpCommand < Sandbox::Command
  
  ## CLASS METHODS
  class << self
  end
  ## END CLASS METHODS
  
  ## PUBLIC INSTANCE METHODS
  public
    def initialize
      super( 'help', "Provide help on general usage or individual commands" )
    end
    
    def execute!
      arg = options[ :args ].first
      if matches?( 'commands', arg )
        show_commands
      elsif arg
        unless Sandbox::CommandManager.command_names.include?( arg )
          raise UnknownCommand.new( arg, "#{cli_string} commands" )
        end
        command = Sandbox::CommandManager[ arg ]
        command.run( ["--help"] )
      else
        show_application_help
      end
    end
    
    def usage
      "#{cli_string} ARGUMENT"
    end
    
    def arguments # :nodoc:
      [
        [ 'commands',   "List all 'sandbox' commands" ],
        [ '<command>',  "Show specific help for <command>" ]
      ].freeze
    end
    
    def show_commands
      out = []
      out << "Available commands for the sandbox utility:"
      out << ""
      cmds = Sandbox::CommandManager.command_names.collect do |n|
        cmd = Sandbox::CommandManager[ n ]
        [ cmd.name, cmd.summary ]
      end
      out.concat( nested_formatter( cmds ) )
      out << ""
      out << "For help on a particular command, use 'sandbox help COMMAND'."
      out << nil
      out << "Commands may be abbreviated, so long as they are unambiguous."
      out << "e.g. 'sandbox h init' is short for 'sandbox help init'."
      puts out.join( "\n" )
    end
    
    def show_application_help
      puts %{
        
        Sandbox will create a virtual environment for development.
        This is a basic help message with pointers to more information.
        
          Usage:
            sandbox -h/--help
            sandbox -v/--version
            sandbox command [arguments...] [options...]
          
          Further help:
            sandbox help commands            list all 'sandbox' commands
            sandbox help <COMMAND>           show help on COMMAND
          
          Basic commands:
            init          Create a new sandbox
            list          List downloaded or remotely available ruby/rubygems versions
            help          Show detailed help on a specific command
      }.gsub(/^\s{6}/, "")
    end
    
    ###### RUBYGEMS HELP COMMAND
    # def arguments # :nodoc:
    #   args = <<-EOF
    #     commands      List all 'gem' commands
    #     examples      Show examples of 'gem' usage
    #     <command>     Show specific help for <command>
    #   EOF
    #   return args.gsub(/^\s+/, '')
    # end
    # 
    # def usage # :nodoc:
    #   "#{program_name} ARGUMENT"
    # end
    # 
    # def execute
    #   command_manager = Gem::CommandManager.instance
    #   arg = options[:args][0]
    # 
    #   if begins? "commands", arg then
    #     out = []
    #     out << "GEM commands are:"
    #     out << nil
    # 
    #     margin_width = 4
    # 
    #     desc_width = command_manager.command_names.map { |n| n.size }.max + 4
    # 
    #     summary_width = 80 - margin_width - desc_width
    #     wrap_indent = ' ' * (margin_width + desc_width)
    #     format = "#{' ' * margin_width}%-#{desc_width}s%s"
    # 
    #     command_manager.command_names.each do |cmd_name|
    #       summary = command_manager[cmd_name].summary
    #       summary = wrap(summary, summary_width).split "\n"
    #       out << sprintf(format, cmd_name, summary.shift)
    #       until summary.empty? do
    #         out << "#{wrap_indent}#{summary.shift}"
    #       end
    #     end
    # 
    #     out << nil
    #     out << "For help on a particular command, use 'gem help COMMAND'."
    #     out << nil
    #     out << "Commands may be abbreviated, so long as they are unambiguous."
    #     out << "e.g. 'gem i rake' is short for 'gem install rake'."
    # 
    #     say out.join("\n")
    # 
    #   elsif begins? "options", arg then
    #     say Gem::Command::HELP
    # 
    #   elsif begins? "examples", arg then
    #     say EXAMPLES
    # 
    #   elsif begins? "platforms", arg then
    #     say PLATFORMS
    # 
    #   elsif options[:help] then
    #     command = command_manager[options[:help]]
    #     if command
    #       # help with provided command
    #       command.invoke("--help")
    #     else
    #       alert_error "Unknown command #{options[:help]}.  Try 'gem help commands'"
    #     end
    # 
    #   elsif arg then
    #     possibilities = command_manager.find_command_possibilities(arg.downcase)
    #     if possibilities.size == 1
    #       command = command_manager[possibilities.first]
    #       command.invoke("--help")
    #     elsif possibilities.size > 1
    #       alert_warning "Ambiguous command #{arg} (#{possibilities.join(', ')})"
    #     else
    #       alert_warning "Unknown command #{arg}. Try gem help commands"
    #     end
    # 
    #   else
    #     say Gem::Command::HELP
    #   end
    # end
  ## END PUBLIC INSTANCE METHODS
  
  
  ## PRIVATE INSTANCE METHODS
  private
    
  ## END PRIVATE INSTANCE METHODS
  
end