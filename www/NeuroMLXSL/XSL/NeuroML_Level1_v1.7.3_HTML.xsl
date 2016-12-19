<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="1.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:mml="http://morphml.org/morphml/schema"
    xmlns:meta="http://morphml.org/metadata/schema" 
    xmlns:nml="http://morphml.org/neuroml/schema"
    xmlns:bio="http://morphml.org/biophysics/schema" >

<!--

    This file is used to convert MorphML files to a "neuroscientist friendly" view
    Note this doesn't by any means include all of the information present in the file, it just 
    summarises the notes, etc. embedded in the file and gives a summary of segment numbers, etc.
    
    This file has been developed as part of the neuroConstruct project
    
    Funding for this work has been received from the Medical Research Council
    
    Author: Padraig Gleeson
    
-->

<xsl:output method="html" indent="yes" />


    <!-- Just imports the main NeuroML converter. Level 1 is handled there too... -->
    <xsl:import href="NeuroML_Level2_v1.7.3_HTML.xsl"/>
    
</xsl:stylesheet>
