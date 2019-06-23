(function() {
    // Create the connector object
    var myConnector = tableau.makeConnector();

    // Define the schema
    myConnector.getSchema = function(schemaCallback) {

        var cells = {
            id: "cells",
            alias: "Cell Model Info",
            columns: [
                {
                    id: "Model_ID",
                    dataType: tableau.dataTypeEnum.string
                }, 
                {
                    id: "Name",
                    dataType: tableau.dataTypeEnum.string
                },
                {
                    id: "Type",
                    dataType: tableau.dataTypeEnum.string
                },
                {
                    id: "AP1DelayMeanStrongStim",
                    alias: "Delay to 1st AP (ms)",
                    dataType: tableau.dataTypeEnum.float
                },
                {
                    id: "ISIMedian",
                    alias: "Median Interspike Interval (ms)",
                    dataType: tableau.dataTypeEnum.float
                },
                {
                    id: "AccommodationAtSSMean",
                    alias: "Accommodation at Steady State (%)",
                    dataType: tableau.dataTypeEnum.float
                },
                {
                    id: "Publication",
                    dataType: tableau.dataTypeEnum.string
                },
                {
                    id: "Cluster",
                    dataType: tableau.dataTypeEnum.string
                }
            ]
        };

        schemaCallback([cells]);
    };
       
    myConnector.parseCell = function(cell_resp) {
        return {
            "Model_ID":                 cell_resp.model.Model_ID,
            "Type":                     cell_resp.model.Type,
            "Name":                     cell_resp.model.Name,
            "AP1DelayMeanStrongStim":   cell_resp.model.AP1DelayMeanStrongStim,
            "ISIMedian":                cell_resp.model.ISIMedian,
            "AccommodationAtSSMean":    cell_resp.model.AccommodationAtSSMean,
            "Publication":              cell_resp.publication.short,
            "Cluster":                  cell_resp.ephyz_clusters[cell_resp.ephyz_clusters.length-1].Name
        }
    };

    // Download the data
    myConnector.getData = function(table, doneCallback) {
        $.getJSON("https://neuroml-db.org/api/models", function(resp) {
            var models = resp,
                tableData = [],
                cellCount = 0;

            // Iterate over the JSON object
            for (var i = 0, len = models.length; i < len; i++) {
                var model = models[i];

                if (model.Type == "CL") {
                    cellCount += 1;

                    $.getJSON("https://neuroml-db.org/api/model?id="+model.Model_ID, function(cell_resp) {
                        tableData.push(myConnector.parseCell(cell_resp));

                        if(tableData.length == cellCount) {
                            table.appendRows(tableData);
                            doneCallback();
                        }
                    });
                }
            }
        });
    };

    tableau.registerConnector(myConnector);

    // Create event listeners for when the user submits the form
    $(document).ready(function() {
        $("#submitButton").click(function() {
            tableau.connectionName = "NeuroML Database Models"; // This will be the data source name in Tableau
            tableau.submit(); // This sends the connector object to Tableau
        });
    });
})();
