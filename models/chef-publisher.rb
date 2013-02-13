class ChefPublisher < Jenkins::Tasks::Publisher

    attr_accessor :run_deploy
    attr_accessor :ssh_host, :ssh_login, :chef_client_config

    display_name "Run chef-client on remote host"

    def initialize(attrs = {})
        @run_deploy = attrs["run_deploy"]
        @ssh_host = attrs["ssh_host"]
        @ssh_login = attrs["ssh_login"]
        @chef_client_config = attrs["chef_client_config"]
    end

    def prebuild(build, listener)
    end

    def perform(build, launcher, listener)

        env = build.native.getEnvironment()

        if @run_deploy == true

            job = build.send(:native).get_project.name
            build_number = build.send(:native).get_number

            listener.info "running chef-client on remote host: #{@ssh_host} ... "

            chef_json_uri = "#{env['JENKINS_URL']}/job/#{job}/#{build_number}/artifact/build/chef.json"

            listener.info "chef_json uri: #{chef_json_uri}"

            cmd = []
            cmd << "export LC_ALL=#{env['LC_ALL']}" unless ( env['LC_ALL'].nil? || env['LC_ALL'].empty? )
            config_path = ''
            config_path = " -c #{@chef_client_config}" unless (@chef_client_config.nil? ||  @chef_client_config.empty?)
            cmd << "ssh #{@ssh_login}@#{@ssh_host} sudo chef-client -j #{chef_json_uri} #{config_path}"
            listener.info "deploy command: #{cmd.join(' && ')}"

            build.abort unless launcher.execute("bash", "-c", cmd.join(' && '), { :out => listener } ) == 0
        end


    end

end


