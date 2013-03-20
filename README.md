# perl-plugin

This is jenkins plugin to run chef-client on remote host

# what it does

 1) Connect to remote host with given ssh login using ssh public-key authentication schema.
 2) Run chef-client on this host with chef json file generated from template.

# features
- chef json file generated from custom ERB template
- ssh public-key authentication schema is used
- dry run mode

# interface

![layout](https://raw.github.com/melezhik/chef-plugin/master/images/layout.png "layout")

## chef json custom template
If you define one, chef_publisher will generate chef json file, based on the template. 
 - Check out chef [wiki](http://wiki.opscode.com/display/chef/Setting+the+run_list+in+JSON+during+run+time) to get know about chef json files.
 - You can use [ERB](http://www.stuartellis.eu/articles/erb/) constructions here

# prerequisites
- ssh client

# Environment set-up

You can set environment variables via "Jenkins/Configuration/Global properties/Environment variables" interface to adjust plugin behaviour.

## LC_ALL
Setup your standard encoding.

    ru_RU.UTF-8


