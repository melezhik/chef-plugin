# chef-plugin

This is jenkins plugin to run chef-client on remote host

# what it does

 1) Connect to remote host with given ssh login using ssh public-key authentication schema.
 2) Run chef-client on this host, optionally with chef json file generated from template.

# features
- chef json file generated from custom ERB template
- ssh public-key authentication schema is used
- optionally may be run in chef client in why run mode 

# interface

![layout](https://raw.github.com/melezhik/chef-plugin/master/images/layout.png "layout")

## chef json template
If you define one, chef json file will be generated based on this template. 
 - Check out chef [wiki](http://wiki.opscode.com/display/chef/Setting+the+run_list+in+JSON+during+run+time) to get know about chef json files.
 - This is ERB template, so you can use [ERB](http://www.stuartellis.eu/articles/erb/) syntax here:

        <%
            runlist = %w{foo bar baz}
            chef_json = { 
                :run_list   => runlist.map { |r|  "recipe[#{r}]" } ,
                :name       => 'alexey',
                :language   => 'ruby'
            }
        %>
        <%= chef_json.to_json.to_s %>
                                          
   
# prerequisites
- ruby-runtime jenkins plugin 
- ssh client


# Environment set-up

You can set environment variables via "Jenkins/Configuration/Global properties/Environment variables" interface to adjust plugin behaviour.

## LC_ALL
Setup your standard encoding.

    ru_RU.UTF-8

# download latest version

[http://repo.jenkins-ci.org/releases/org/jenkins-ci/ruby-plugins/chef/0.1.2/]



  
