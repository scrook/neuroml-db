  <!--  <?xml version="1.0" encoding="UTF-8"?> -->
    <xsl:stylesheet version="2.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:nml="http://www.neuroml.org/schema/neuroml2" >
<xsl:output method="html" indent="yes" />
    
    <!--Main Level 2 template-->

    <xsl:template match="/nml:neuroml">
        <html>
            <title>NeuroML 2 file: <xsl:value-of select="@id"/></title>
            <h2>NeuroML 2 file: <xsl:value-of select="@id"/></h2>

            <xsl:apply-templates/>

            <br/>
        </html>

    </xsl:template>
    <!--End Main template-->
<xsl:template match="nml:blockingPlasticSynapse">

<table frame="box" rules="all" align="centre" cellpadding="4" width ="100%">
<tr>
<td>Name:</td>
<td><xsl:value-of select="name(.)" /></td>
</tr>

<xsl:for-each select="@*">
<tr>

<td>
<xsl:value-of select="name()" />
</td>
<td>
<xsl:value-of select="." />
</td>
</tr>
</xsl:for-each>
</table>


</xsl:template>


<xsl:template match="nml:IF_curr_alpha">

<table frame="box" rules="all" align="centre" cellpadding="4" width ="100%">
<tr>
<td>Name:</td>
<td><xsl:value-of select="name(.)" /></td>
</tr>

<xsl:for-each select="@*">
<tr>

<td>
<xsl:value-of select="name()" />
</td>
<td>
<xsl:value-of select="." />
</td>
</tr>
</xsl:for-each>
</table>


</xsl:template>


<xsl:template match="nml:IF_curr_exp">

<table frame="box" rules="all" align="centre" cellpadding="4" width ="100%">
<tr>
<td>Name:</td>
<td><xsl:value-of select="name(.)" /></td>
</tr>

<xsl:for-each select="@*">
<tr>

<td>
<xsl:value-of select="name()" />
</td>
<td>
<xsl:value-of select="." />
</td>
</tr>
</xsl:for-each>
</table>


</xsl:template>


<xsl:template match="nml:IF_cond_alpha">

<table frame="box" rules="all" align="centre" cellpadding="4" width ="100%">
<tr>
<td>Name:</td>
<td><xsl:value-of select="name(.)" /></td>
</tr>

<xsl:for-each select="@*">
<tr>

<td>
<xsl:value-of select="name()" />
</td>
<td>
<xsl:value-of select="." />
</td>
</tr>
</xsl:for-each>
</table>


</xsl:template>


<xsl:template match="nml:IF_cond_exp">

<table frame="box" rules="all" align="centre" cellpadding="4" width ="100%">
<tr>
<td>Name:</td>
<td><xsl:value-of select="name(.)" /></td>
</tr>

<xsl:for-each select="@*">
<tr>

<td>
<xsl:value-of select="name()" />
</td>
<td>
<xsl:value-of select="." />
</td>
</tr>
</xsl:for-each>
</table>


</xsl:template>


<xsl:template match="nml:EIF_cond_exp_isfa_ista">

<table frame="box" rules="all" align="centre" cellpadding="4" width ="100%">
<tr>
<td>Name:</td>
<td><xsl:value-of select="name(.)" /></td>
</tr>

<xsl:for-each select="@*">
<tr>

<td>
<xsl:value-of select="name()" />
</td>
<td>
<xsl:value-of select="." />
</td>
</tr>
</xsl:for-each>
</table>


</xsl:template>

<xsl:template match="nml:HH_cond_exp">

<table frame="box" rules="all" align="centre" cellpadding="4" width ="100%">
<tr>
<td>Name:</td>
<td><xsl:value-of select="name(.)" /></td>
</tr>

<xsl:for-each select="@*">
<tr>

<td>
<xsl:value-of select="name()" />
</td>
<td>
<xsl:value-of select="." />
</td>
</tr>
</xsl:for-each>
</table>


</xsl:template>



<xsl:template match="nml:expCondSynapse">

<table frame="box" rules="all" align="centre" cellpadding="4" width ="100%">
<tr>
<td>Name:</td>
<td><xsl:value-of select="name(.)" /></td>
</tr>

<xsl:for-each select="@*">
<tr>

<td>
<xsl:value-of select="name()" />
</td>
<td>
<xsl:value-of select="." />
</td>
</tr>
</xsl:for-each>
</table>


</xsl:template>



<xsl:template match="nml:alphaCondSynapse">

<table frame="box" rules="all" align="centre" cellpadding="4" width ="100%">
<tr>
<td>Name:</td>
<td><xsl:value-of select="name(.)" /></td>
</tr>

<xsl:for-each select="@*">
<tr>

<td>
<xsl:value-of select="name()" />
</td>
<td>
<xsl:value-of select="." />
</td>
</tr>
</xsl:for-each>
</table>


</xsl:template>

<xsl:template match="nml:SpikeSourcePoisson">

<table frame="box" rules="all" align="centre" cellpadding="4" width ="100%">
<tr>
<td>Name:</td>
<td><xsl:value-of select="name(.)" /></td>
</tr>

<xsl:for-each select="@*">
<tr>

<td>
<xsl:value-of select="name()" />
</td>
<td>
<xsl:value-of select="." />
</td>
</tr>
</xsl:for-each>
</table>


</xsl:template>

<xsl:template match="nml:pulseGenerator">
<h4>Pulse Generator</h4><br />
<table frame="box" rules="all" align="centre" cellpadding="4" width ="100%">
<tr>
<td>Cell Name:</td>
<td><xsl:value-of select="name(.)" /></td>
</tr>

<xsl:for-each select="@*">
<tr>

<td>
<xsl:value-of select="name()" />
</td>
<td>
<xsl:value-of select="." />
</td>
</tr>
</xsl:for-each>
</table>


</xsl:template>

<xsl:template match="nml:sineGenerator">
<h4>Sine Generator</h4><br />
<table frame="box" rules="all" align="centre" cellpadding="4" width ="100%">
<tr>
<td>Name:</td>
<td><xsl:value-of select="name(.)" /></td>
</tr>

<xsl:for-each select="@*">
<tr>

<td>
<xsl:value-of select="name()" />
</td>
<td>
<xsl:value-of select="." />
</td>
</tr>
</xsl:for-each>
</table>


</xsl:template>

<xsl:template match="nml:rampGenerator">
<h4>Ramp Generator</h4><br />
<table frame="box" rules="all" align="centre" cellpadding="4" width ="100%">
<tr>
<td>Name:</td>
<td><xsl:value-of select="name(.)" /></td>
</tr>

<xsl:for-each select="@*">
<tr>

<td>
<xsl:value-of select="name()" />
</td>
<td>
<xsl:value-of select="." />
</td>
</tr>
</xsl:for-each>
</table>


</xsl:template>



<xsl:template match="nml:voltageClamp">
<h4>Voltage Clamp</h4><br />
<table frame="box" rules="all" align="centre" cellpadding="4" width ="100%">
<tr>
<td>Name:</td>
<td><xsl:value-of select="name(.)" /></td>
</tr>

<xsl:for-each select="@*">
<tr>

<td>
<xsl:value-of select="name()" />
</td>
<td>
<xsl:value-of select="." />
</td>
</tr>
</xsl:for-each>
</table>


</xsl:template>



<xsl:template match="nml:spikeArray/*">
<h4>Spike Array</h4><br />
<table frame="box" rules="all" align="centre" cellpadding="4" width ="100%">
<tr>
<td>Name:</td>
<td><xsl:value-of select="name(.)" /></td>
</tr>

<xsl:for-each select="@*">
<tr>

<td>
<xsl:value-of select="name()" />
</td>
<td>
<xsl:value-of select="." />
</td>
</tr>
</xsl:for-each>
</table>


</xsl:template>


<xsl:template match="nml:spikeGenerator">
<h4>Spike Generator</h4><br />
<table frame="box" rules="all" align="centre" cellpadding="4" width ="100%">
<tr>
<td>Name:</td>
<td><xsl:value-of select="name(.)" /></td>
</tr>

<xsl:for-each select="@*">
<tr>

<td>
<xsl:value-of select="name()" />
</td>
<td>
<xsl:value-of select="." />
</td>
</tr>
</xsl:for-each>
</table>


</xsl:template>


<xsl:template match="nml:spikeGeneratorRandom">
<h4>Spike Generator Random</h4>
<table frame="box" rules="all" align="centre" cellpadding="4" width ="100%">
<tr>
<td>Name:</td>
<td><xsl:value-of select="name(.)" /></td>
</tr>

<xsl:for-each select="@*">
<tr>

<td>
<xsl:value-of select="name()" />
</td>
<td>
<xsl:value-of select="." />
</td>
</tr>
</xsl:for-each>
</table>


</xsl:template>

<xsl:template match="nml:spikeGeneratorPoisson">
<h4>Spike Generator Poisson</h4><br />
<table frame="box" rules="all" align="centre" cellpadding="4" width ="100%">
<tr>
<td>Name:</td>
<td><xsl:value-of select="name(.)" /></td>
</tr>

<xsl:for-each select="@*">
<tr>

<td>
<xsl:value-of select="name()" />
</td>
<td>
<xsl:value-of select="." />
</td>
</tr>
</xsl:for-each>
</table>


</xsl:template>



<xsl:template match="nml:abstractCells/*">

<table frame="box" rules="all" align="centre" cellpadding="4" width ="100%">
<tr>
<td>Cell Name:</td>
<td><xsl:value-of select="name(.)" /></td>
</tr>

<xsl:for-each select="@*">
<tr>

<td>
<xsl:value-of select="name()" />       
</td>
<td>
<xsl:value-of select="." /> 
</td>
</tr>
</xsl:for-each>
</table>


</xsl:template>

<xsl:template match="nml:ionChannelHH/*">

<table frame="box" rules="all" align="centre" cellpadding="4" width ="100%">
<tr>
<td>Channel:</td>
<td><xsl:value-of select="name(.)" /></td>
</tr>

<xsl:for-each select="@*">
<tr>

<td>
<xsl:value-of select="name()" />
</td>
<td>
<xsl:value-of select="." />
</td>
</tr>
</xsl:for-each>
</table>


</xsl:template>

<xsl:template match="nml:ionChannelHH">

<table frame="box" rules="all" align="centre" cellpadding="4" width ="100%">
<tr>
<td>Channel:</td>
<td><xsl:value-of select="name(.)" /></td>
</tr>

<xsl:for-each select="@*">
<tr>

<td>
<xsl:value-of select="name()" />
</td>
<td>
<xsl:value-of select="." />
</td>
</tr>
</xsl:for-each>
</table>


</xsl:template>





<xsl:template match="nml:expTwoSynapse">

<table frame="box" rules="all" align="centre" cellpadding="4" width ="100%">
<tr>
<td>Cell Name:</td>
<td><xsl:value-of select="name(.)" /></td>
</tr>

<xsl:for-each select="@*">
<tr>

<td>
<xsl:value-of select="name()" />
</td>
<td>
<xsl:value-of select="." />
</td>
</tr>
</xsl:for-each>
</table>


</xsl:template>



    <xsl:template match="nml:cell">
        <xsl:element name="a">
            <xsl:attribute name="name">Cell: <xsl:value-of select="@id"/></xsl:attribute>
        </xsl:element>
        <h3>Cell: <xsl:value-of select="@id"/></h3>


        <table frame="box" rules="all" align="centre" cellpadding="4" width ="100%">
            <xsl:call-template name="tableRow">
                <xsl:with-param name="name">ID</xsl:with-param>
                <xsl:with-param name="value">&lt;b&gt;<xsl:value-of select="@id"/>&lt;/b&gt;</xsl:with-param>
            </xsl:call-template>

            <xsl:call-template name="tableRow">
                <xsl:with-param name="name">Type</xsl:with-param>
                <xsl:with-param name="value">&lt;b&gt;&lt;a href="http://www.neuroml.org/NeuroML2CoreTypes/Cells.html#cell"&gt;cell&lt;/a&gt;&lt;/b&gt;</xsl:with-param>
            </xsl:call-template>

            <xsl:if test="count(notes) &gt; 0">
                <xsl:call-template name="tableRow">
                    <xsl:with-param name="name">Description</xsl:with-param>
                    <xsl:with-param name="comment">As described in the NeuroML file</xsl:with-param>
                    <xsl:with-param name="value">&lt;b&gt;<xsl:value-of select="notes"/>&lt;/b&gt;</xsl:with-param>
                </xsl:call-template>
            </xsl:if>
        
        
        <xsl:call-template name="tableRow">
            <xsl:with-param name="name">Total number of segments</xsl:with-param>
            <xsl:with-param name="value">&lt;b&gt;<xsl:value-of select="count(nml:morphology/nml:segment)"/>&lt;/b&gt;</xsl:with-param>
        </xsl:call-template>

        <xsl:call-template name="tableRow">
            <xsl:with-param name="name">Total number of segment groups</xsl:with-param>
            <xsl:with-param name="value">&lt;b&gt;<xsl:value-of select="count(nml:morphology/nml:segmentGroup)"/>
            </xsl:with-param>
        </xsl:call-template>
                
        </table>







<br />
     <h3>Bio physical properties of <xsl:value-of select="@id"/> </h3>
<h4>Membrane Properties</h4>
count:<xsl:value-of select="count(nml:biophysicalProperties/nml:membraneProperties/nml:channelDensity)"/>
<table frame="box" rules="all" align="centre" cellpadding="4" width ="100%">
<xsl:for-each select="nml:biophysicalProperties/nml:membraneProperties/nml:channelDensity">

<xsl:call-template name="tableRow">
<xsl:with-param name="name">Channel Deinsity Id:</xsl:with-param>
<xsl:with-param name="value"><xsl:value-of select="@id"/></xsl:with-param>
</xsl:call-template>
<xsl:call-template name="tableRow">
<xsl:with-param name="name">ionChannel</xsl:with-param>
<xsl:with-param name="value"><xsl:value-of select="@ionChannel"/></xsl:with-param>
</xsl:call-template>
<xsl:call-template name="tableRow">
<xsl:with-param name="name">condDensity</xsl:with-param>
<xsl:with-param name="value"><xsl:value-of select="@condDensity"/></xsl:with-param>
</xsl:call-template>
<xsl:call-template name="tableRow">
<xsl:with-param name="name">erev</xsl:with-param>
<xsl:with-param name="value"><xsl:value-of select="@erev"/></xsl:with-param>

</xsl:call-template>
</xsl:for-each>

<xsl:for-each select="nml:biophysicalProperties/nml:membraneProperties/nml:spikeThresh">
<xsl:call-template name="tableRow">
<xsl:with-param name="name">Spike Thresh</xsl:with-param>
<xsl:with-param name="value"><xsl:value-of select="@value"/></xsl:with-param>
</xsl:call-template>
</xsl:for-each>

<xsl:for-each select="nml:biophysicalProperties/nml:membraneProperties/nml:specificCapacitance">
<xsl:call-template name="tableRow">
<xsl:with-param name="name">Specific Capacitance</xsl:with-param>
<xsl:with-param name="value"><xsl:value-of select="@value"/></xsl:with-param>
</xsl:call-template>
</xsl:for-each>


<xsl:for-each select="nml:biophysicalProperties/nml:membraneProperties/nml:initMembPotential">
<xsl:call-template name="tableRow">
<xsl:with-param name="name">initMembPotential</xsl:with-param>
<xsl:with-param name="value"><xsl:value-of select="@value"/></xsl:with-param>
</xsl:call-template>
</xsl:for-each>

</table>
<h4>Intra cellular properties</h4>
<table frame="box" rules="all" align="centre" cellpadding="4" width ="100%">
<xsl:for-each select="nml:biophysicalProperties/nml:intracellularProperties/nml:resistivity">
<xsl:call-template name="tableRow">
<xsl:with-param name="name">Resistivity</xsl:with-param>
<xsl:with-param name="value"><xsl:value-of select="@value"/></xsl:with-param>
</xsl:call-template>
</xsl:for-each>
</table>



    </xsl:template>

    <xsl:template match="nml:expOneSynapse">
        
        <xsl:element name="a">
            <xsl:attribute name="name">Synapse: <xsl:value-of select="@id"/></xsl:attribute>
        </xsl:element>
        
        <h3>Synapse: <xsl:value-of select="@id"/></h3>


        <table frame="box" rules="all" align="centre" cellpadding="4" width ="100%">
            <xsl:call-template name="tableRow">
                <xsl:with-param name="name">ID</xsl:with-param>
                <xsl:with-param name="value">&lt;b&gt;<xsl:value-of select="@id"/>&lt;/b&gt;</xsl:with-param>
            </xsl:call-template>
            
            <xsl:call-template name="tableRow">
                <xsl:with-param name="name">Type</xsl:with-param>
                <xsl:with-param name="value">&lt;b&gt;&lt;a href="http://www.neuroml.org/NeuroML2CoreTypes/Synapses.html#expOneSynapse"&gt;expOneSynapse&lt;/a&gt;&lt;/b&gt;</xsl:with-param>
            </xsl:call-template>


            <xsl:if test="count(notes) &gt; 0">
                <xsl:call-template name="tableRow">
                    <xsl:with-param name="name">Description</xsl:with-param>
                    <xsl:with-param name="comment">As described in the NeuroML file</xsl:with-param>
                    <xsl:with-param name="value">&lt;b&gt;<xsl:value-of select="notes"/>&lt;/b&gt;</xsl:with-param>
                </xsl:call-template>
            </xsl:if>
        
        
        <xsl:call-template name="tableRow">
            <xsl:with-param name="name">Conductance</xsl:with-param>
            <xsl:with-param name="value">&lt;b&gt;<xsl:value-of select="@gbase"/>&lt;/b&gt;</xsl:with-param>
        </xsl:call-template>

        
        </table>
    </xsl:template>




<xsl:template match="nml:network/*">

<table frame="box" rules="all" align="centre" cellpadding="4" width ="100%">
<tr>
<td>Network</td>
<td><xsl:value-of select="name(.)" /></td>
</tr>

<xsl:for-each select="@*">
<tr>

<td>
<xsl:value-of select="name()" />
</td>
<td>
<xsl:value-of select="." />
</td>
</tr>
</xsl:for-each>
</table>


</xsl:template>




    <!-- Function add a single table row-->
    <xsl:template name="tableRow">
        <xsl:param name="name" />
        <xsl:param name="comment" />
        <xsl:param name="value" />
        <xsl:param name="class" />
    
        <xsl:variable name="commentSize">
            <xsl:choose>
                <xsl:when test="string-length($comment)>200">75%</xsl:when>
                <xsl:when test="string-length($comment)>100">80%</xsl:when>
                <xsl:otherwise>80%</xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
    
        <tr bgcolor="#FFFFFF">
            <xsl:choose>
                <xsl:when test="string-length($value)>0">
                    <td width="30%" valign="top">
                        <xsl:choose>
                            <xsl:when test="string-length($comment)>0">
                                <table border="0">
                                    <tr>
                                        <td>
                                            <xsl:value-of select="$name"  disable-output-escaping="yes"/>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>
                                            <xsl:element name="span">
                                                <xsl:attribute name="style">color:#a0a0a0;font-style: italic;font-size: <xsl:value-of select="$commentSize"> </xsl:value-of></xsl:attribute>
                                                <xsl:value-of select="$comment"  disable-output-escaping="yes"/>
                                            </xsl:element>
                                        </td>
                                    </tr>
                                </table>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:value-of select="$name" disable-output-escaping="yes"/>
                            </xsl:otherwise>
                        </xsl:choose>
                    </td>
                    <td width="70%" bgcolor="#FFFFFF" valign="top">
                        <xsl:value-of select="$value"  disable-output-escaping="yes"/>
                    </td>
                </xsl:when>
                <xsl:otherwise>
                    <td width="30%" bgcolor="#FFFFFF"  colspan="2">
                        <xsl:choose>
                            <xsl:when test="string-length($comment)>0">
                                <p>
                                    <xsl:value-of select="$name"   disable-output-escaping="yes"/>
                                </p>
                                <p>
                                    <xsl:element name="span">
                                        <xsl:attribute name="style">color:#a0a0a0;font-style: italic;font-size: <xsl:value-of select="$commentSize"> </xsl:value-of></xsl:attribute>
                                        <xsl:value-of select="$comment"  disable-output-escaping="yes"/>
                                    </xsl:element>
                                </p>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:value-of select="$name" disable-output-escaping="yes"/>
                            </xsl:otherwise>
                        </xsl:choose>
                    </td>
                </xsl:otherwise>
            </xsl:choose>
        </tr> 
    </xsl:template>

</xsl:stylesheet>

