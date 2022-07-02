set -e

# Ensure www-data (apache user) has access to website files
chown -R www-data:www-data /var/www/

# Start fuseki in background,
# Data is stored in /OntologyData,
# "/NeuroMLOntology" is the name of the fuseki database
# Starts on port 3030
echo 'Starting fuseki server...'
/fuseki/fuseki start
curl http://localhost:3030/NeuroMLOntology/ >> /dev/null

# Start apache
echo 'Starting apache server...'
apache2ctl start

# Start shell / Run forever
cd /var/www/NeuroML-DB.org
bash