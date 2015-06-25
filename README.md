# SYNOPSIS

This is jenkins plugin to run chef-client on remote host.
Plugin starts ssh session on remote host using public key authentication and chef-client there.


# Plugin general settings

- host - Specifies remote host to run chef client on.
- login -  Specifies the user to log in as on the remote machine.

# Plugin advanced settings

- ssh\_indetity\_file - Specifies a path to file from which the identity (private key) for public key authentication is read.
- chef\_client\_config - Specifies a path to file ( on  remote host ) from which chef client configuration is read, default values is /etc/chef/client.rb
- chef\_json\_template - Specifies chef attributes and run-list ( see chef documentation ).
- dry\_run - Use to run chef client in why-run mode, which is a type of chef-client run that does everything except modify the system, default value is false.

# User interface

![layout](https://raw.github.com/melezhik/chef-plugin/master/images/layout.png "layout")

# Chef attributes and run list settings

- Use chef\_json\_template to define chef attributes and run list. 
If you define one, plugin will parse chef_json_template data and stored result in file which in turn will passed as -j parameter into chef-client run.

- Please check out [chef wiki](http://wiki.opscode.com/display/chef/Setting+the+run_list+in+JSON+during+run+time) to learn more about chef json files.

- Chef\_json\_template confirms [ERB](http://www.stuartellis.eu/articles/erb/) template syntax. Here is example of chef\_json\_template:
        
        <%
            runlist = %w{apache::server mysql}
            chef_json = {
                :run_list   => runlist.map { |r|  "recipe[#{r}]" } ,
                :apache     => {
                    :version => 80
                }
            }
        %>
        <%= chef_json.to_json.to_s %>
    
# Prerequisites
- ruby-runtime jenkins plugin
- ssh client


# Environment variables

You can set some environment variables qith "Jenkins/Configuration/Global properties/Environment variables" . Here the list of varibales to be processed in the plugin:

- LC\_ALL # sets encoding to avoid chef log issues 

# Download latest version

[http://repo.jenkins-ci.org/releases/org/jenkins-ci/ruby-plugins/chef/0.1.4/]
