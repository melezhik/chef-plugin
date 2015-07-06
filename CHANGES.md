# 0.1.6
- fix for `dry_run, enabled settings get reset after jenkins restart'

# 0.1.5
- add  -o 'StrictHostKeyChecking no' to ssh run
- ship json data as file ( via scp ), so use file:// not http:// `resource' to avoid http related issues when run chef-client with -j parameter 

# 0.1.4
- ssh identity path option
- regenerated and impoved documentation 
- typo fixes 


# 0.1.3
documentation changes, cleaning up README.md

# 0.1.0
chef client explicitly run chef client with `-l info` 

# 0.0.4
- syntax error bugfix

# 0.0.3
- dry-run mode improved - real run of chef-client, but with --why-run flag

# 0.0.2
- dry-run mode added
- replace publisher by builder
- use simple_console
- doc updated and imporved


# 0.0.1
- first release version
