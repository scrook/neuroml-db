# NeuroML Websites
Source code and documentation for NeuroML-DB.org and NeuroML-DB Curator.

# Steps to start website:

Ensure you have docker installed and are running Ubuntu.

 1. Clone repo with `git@github.com:scrook/neuroml-db.git`
 2. Copy the following secrets files from dendrite:

```
From `/var/www/NeuroML-DB.org/config/database.yml` to:
   `[repo]/www/NeuroML-DB.org/config/database.yml`

From `/var/www/NeuroML-DB.org/config/initializers/secret_token.rb` to 
   `[repo]/www/NeuroML-DB.org/config/initializers/secret_token.rb`

From `/var/www/NeuroML-DB.org_Ontology/database.py` to 
   `[repo]/www/NeuroML-DB.org_Ontology/database.py`
```

 4. `cd neuroml-db/www/NeuroML-DB.org_Docker`
 5. `./run.sh` This will build the site docker image and start the website on port 8000
