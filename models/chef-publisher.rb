class ChefPublisher < Jenkins::Tasks::Publisher

    attr_accessor :enabled, :chef_json_url
    attr_accessor :ssh_host, :ssh_login, :chef_client_config

    display_name "Run chef client on remote host"

    def initialize(attrs = {})
        @enabled = attrs["enabled"]
        @chef_json_url = attrs["chef_json_url"]
        @ssh_host = attrs["ssh_host"]
        @ssh_login = attrs["ssh_login"]
        @chef_client_config = attrs["chef_client_config"]
    end

    def prebuild(build, listener)
    end

    def perform(build, launcher, listener)

        env = build.native.getEnvironment()

        if @enabled == true

            listener.info "running chef-client on remote host: #{@ssh_host} ... "
            listener.info "chef_json url: #{chef_json_url}"
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


