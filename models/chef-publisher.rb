class ChefPublisher < Jenkins::Tasks::Publisher

    attr_accessor :enabled, :json_file_dir
    attr_accessor :ssh_host, :ssh_login, :chef_client_config

    display_name "Run chef-client on remote host"

    def initialize(attrs = {})
        @enabled = attrs["enabled"]
        @json_file_dir = attrs["json_file_dir"]
        @ssh_host = attrs["ssh_host"]
        @ssh_login = attrs["ssh_login"]
        @chef_client_config = attrs["chef_client_config"]
    end

    def prebuild(build, listener)
    end

    def perform(build, launcher, listener)

        env = build.native.getEnvironment()

        if @enabled == true

            job = build.send(:native).get_project.name
            build_number = build.send(:native).get_number

            chef_json_path = build.send(:native).workspace.to_s
            chef_json_path << "/#{json_file_dir}" unless json_file_dir.nil? or json_file_dir.empty?
            chef_json_path << "/chef.json"

            listener.info "chef_json_path: #{chef_json_path}"

            # copy chef_json_path to remote host with scp
            listener.info "copy chef json file to remote host"
            cmd = []
            cmd << "export LC_ALL=#{env['LC_ALL']}" unless ( env['LC_ALL'].nil? || env['LC_ALL'].empty? )
            cmd << "scp #{chef_json_path} #{@ssh_login}@#{@ssh_host}:/tmp/#{File.basename(chef_json_path)}"
            listener.info "ssh command: #{cmd.join(' && ')}"
            build.abort unless launcher.execute("bash", "-c", cmd.join(' && '), { :out => listener } ) == 0

            listener.info "running chef-client on remote host: #{@ssh_host} ... "
            cmd = []
            cmd << "export LC_ALL=#{env['LC_ALL']}" unless ( env['LC_ALL'].nil? || env['LC_ALL'].empty? )
            config_path = ''
            config_path = " -c #{@chef_client_config}" unless (@chef_client_config.nil? ||  @chef_client_config.empty?)
            cmd << "ssh #{@ssh_login}@#{@ssh_host} sudo chef-client -j /tmp/#{File.basename(chef_json_path)} #{config_path}"
            listener.info "ssh command: #{cmd.join(' && ')}"
            build.abort unless launcher.execute("bash", "-c", cmd.join(' && '), { :out => listener } ) == 0

        end


    end

end


