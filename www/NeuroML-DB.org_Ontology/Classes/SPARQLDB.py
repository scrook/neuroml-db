import json  
import os  
import urllib
import urllib2
import subprocess
import time


class SPARQLDB:
    def __init__(self):

        self.EndPointUrl = "http://localhost:3030/NeuroMLOntology/query"
        self.ServerUrl = "http://localhost:3030/"

        # Check if fuseki server is up
        self.CheckIfUpAndStartIfNeeded()

    def CheckIfUpAndStartIfNeeded(self):

        if not self.IsUp():
            self.Start()

            secondsWaited = 0
            while secondsWaited < 30:
                time.sleep(1)
                secondsWaited += 1

                if self.IsUp():
                    return

            raise Exception("Could not start SPARQL Fuseki server")

        else:
            return

    def IsUp(self):

        # Check if the server home page loads ok
        request = urllib2.Request(self.ServerUrl)

        try:
            response = urllib2.urlopen(request)

        except urllib2.URLError:
            return False

        return response.getcode() == 200

    def Start(self):

        # Start fuseki server from command line as background process
        # Command: fuseki-server --loc=Data /NeuroMLOntology
        # Explanation:
        #   "FUSEKI_HOME=xyz" env variable needed by the server
        #   "fuseki-server" server executable
        #   "Data" ~/fuseki/Data is where db files are stored
        #   "/NeuroMLOntology" the name of the ontology DB

        os.putenv("FUSEKI_HOME", "/opt/fuseki")

        subprocess.Popen([
            "nohup",
            "/opt/fuseki/fuseki-server",
            "--loc=/opt/fuseki/Data",
            "/NeuroMLOntology",
            ">",
            "/dev/null",
            "2>&1&"
        ])

    def Query(self, query):

        values = {
            'query': query,
            'output': 'json',
        }
        data = urllib.urlencode(values)
        request = urllib2.Request(self.EndPointUrl, data)
        response = urllib2.urlopen(request)
        responseText = response.read()

        # Remove domains from results
        responseText = responseText \
            .replace("http://neurolex.org/wiki/Property-3A", "") \
            .replace("http://neurolex.org/wiki/Category-3A", "") \
            .replace("u'", "'")

        jsonResult = json.loads(responseText)
        bindings = jsonResult["results"]["bindings"]

        return bindings

    def BuildValuesString(self, valueList):

        result = ""

        for value in valueList:
            result += '"' + value + '"^^xsd:string \n'

        return result
