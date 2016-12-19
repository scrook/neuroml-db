<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="1.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:cml="http://morphml.org/channelml/schema"
    xmlns:meta="http://morphml.org/metadata/schema" 
    xmlns:net="http://morphml.org/networkml/schema" >

    <xsl:import href="../ReadableUtils.xsl"/>
    
<!--

    This file is used to convert v1.3 NetworkML files to a "neuroscientist friendly" HTML view
    This file is taken from the neuroConstruct source code
    
    This file has been developed as part of the neuroConstruct project
    
    Funding for this work has been received from the Medical Research Council
    
    Author: Padraig Gleeson
    Copyright 2006 Department of Physiology, UCL
    
-->

<xsl:output method="html" indent="yes" />



<!--Main template-->


<xsl:template match="/net:networkml">
<h3>NetworkML v1.3 file</h3>

<xsl:if test="count(/net:networkml/meta:notes) &gt; 0">
<table frame="box" rules="all" align="centre" cellpadding="4" width ="100%">
    <xsl:call-template name="tableRow">
        <xsl:with-param name="name">General notes</xsl:with-param>
        <xsl:with-param name="comment">Notes present in NetworkML file</xsl:with-param>
        <xsl:with-param name="value">&lt;b&gt;<xsl:value-of select="/net:networkml/meta:notes"/>&lt;/b&gt;</xsl:with-param>
     </xsl:call-template>
</table>
</xsl:if>

<br/>

<xsl:apply-templates  select="net:populations"/>
<xsl:apply-templates  select="net:projections"/>

</xsl:template>

<!--End Main template-->


<xsl:template match="net:populations">
<h3>Populations:</h3>

    <xsl:param name="wholeNetwork" />
    
        <xsl:for-each select="net:population">
            
            <xsl:element name="a">
                <xsl:attribute name="name">Population_<xsl:value-of select="@name"/></xsl:attribute>
            </xsl:element>
            
            <table frame="box" rules="all" align="centre" cellpadding="4" width ="100%">
                
            
                <xsl:call-template name="tableRow">
                    <xsl:with-param name="name">Name</xsl:with-param>
                    <xsl:with-param name="value">&lt;b&gt;<xsl:value-of select="@name"/>&lt;/b&gt;</xsl:with-param>
                </xsl:call-template> 
                
                <xsl:call-template name="tableRow">
                    <xsl:with-param name="name">Cell Type</xsl:with-param>
                    <xsl:with-param name="value">
                        <xsl:if test="$wholeNetwork = 'yes'">&lt;a href="#CellType_<xsl:value-of select="net:cell_type"/>"&gt;</xsl:if>
                        &lt;b&gt;<xsl:value-of select="net:cell_type"/>&lt;/b&gt;
                        <xsl:if test="$wholeNetwork = 'yes'">&lt;/a&gt;</xsl:if>
                    </xsl:with-param>
                </xsl:call-template> 
                
                <xsl:apply-templates  select="net:pop_location"/>
                
                <xsl:apply-templates  select="net:instances"/>
                 
                 
            </table>
<br/>
        </xsl:for-each>
</xsl:template>


<xsl:template match="net:pop_location">

    <xsl:apply-templates  select="net:random_arrangement"/>
    
</xsl:template>


<xsl:template match="net:random_arrangement">
    <xsl:call-template name="tableRow">
        <xsl:with-param name="name">Population size:</xsl:with-param>
        <xsl:with-param name="value">&lt;b&gt;<xsl:value-of select="net:population_size"/>&lt;/b&gt;</xsl:with-param>
    </xsl:call-template> 
    <xsl:call-template name="tableRow">
        <xsl:with-param name="name">Arrangement of cells:</xsl:with-param>
        <xsl:with-param name="value">&lt;b&gt;Randomly placed in region&lt;/b&gt;</xsl:with-param>
    </xsl:call-template> 
    
</xsl:template>


<xsl:template match="net:instances">
    <xsl:call-template name="tableRow">
        <xsl:with-param name="name"><xsl:value-of select="count(net:instance)"/> Instances</xsl:with-param>
        <xsl:with-param name="value">
            <xsl:for-each select="net:instance">&lt;p&gt;&lt;b&gt;Instance <xsl:value-of select="@id"/>: (<xsl:value-of select="net:location/@x"/>, <xsl:value-of select="net:location/@y"/>, <xsl:value-of select="net:location/@z"/>)
            &lt;/b&gt;&lt;/p&gt;</xsl:for-each></xsl:with-param>
    </xsl:call-template> 
    
</xsl:template>


<xsl:template match="net:potentialSynapticLocation">
    <xsl:call-template name="tableRow">
        <xsl:with-param name="name">Potential Synaptic Location</xsl:with-param>
        <xsl:with-param name="comment">The synapse type specified is allowed on a subset of cell segments/cables</xsl:with-param>
        <xsl:with-param name="value"><xsl:choose><xsl:when test="net:synapse_direction = 'pre'">A presynaptic</xsl:when>
        <xsl:when test="net:synapse_direction = 'post'">A postsynaptic</xsl:when>
        <xsl:when test="net:synapse_direction = 'preAndOrPost'">Either a pre or a postsynaptic</xsl:when></xsl:choose>  
 connection using type: &lt;b&gt;<xsl:value-of select="net:synapse_type"/>&lt;/b&gt; is allowed on: &lt;b&gt;<xsl:for-each select="net:group"><xsl:value-of select="."/> </xsl:for-each>&lt;/b&gt;</xsl:with-param>
    </xsl:call-template> 
    
</xsl:template>


<xsl:template match="net:projections">
<h3>Projections:</h3>

    <xsl:param name="wholeNetwork" />
    
        <xsl:for-each select="net:projection">
            
            <table frame="box" rules="all" align="centre" cellpadding="4" width ="100%">
            
                <xsl:call-template name="tableRow">
                    <xsl:with-param name="name">Projection</xsl:with-param>
                    <xsl:with-param name="value">&lt;b&gt;<xsl:value-of select="@name"/>&lt;/b&gt;</xsl:with-param>
                </xsl:call-template>     
        
                <xsl:call-template name="tableRow">
                    <xsl:with-param name="name">From:</xsl:with-param>
                    <xsl:with-param name="value">&lt;a href="#Population_<xsl:value-of select="net:source"/>"&gt; &lt;b&gt;<xsl:value-of select="net:source"/>&lt;/b&gt;&lt;/a&gt; </xsl:with-param>
                </xsl:call-template>          
   
                <xsl:call-template name="tableRow">
                    <xsl:with-param name="name">To:</xsl:with-param>
                    <xsl:with-param name="value">&lt;a href="#Population_<xsl:value-of select="net:target"/>"&gt; &lt;b&gt;<xsl:value-of select="net:target"/>&lt;/b&gt;&lt;/a&gt;</xsl:with-param>
                </xsl:call-template> 
                
                <xsl:apply-templates  select="net:synapse_props">
                    <xsl:with-param name="wholeNetwork"><xsl:value-of select="$wholeNetwork"/></xsl:with-param>
                </xsl:apply-templates>
                
                <xsl:apply-templates  select="net:connections"/>
                                
            </table>
        <br/>
        </xsl:for-each>
</xsl:template>



<xsl:template match="net:synapse_props">
    
    <xsl:param name="wholeNetwork" />
    
                   <xsl:call-template name="tableRow">
                    <xsl:with-param name="name">Synaptic properties</xsl:with-param>
                    <xsl:with-param name="value">&lt;p&gt;&lt;b&gt;Type: 

                    <xsl:if test="$wholeNetwork = 'yes'">&lt;a href="#Synapse_<xsl:value-of select="net:synapse_type"/>"&gt;</xsl:if>

<xsl:value-of select="net:synapse_type"/>


                    <xsl:if test="$wholeNetwork = 'yes'">&lt;/a&gt;</xsl:if>
                    
&lt;/b&gt;&lt;/p&gt;
                    &lt;p&gt;&lt;b&gt;Delay: <xsl:value-of select="net:internal_delay"/> (internal)&lt;/b&gt;&lt;/p&gt;
                    <xsl:if test="count(net:pre_delay) &gt; 0">&lt;p&gt;&lt;b&gt;Delay: <xsl:value-of select="net:pre_delay"/> (presynaptic component)&lt;/b&gt;&lt;/p&gt;</xsl:if>
                    <xsl:if test="count(net:post_delay) &gt; 0">&lt;p&gt;&lt;b&gt;Delay: <xsl:value-of select="net:post_delay"/> (postsynaptic component)&lt;/b&gt;&lt;/p&gt;</xsl:if>
                    <xsl:if test="count(net:prop_delay) &gt; 0">&lt;p&gt;&lt;b&gt;Delay: <xsl:value-of select="net:prop_delay"/> (AP propagation component)&lt;/b&gt;&lt;/p&gt;</xsl:if>
                    
                    
                    &lt;p&gt;&lt;b&gt;Weight: <xsl:value-of select="net:weight"/>&lt;/b&gt;&lt;/p&gt;
                    &lt;p&gt;&lt;b&gt;Threshold: <xsl:value-of select="net:threshold"/>&lt;/b&gt;&lt;/p&gt;</xsl:with-param>
                    
                   
                </xsl:call-template>     
</xsl:template>


<xsl:template match="net:connections">
<xsl:if test="count(net:connection) &gt; 0">
    <xsl:call-template name="tableRow">
        <xsl:with-param name="name"><xsl:value-of select="count(net:connection)"/> connection instance(s):</xsl:with-param>
        <xsl:with-param name="value">
            <xsl:for-each select="net:connection">
                    &lt;p&gt;&lt;b&gt;From segment <xsl:value-of select="net:pre/@segment_id"/> on source cell <xsl:value-of select="net:pre/@cell_id"/>
                    to segment <xsl:value-of select="net:post/@segment_id"/> on target cell <xsl:value-of select="net:post/@cell_id"/>


                    <xsl:if test="count(net:internal_delay) &gt; 0">, delay: <xsl:value-of select="net:internal_delay"/> (internal)</xsl:if>
                    <xsl:if test="count(net:pre_delay) &gt; 0">, delay: <xsl:value-of select="net:pre_delay"/> (presynaptic component)</xsl:if>
                    <xsl:if test="count(net:post_delay) &gt; 0">, delay: <xsl:value-of select="net:post_delay"/> (postsynaptic component)</xsl:if>
                    <xsl:if test="count(net:prop_delay) &gt; 0">, delay: <xsl:value-of select="net:prop_delay"/> (AP propagation component)</xsl:if>
                    <xsl:if test="count(net:weight) &gt; 0">, weight: <xsl:value-of select="net:weight"/></xsl:if>


&lt;/b&gt;&lt;/p&gt;
            </xsl:for-each>
        </xsl:with-param>
                </xsl:call-template>     
                </xsl:if>
</xsl:template>







</xsl:stylesheet>
