[![endorse](http://api.coderwall.com/jeroenr/endorsecount.png)](http://coderwall.com/jeroenr)

# deplay

deplay is a capistrano plugin to facilitate the deployment of Play! applications (inspired by supply_drop). It works by packaging your Play! application and copying (using rsync, or scp) it to your servers

### Installation

    gem install deplay

or with Bundler

    gem 'deplay'

### Tasks

    cap deplay:setup

This sets up the environment for Play! deployment, depending on your configuration.

    cap deplay:deploy_dev

This deploys the Play! application on the target servers using development configuration.

    cap deplay:deploy_prod

This deploys the Play! application on the target servers using production configuration.

    cap deplay:stop

Stops the Play! application.

    cap deplay:start

Starts the Play! application.

### Configuration

At the top of your deploy.rb

    require 'rubygems'
    require 'deplay'

then optionally set some variables

    set :app_name, 'my_app'

the name of your app. Used for the log file and messages

  	set :log_dir, '/var/log'

the log directory on the target machine.

 	set :prod_conf, 'prod.conf'

the production configuration file to use.

  	set :deploy_to, '/var/lib/my_app'

the path to deploy to.
	
	set :project_home, '.'

the location of your Play! project (local path).