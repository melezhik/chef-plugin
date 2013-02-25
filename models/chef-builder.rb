require 'erb'
require 'json'

class ChefPublisher < Jenkins::Tasks::Builder

    attr_accessor :enabled, :dry_run, :chef_json_template
    attr_accessor :ssh_host, :ssh_login, :chef_client_config

    display_name "Run chef client on remote host"

    def initialize(attrs = {})
        @enabled = attrs["enabled"]
        @dry_run = attrs["dry_run"]
        @chef_json_template = attrs["chef_json_template"]
        @ssh_host = attrs["ssh_host"]
        @ssh_login = attrs["ssh_login"]
        @chef_client_config = attrs["chef_client_config"]
    end

    def prebuild(build, listener)
    end

    def perform(build, launcher, listener)


        if @enabled == true

            # generate chef json file

            listener.info "generate chef json from template"

            env = build.native.getEnvironment()
            job = build.send(:native).get_project.name
            workspace = build.send(:native).workspace.to_s

            listener.info "rendering ERB template ... "

            renderer = ERB.new(@chef_json_template)
            json_str = renderer.result
            json_str.sub! '"{','{'
            json_str.sub! '}"','}'

            listener.info "parsing JSON ... "

            JSON.parse(json_str)

            listener.info "saving JSON to file ... "

            File.open("#{workspace}/chef.json", 'w') {|f| f.write(JSON.pretty_generate(JSON.parse(json_str))) }

            chef_json_url = "#{env['JENKINS_URL']}/job/#{job}/ws/chef.json"

            listener.info "chef_json url: #{chef_json_url}"

            if @dry_run == true 
                listener.info "dry run mode is ON, so finish here, buy!"
            else
                listener.info "running chef-client on remote host: #{@ssh_host} ... "
                cmd = []
                cmd << "export LC_ALL=#{env['LC_ALL']}" unless ( env['LC_ALL'].nil? || env['LC_ALL'].empty? )
                config_path = ''
                config_path = " -c #{@chef_client_config}" unless (@chef_client_config.nil? ||  @chef_client_config.empty?)
                cmd << "ssh #{@ssh_login}@#{@ssh_host} sudo chef-client -j #{chef_json_url} #{config_path}"
                listener.info "ssh command: #{cmd.join(' && ')}"
                build.abort unless launcher.execute("bash", "-c", cmd.join(' && '), { :out => listener } ) == 0
            end
    
        end


    end

end


