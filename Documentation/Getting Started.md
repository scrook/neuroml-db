Note: Treat this as a live-document, and please update it if you find any mistakes.

# Websites

These are the main websites:
 - [NeuroML.org](https://NeuroML.org)
 - [NeuroML-DB.org](https://neuroml-db.org)
 - Curator

#Servers

There are two servers:
 - [Dendrite](dendrite.asu.edu)
 - [Spike](spike.asu.edu)
 
**Dendrite** is/should be the "production" server. All live/publicly exposed sites should be located on this server.

**Spike** is the "testing/staging" server. All code changes should be made here, and moved to Dendrite only after they pass QA (Sharon). 
There are some folders on this server that host live sites. When you can, please move these to dendrite.

The prefered development cycle should be: Local machine -> Spike -> Dendrite

##Access

Both are Ubuntu servers, and SSH'ing into them is the general work flow. Renate (see below) can give you access to the servers. 
Note that these servers cannot be SSH'd into from outside of ASU network. You'll need to [VPN](https://startpage.com/do/search?q=arizona+state+university+vpn&lui=english) in or connect from campus.

The physical servers are maintained by [Renate Mittelmann](https://webapp4.asu.edu/directory/person/85012). Her office is on the same floor as Sharon. See the directory link for contact info.
Any questions about usernames, passwords, access, backups, restarts, and scheduled maintenance should be directed to her.

#Folders

#Databases

#People

**Sharon** is the lab leader and she should be consulted when undertaking all major changes to any of the above sites.

**Suzanne** is a professor in the Computer Science department. She has knowledge of the way the databases are organized and coded.

**Renate** helps with the maintenance of the web servers. Server access, restarts, and connection issues are usually referred to her.

**Justas** is a PhD student who, since Spring 2015  worked on the Neurom-DB python search module. Also started work on the Curator. Questions about website code and how things work should usually go to him.

**Padraig** is a scientist in UK. He works with NeuroML and he knows most of Java-based code, NML validator, as well as the XSL. He may know about the Ruby code on neuroml.org site code as well.

**Others** There have been many other people who have worked on the site in the past. Generally, between Justas, Renate, Suzanne, and Sharon, someone will have answers, or will at least give clues.

#Architecture

