Note: Treat this as a live-document, and please update it if you find any mistakes. Also add anything that would be useful for newcomers.

# Websites

These are the main websites:
 - [NeuroML.org](https://NeuroML.org)
 - [NeuroML-DB.org](https://neuroml-db.org)
 - [Curator](https://neuroml-db.org/Curate)

#Architecture

**NeuroML.org**
This is a Ruby on Rails site that uses [Redmine](http://www.redmine.org/) as the starting point. Apache server uses the Ruby [Passenger](https://www.phusionpassenger.com/library/walkthroughs/deploy/ruby/ownserver/apache/oss/install_language_runtime.html) module to serve the Ruby site. This site talks to a MySQL server. There are also some Java files for NeuroML validation functionality. Apache redirects requests to those subfolders to a Tomcat server that handles the validator requests. All this happens on the same physical server.

**NeuroML-DB.org**
Also a Ruby on Rails site, based on Redmine, runs on Passenger module, and talks to the MySQL server. There is an interface for the search engine that executes Python code to return the search results. The Python code talks to a [Fuseki](https://jena.apache.org/documentation/fuseki2/) server that stores the ontology tripples. It also talks to the MySQL server. 

**Curator**
Also a Ruby on Rails site, based on Redmine, and talks to the MySQL server. This site is mostly used as a UI to manage the models displayed in the NeuroML-DB.org site.

#Servers

There are two servers:
 - dendrite.asu.edu
 - spike.asu.edu
 
**Dendrite** is the "production" server. All live/publicly exposed sites should be located on this server. This server should be kept as clean as possible.

**Spike** is the "testing/staging" server. All code changes should be made here, and moved to Dendrite only after they pass QA (Sharon).

The prefered development cycle should be: Local machine -> Spike -> Dendrite. See [Source Code](#source-Code)

##Server Access

Both are Ubuntu servers, and SSH'ing into them is the general workflow. The physical servers are maintained by [Renate Mittelmann](https://webapp4.asu.edu/directory/person/85012). Her office is on the same floor as Sharon. See the directory link for contact info. Any questions about usernames, passwords, access, backups, restarts, and scheduled maintenance should be directed to her.

##SSH
Connect to the servers using the following params:
 - Host: dendrite(or spike).asu.edu
 - Port: 2200
 - Username & pwd: the set you received from Renate

#Folders
Once inside the servers, the following folders are useful:

**Dendrite**: The Production Server
 - `/var/www/NeuroML.org`: NeuroML.org *Ruby on Rails* site files
 - `/var/www/NeuroML-DB.org`: NeuroML-DB.org *Ruby on Rails* portion of the site
 - `/var/www/NeuroML-DB.org_Ontology`: NeuroML-DB.org *Python* portion of the site
 - `/var/www/Curator`: Curator *Ruby* site files

**Spike**: The Testing Server
 - The same folders that are found on Dendrite in `/var/www/` should also be on Spike
 - `/var/www/DevBranches/`: This folder contains the branches used by the developers. Developers should create their own folders here, clone the github repo, and following the examples in these two files, modify `/etc/apache2/ports.conf` and  `/etc/apache2/sites-available/default-ssl.conf` to point a port on spike to one of their folders.

#Databases

Dendrite and Spike both function as web and DB servers. Both have MySQL database servers installed with several databases each. You will need to SSH into the server first, then establish a MySQL connection. Ask Renate to create a DB username for you.

The Ruby sites connect to different dabatases and the best way to find out which one the site is using is by looking at the `/var/www/[site]/config/database.yml` file.

Dendrite and Spike Databases:
 - neuromldb: This is the main db used by neuroml-db.org
 - neuroml_dev: This is an old db. I believe we're trying to move away from it and into neuromldb. 

#Ports, SSL, Apache Configuration Files
 - NeuroML.org runs on port 5001: http://dendrite.asu.edu:5001/
 - NeuroML-DB.org runs on port 5000: http://dendrite.asu.edu:5000/
 - Curator runs on port 5002: http://dendrite.asu.edu:5002/

The domains are mapped to the ports through the apache config files located on each server under `/etc/apache2/`:
 - `httpd-nml2.conf`: Sets up redirects from http to http**s**
 - `ports.conf`: Defines all ports through which Apache should serve websites
 - `sites-available/neuroml.org.conf`: Maps port 5001 to `/var/www/NeuroML.org` folder. Also sets up Java to handle the Validator code.
 - `sites-available/neuroml-db.org.conf`: Maps port 5000 to `/var/www/NeuroML-DB.org` folder.
 - `sites-available/default-ssl.conf`: Maps port 5002 to `/var/www/Curator` folder. **Note:** on *spike.asu.edu* this file also maps the ports to website code found in the developer branches (e.g. `/var/www/DevBranches/[DevName]/neuroml-db/www/NeuroML.org/`)
 - `sites-available/ssl-certs/`: This folder contains the files needed for HTTPS/SSL. When certificates expire, these files should be updated. They are referenced in the `/etc/apache2/httpd-nml2.conf` file above.

#Source Code
This github repo contains the latest source code of the three websites. Dendrite and Spike are both set up to pull the latest version in this repo to their `/var/www/` folders. The difference is that dendrite pulls from the `production` branch, while spike pulls from the `master` branch. At the moment, the pulls have to be done manually, by executing the `./pullFromGithub` script located in `/var/www/`. I'm working to automate this with Github webhooks.

##Branches
 - `master`: This is the main development branch. After local changes have been made, features commited to this branch will appear on spike.
 - `production`: This is the production branch. After changes made to the `master` branch have been tested and pass QA, then those changes in `master` should be merged into `production` branch. Those changes will then be visible on dendrite (production) sites. With very few exceptions, this branch should only be updated via merges from the `master` branch. Do not edit this branch directly.

##Source Code Commit Process

Use the following steps to make changes to the website:

 1. [Fork this repository](https://help.github.com/articles/fork-a-repo/)
 2. Create a folder on spike in `/var/www/DevBranches/`
 3. Git pull the files from the forked repository into the newly created folder
 4. Copy the database.yml/.py file(s) from spike /var/www/[site name]/config/ folder(s).
 5. Modify `/etc/apache2/ports.conf` and  `/etc/apache2/sites-available/default-ssl.conf` to point the newly pulled sites to your chosen development port(s). E.g. point http://spike.asu.edu:8000/ to show a site located in `/var/www/DevBranches/Justas/neuroml-db/www/NeuroML.org/`.
 2. Make your code changes and commit them to your forked repository. Show them to Sharon/Justas by using the port you set up in step 5.
 3. When your changes are ready to be placed into spike testing server (`/var/www/`), [create a Pull Request](https://help.github.com/articles/using-pull-requests/) to propose to merge your changes into the `master` branch.
 4. Justas or Sharon will then merge the changes in your pull request into the master branch, or will ask for additional modifications.
 5. If the changes on dendrite are ready for production. Justas or Sharon will merge the master branch into the production branch and those changes will show up on dendrite.

#(Re)Starting Websites
Websites can be restarted by restarting Apache with the following command. After logging into server: `sudo service apache2 restart`.

#Feature/Bug Tracking
Use this [repo's Issues tab](https://github.com/scrook/neuroml-db/issues) to keep track of outstanding issues and bug fixes. Use it as a ToDo list, and create issues whenever you see something that should be fixed. Close issues when they have been implemented in production.

#Logs
Log files for each website are located in the `/var/www/[website]/logs/development.log` files. 

#People

**[Sharon](https://webapp4.asu.edu/directory/person/741033)** is the lab leader and she should be consulted when undertaking all major changes to any of the above sites.

**[Suzanne](https://webapp4.asu.edu/directory/person/30085)** is a professor in the Computer Science department. She has knowledge of the way the databases are organized and coded.

**[Renate](https://webapp4.asu.edu/directory/person/85012)** helps with the maintenance of the web servers. Server access, restarts, and connection issues are usually referred to her.

**[Justas](https://webapp4.asu.edu/directory/person/2312063)** is a PhD student who worked on the Neurom-DB python search module and on the Curator. Questions about website code and how things work should usually go to him.

**[Padraig](https://iris.ucl.ac.uk/iris/browse/profile?upi=PGLEE72)** is a scientist in UK. He works with NeuroML and he knows most of Java-based code, NML validator, as well as the NML XSL files. He may know about the Ruby code on neuroml.org site code too.

**Others** There have been many other people who have worked on the site in the past. Generally, between Justas, Renate, Suzanne, and Sharon, someone will have answers, or at least have clues.

