Note: Treat this as a live-document, and please update it if you find any mistakes. Also add anything that would be useful for newcomers.

# Websites

These are the main websites:
 - [NeuroML.org](https://NeuroML.org)
 - [NeuroML-DB.org](https://neuroml-db.org)
 - [Curator](https://spike.asu.edu:5051/add_cell)

#Architecture

**NeuroML.org**
This is a Ruby on Rails site that uses [Redmine](http://www.redmine.org/) as the starting point. Apache server redirects  domain requests to a Ruby [Webrick](https://en.wikipedia.org/wiki/WEBrick) server , which then serves the Ruby site. This site talks to a MySQL server. There are also some Java files for NeuroML validation functionality. Apache redirects requests to those subfolders to a Tomcat server that handles the validator requests. All this happens on the same physical server.

**NeuroML-DB.org**
Also a Ruby on Rails site, based on Redmine, runs on Webrick (http://dendrite.asu.edu:5000/) and talks to the MySQL server. There is an interface for the search engine that executes Python code to return the search results. The Python code talks to a [Fuseki](https://jena.apache.org/documentation/fuseki2/) server that stores the ontology tripples. It also talks to the MySQL server. 

**Curator**
Also a Ruby on Rails site, based on Redmine, and talks to the MySQL server. This site is mostly used as a UI to manage the models displayed in the NeuroML-DB.org site. It reads and writes the same database that NeuroML-DB points to.

#Servers

There are two servers:
 - dendrite.asu.edu
 - spike.asu.edu
 
**Dendrite** is/should be the "production" server. All live/publicly exposed sites should be located on this server. This server should be kept as clean as possible.

**Spike** is the "testing/staging" server. All code changes should be made here, and moved to Dendrite only after they pass QA (Sharon). There are some folders on this server that host live sites (i.e. Curator). When you can, please move these to dendrite. In general, Spike is a mess, and has taken lots of abuse over the years. It badly needs to be cleaned up. Whenever you make code changes, please leave Spike in a better shape than you found it.

The prefered development cycle should be: Local machine -> Spike -> Dendrite

##Server Access

Both are Ubuntu servers, and SSH'ing into them is the general workflow. Renate (see below) can give you access to the servers. 
Note that these servers cannot be SSH'd into from outside of ASU network. You'll need to [VPN](https://startpage.com/do/search?q=arizona+state+university+vpn&lui=english) in or connect from campus.

The physical servers are maintained by [Renate Mittelmann](https://webapp4.asu.edu/directory/person/85012). Her office is on the same floor as Sharon. See the directory link for contact info. Any questions about usernames, passwords, access, backups, restarts, and scheduled maintenance should be directed to her.

##SSH
Connect to the servers using the following params:
 - Host: dendrite(or spike).asu.edu
 - Port: 2200
 - Username & pwd: the set you received from Renate

#Folders
Once inside the servers, following folders are useful:

**Dendrite**: The Production Server
 - /var/www/NeuroML_Web: NeuroML.org *Ruby on Rails* site files
 - /var/www/neuroml-db.org: NeuroML-DB.org *Ruby on Rails* portion of the site
 - /var/www/neuroml-db.org_ontology: NeuroML-DB.org *Python* portion of the site

**Spike**: The Testing Server
 - /home/neuromine/neuroml_curator: Curator *Ruby on Rails* code. This is waiting to be moved to dendrite. Even better if the code for neuroml-db.org, neuroml.org, and curator was combined as there is significant overlap.
 - /home/neuromine: For historical reasons, this is where many of the sites had their code located.
 - /var/www: This is where testing sites should be located, mirroring the folder names found on Dendrite. As of this writing, they're not. When making the next change, consider copying the production site into this folder, then repointing the database.

#Databases

Dendrite and Spike both function as web and DB servers. Both have MySQL database servers installed with several databases each. You will need to SSH into the server first, then establish a MySQL connection. Ask Renate to create a DB username for you. Also, connection to the MySQL server only works from ASU campus/VPN.

The Ruby sites connect to different dabatases and the best way to find out which one the site is using is by looking at the **[site root]/config/database.yml** file.

Dendrite and Dendrite Databases:
 - neuromldb: This is the main db used by neuroml-db.org
 - neuroml_dev: This is an old db. I believe we're trying to move away from it and into neuromldb. 

#Source Code
Ideally, all source code should be in github in this repo. Probably that's not the case. You should look in one of the folders above for the source code. At some point this should changed, so the production servers get the source code from the production branch of the repo, and run some units tests before making the site available. 

All code for NeuroML-db.org should be in this repo. Not sure about other sites. If it's not, it should be.

Treat the main branch of this repo as the testing branch, then merge your changes to production branch when ready to release the build.


#Ports
 - NeuroML.org runs on port 5001: http://dendrite.asu.edu:5001/
 - NeuroML-DB.org runs on port 5000: http://dendrite.asu.edu:5000/
 - Curator runs on port 5051: https://spike.asu.edu:5051/

The domains are mapped to the ports through the apache config files located on **dendrite** under /etc/apache2/httpd-nml2.conf and sibling files. This folder also configures the SSL/HTTPS certificates.

#(Re)Starting Websites

On **Dendrite**:
 - Generally Renate will restart the websites on Dendrite. However, the contents of the restartruby file on Spike can be examined to get the commands to restart the webrick and fuseki servers. Apache server can be restarted by restarting the apache2 service.

On **Spike**:
 - In /home/neuromine there is a script restartruby. Running the script with ./restartruby should restart the ruby sites & and the Fuseki server. 

#Feature/Bug Tracking
Use this [repo's Issues tab](https://github.com/scrook/neuroml-db/issues) to keep track of outstanding issues and bug fixes. Use it as a ToDo list, and create issues whenever you see something that should be fixed. Close issues when they have been implemented in production.

#People

**[Sharon](https://webapp4.asu.edu/directory/person/741033)** is the lab leader and she should be consulted when undertaking all major changes to any of the above sites.

**[Suzanne](https://webapp4.asu.edu/directory/person/30085)** is a professor in the Computer Science department. She has knowledge of the way the databases are organized and coded.

**[Renate](https://webapp4.asu.edu/directory/person/85012)** helps with the maintenance of the web servers. Server access, restarts, and connection issues are usually referred to her.

**[Justas](https://webapp4.asu.edu/directory/person/2312063)** is a PhD student who worked on the Neurom-DB python search module and on the Curator. Questions about website code and how things work should usually go to him.

**[Padraig](https://iris.ucl.ac.uk/iris/browse/profile?upi=PGLEE72)** is a scientist in UK. He works with NeuroML and he knows most of Java-based code, NML validator, as well as the NML XSL files. He may know about the Ruby code on neuroml.org site code too.

**Others** There have been many other people who have worked on the site in the past. Generally, between Justas, Renate, Suzanne, and Sharon, someone will have answers, or at least have clues.

