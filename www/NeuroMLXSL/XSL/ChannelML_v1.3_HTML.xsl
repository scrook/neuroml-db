<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="1.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:cml="http://morphml.org/channelml/schema"
    xmlns:meta="http://morphml.org/metadata/schema" >

    <xsl:import href="../ReadableUtils.xsl"/>
    
<!--

    This file is used to convert v1.3 ChannelML files to a "neuroscientist friendly" HTML view
    This file is taken from the neuroConstruct source code
    
    This file has been developed as part of the neuroConstruct project
    
    Funding for this work has been received from the Medical Research Council
    
    Author: Padraig Gleeson
    Copyright 2006 Department of Physiology, UCL
    
-->

<xsl:output method="html" indent="yes" />

<xsl:variable name="xmlFileUnitSystem"><xsl:value-of select="/cml:channelml/@units"/></xsl:variable>   



<!--Main template-->

<xsl:template match="/cml:channelml">
<h3>ChannelML v1.3 file</h3>

<xsl:if test="count(/cml:channelml/meta:notes) &gt; 0">
<table frame="box" rules="all" align="centre" cellpadding="4" width ="100%">
    <xsl:call-template name="tableRow">
        <xsl:with-param name="name">General notes</xsl:with-param>
        <xsl:with-param name="comment">Notes present in ChannelML file</xsl:with-param>
        <xsl:with-param name="value">&lt;b&gt;<xsl:value-of select="/cml:channelml/meta:notes"/>&lt;/b&gt;</xsl:with-param>
     </xsl:call-template>
</table>
</xsl:if>

<br/>

<table frame="box" rules="all" align="centre" cellpadding="4" width ="100%">
    <xsl:call-template name="tableRow">
        <xsl:with-param name="name">Unit system of ChannelML file</xsl:with-param>
        <xsl:with-param name="comment">This can be either <b>SI Units</b> or <b>Physiological Units (milliseconds, centimeters, millivolts, etc.)</b></xsl:with-param>
        <xsl:with-param name="value">&lt;b&gt;<xsl:value-of select="$xmlFileUnitSystem"/>&lt;/b&gt;</xsl:with-param>
     </xsl:call-template>
</table>

<xsl:if test="count(cml:ion)>0">
    <h3>Ions involved in this channel: </h3>
    <table frame="box" rules="all" align="centre" cellpadding="4" width ="100%">
        <xsl:apply-templates  select="cml:ion"/>
    </table>
</xsl:if>


<xsl:apply-templates  select="cml:channel_type"/>
<xsl:apply-templates  select="cml:ion_concentration"/>
<xsl:apply-templates  select="cml:synapse_type"/>


</xsl:template>
<!--End Main template-->



<xsl:template match="cml:channel_type">
<h3>Channel: <xsl:value-of select="@name"/></h3>


<table frame="box" rules="all" align="centre" cellpadding="4" width ="100%">
<xsl:call-template name="tableRow">
        <xsl:with-param name="name">Name</xsl:with-param>
        <xsl:with-param name="value">&lt;b&gt;<xsl:value-of select="@name"/>&lt;/b&gt;</xsl:with-param>
</xsl:call-template>

<xsl:if test="count(meta:notes) &gt; 0">
<xsl:call-template name="tableRow">
        <xsl:with-param name="name">Description</xsl:with-param>
        <xsl:with-param name="comment">As described in ChannelML file</xsl:with-param>
        <xsl:with-param name="value">&lt;b&gt;<xsl:value-of select="meta:notes"/>&lt;/b&gt;</xsl:with-param>
</xsl:call-template>
</xsl:if>


<xsl:apply-templates select="meta:authorList"/>

<xsl:apply-templates select="meta:publication"/>

<xsl:apply-templates select="meta:neuronDBref"/>

<xsl:if test="count(cml:current_voltage_relation/cml:ohmic) &gt; 0">

    <xsl:call-template name="tableRow">
        <xsl:with-param name="name">Current voltage relationship</xsl:with-param>  
        <xsl:with-param name="comment">Note: only ohmic current voltage relationships are supported in current specification</xsl:with-param>
        <xsl:with-param name="value">&lt;b&gt;Ohmic&lt;/b&gt;</xsl:with-param>
    </xsl:call-template>
    
   <xsl:variable name="ionname"><xsl:value-of select="cml:current_voltage_relation/cml:ohmic/@ion"/></xsl:variable>   

    
    <xsl:call-template name="tableRow">
        <xsl:with-param name="name">Ion involved in channel</xsl:with-param>            
        
        <xsl:with-param name="comment">The ion which is actually flowing through the channel and its default reversal potential</xsl:with-param>

        <xsl:with-param name="value">&lt;b&gt;<xsl:value-of select="$ionname"/> (E<xsl:value-of 
        select="$ionname"/> = <xsl:value-of select="../cml:ion[string(@name) = string($ionname)]/@default_erev"/><xsl:call-template name="getUnits">
            <xsl:with-param name="quantity">Voltage</xsl:with-param></xsl:call-template>&lt;/b&gt;)</xsl:with-param>
    </xsl:call-template>
    
    <xsl:if test="count(cml:current_voltage_relation/cml:ohmic/cml:conductance) &gt; 0">
        <xsl:call-template name="tableRow">
            <xsl:with-param name="name">Maximum conductance density</xsl:with-param>
            <xsl:with-param name="value">&lt;b&gt;Gmax = <xsl:value-of select="cml:current_voltage_relation/cml:ohmic/cml:conductance/@default_gmax"/> <xsl:call-template name="getUnits">
                <xsl:with-param name="quantity">Conductance Density</xsl:with-param></xsl:call-template>&lt;/b&gt;</xsl:with-param>
        </xsl:call-template>
    
        <xsl:choose>
            <xsl:when test="count(cml:current_voltage_relation/cml:ohmic/cml:conductance/cml:rate_adjustments/cml:q10_settings) &gt; 0">
                <xsl:call-template name="tableRow">
                    <xsl:with-param name="name">Q10 scaling</xsl:with-param>
                    <xsl:with-param name="comment">Q10 scaling affects the tau in the rate equations. It allows rate equations determined at one temperature
                    to be used at a different temperature.</xsl:with-param>
                    <xsl:with-param name="value">Present</xsl:with-param>
                </xsl:call-template>
                <xsl:call-template name="tableRow">
                    <xsl:with-param name="name">Q10_factor</xsl:with-param>
                    <xsl:with-param name="value">&lt;b&gt;<xsl:value-of 
                            select="cml:current_voltage_relation/cml:ohmic/cml:conductance/cml:rate_adjustments/cml:q10_settings/@q10_factor"/>&lt;/b&gt;</xsl:with-param>
                </xsl:call-template>
                <xsl:call-template name="tableRow">
                    <xsl:with-param name="name">Experimental temperature</xsl:with-param>
                    <xsl:with-param name="comment">Temperature at which rate constants determined</xsl:with-param>
                    <xsl:with-param name="value">&lt;b&gt;<xsl:value-of 
                        select="cml:current_voltage_relation/cml:ohmic/cml:conductance/cml:rate_adjustments/cml:q10_settings/@experimental_temp"/>&lt;/b&gt;</xsl:with-param>
                </xsl:call-template>
                <xsl:call-template name="tableRow">
                    <xsl:with-param name="name">Expression for tau</xsl:with-param>
                    <xsl:with-param name="comment">This altered tau will be used at temperature T, after tauExp has been calculated from the rate equations</xsl:with-param>
                    <xsl:with-param name="value">&lt;b&gt;tau(T) = tauExp / <xsl:value-of select="cml:current_voltage_relation/cml:ohmic/cml:conductance/cml:rate_adjustments/cml:q10_settings/@q10_factor"
    />^((T - <xsl:value-of select="cml:current_voltage_relation/cml:ohmic/cml:conductance/cml:rate_adjustments/cml:q10_settings/@experimental_temp"/>)/10)&lt;/b&gt;</xsl:with-param>
                </xsl:call-template>
            </xsl:when>
            <xsl:otherwise>
               <!-- <xsl:call-template name="tableRow">
                    <xsl:with-param name="name">Q10 scaling</xsl:with-param>
                    <xsl:with-param name="comment">Q10 scaling affects the tau in the rate equations. It allows rate equations determined at one temperature
                    to be used at a different temperature.</xsl:with-param>
                    <xsl:with-param name="value">None present</xsl:with-param>
                </xsl:call-template>-->
            </xsl:otherwise>
        </xsl:choose>
    
        <xsl:if test="count(cml:current_voltage_relation/cml:ohmic/cml:conductance/cml:rate_adjustments/cml:offset) &gt; 0">
            <xsl:call-template name="tableRow">
                <xsl:with-param name="name">Voltage offset</xsl:with-param>
                <xsl:with-param name="comment">This introduces a shift in the voltage dependence of the rate equations. If, for example, the equation parameters being used in a model were from a different species, this offset can be introduced to alter the firing threshold to something closer to the species being modelled. See mappings for details.</xsl:with-param>
                <xsl:with-param name="value">&lt;b&gt;<xsl:value-of select="cml:current_voltage_relation/cml:ohmic/cml:conductance/cml:rate_adjustments/cml:offset/@value"/> <xsl:call-template name="getUnits">
        <xsl:with-param name="quantity">Voltage</xsl:with-param></xsl:call-template>&lt;/b&gt;</xsl:with-param>
            </xsl:call-template>
        </xsl:if>
        
        <xsl:call-template name="tableRow">
            <xsl:with-param name="name">Conductance expression</xsl:with-param>                
            <xsl:with-param name="comment">Expression giving the actual conductance as a function of time and voltage</xsl:with-param>

            <xsl:with-param name="value">&lt;b&gt;G<xsl:value-of select="$ionname"/>(v,t) = Gmax
                <xsl:for-each select="cml:current_voltage_relation/cml:ohmic/cml:conductance/cml:gate">
                    <xsl:text> * </xsl:text><xsl:if test="count(cml:state/@fraction)&gt;0 and number(cml:state/@fraction) !=1">
                        (<xsl:value-of select="cml:state/@fraction"/><xsl:text> * </xsl:text>
                      </xsl:if>
                    <xsl:value-of select="cml:state/@name"/>(v,t)
                    <xsl:if test="count(cml:state/@fraction)&gt;0 and number(cml:state/@fraction) !=1">)</xsl:if>
                    <xsl:if test="number(@power) !=1">&lt;sup&gt;<xsl:value-of select="@power"/>&lt;/sup&gt;</xsl:if></xsl:for-each>&lt;/b&gt;
            </xsl:with-param>
        </xsl:call-template>
        
        <xsl:call-template name="tableRow">
            <xsl:with-param name="name">Current due to channel</xsl:with-param>
            <xsl:with-param name="comment">Ionic current through the channel</xsl:with-param>
            <xsl:with-param name="value">&lt;b&gt;I<xsl:value-of select="$ionname"/>(v,t) = G<xsl:value-of select="$ionname"/>(v,t)<xsl:text> * </xsl:text>(v - E<xsl:value-of select="$ionname"/>)&lt;/b&gt;</xsl:with-param>
        </xsl:call-template>

    </xsl:if>

</xsl:if>
</table>
<br/>
<br/>

    
        <xsl:for-each select="cml:current_voltage_relation/cml:ohmic/cml:conductance/cml:gate">
        
        <table frame="box" rules="all" align="centre" cellpadding="4" width ="100%">

            <xsl:call-template name="tableRow">
                <xsl:with-param name="name">  Gate: &lt;b&gt;<xsl:value-of select="cml:state/@name"/>&lt;/b&gt;</xsl:with-param>
                <xsl:with-param name="comment">The equations below determine the dynamics of gating state <xsl:value-of select="cml:state/@name"/></xsl:with-param>
            </xsl:call-template>
            <xsl:call-template name="tableRow">
                <xsl:with-param name="name">Gate power</xsl:with-param>
                <xsl:with-param name="value">&lt;b&gt;<xsl:value-of select="@power"/>&lt;/b&gt;</xsl:with-param>
            </xsl:call-template>
            
            <xsl:variable name="stateName" select="cml:state/@name"/>
            
            <xsl:for-each select='../../../../cml:hh_gate[@state=$stateName]'>
                
            <xsl:call-template name="tableRow">
                <xsl:with-param name="name">Gating model formalism</xsl:with-param>
                <xsl:with-param name="value">&lt;b&gt;Simple Hodgkin Huxley single state transition&lt;/b&gt;</xsl:with-param>
            </xsl:call-template>
                
                <xsl:for-each select='cml:transition'>
                                 
                    <xsl:apply-templates/>
            
                </xsl:for-each> 
                
            </xsl:for-each> <!--<xsl:for-each select='../../../../cml:hh_gate[@state=$stateName]'>-->
             
        </table>
<br/>
<br/>



        </xsl:for-each> <!-- <xsl:for-each select="cml:current_voltage_relation/cml:ohmic/cml:conductance/cml:gate"> -->
        
        
        <xsl:for-each select="cml:ks_gate">
        
            <table frame="box" rules="all" align="centre" cellpadding="4" width ="100%">

                <xsl:call-template name="tableRow">
                    <xsl:with-param name="name">  Kinetic Scheme</xsl:with-param>
                    <xsl:with-param name="comment">The states and transitions below form a kinetic scheme description of the channel</xsl:with-param>
                </xsl:call-template>

                
                <xsl:for-each select='cml:state'>
                                 
                    <xsl:call-template name="tableRow">
                    <xsl:with-param name="name">State</xsl:with-param>
                    <xsl:with-param name="value">&lt;b&gt;<xsl:value-of select="@name"/>&lt;/b&gt;</xsl:with-param>
                </xsl:call-template>
            
                </xsl:for-each> 
                
                <xsl:for-each select='cml:transition'>
                    
                <xsl:call-template name="tableRow">
                    <xsl:with-param name="name">Transition from &lt;b&gt;<xsl:value-of select="@src"/>&lt;/b&gt;
                    to &lt;b&gt;<xsl:value-of select="@target"/>&lt;/b&gt;</xsl:with-param>
                    <xsl:with-param name="comment">Transition between two states</xsl:with-param>
                </xsl:call-template>        
                
                    <xsl:apply-templates/>
            
                </xsl:for-each> 
                
            </table>
        </xsl:for-each>
        
        <xsl:apply-templates select="cml:impl_prefs"/>

</xsl:template>

<xsl:template match="cml:impl_prefs">
    
    <table frame="box" rules="all" align="centre" cellpadding="4" width ="100%">
        <xsl:call-template name="tableRow">
            <xsl:with-param name="name">Implementation Preferences</xsl:with-param>
            <xsl:with-param name="comment">Information is provided to help produce the best implementation of the channel 
        mechanism. Due to some parameters in the channel mechanism the default values used in the
        simulator mappings may not be sufficient, e.g. if the rate equations change rapidly,
        but the default table size isn't large enough.</xsl:with-param>
        </xsl:call-template>        
    
        <xsl:apply-templates select="cml:comment"/>    
        <xsl:apply-templates select="cml:table_settings"/>        
    </table>
    
    
</xsl:template>

<xsl:template match="cml:comment">
    
        <xsl:call-template name="tableRow">
            <xsl:with-param name="name">Comment</xsl:with-param>
            <xsl:with-param name="comment">Explanation taken from file</xsl:with-param>
            <xsl:with-param name="value">&lt;b&gt;<xsl:value-of select="."/> &lt;/b&gt;</xsl:with-param>
        </xsl:call-template> 
</xsl:template>

<xsl:template match="cml:table_settings">
    
        <xsl:call-template name="tableRow">
            <xsl:with-param name="name">Settings for rate equation tables</xsl:with-param>
            <xsl:with-param name="comment">Recommended settings if a table of values is used to speed up calculation
            of the rate equation values.</xsl:with-param>
            <xsl:with-param name="value">Number of table divisions: &lt;b&gt;<xsl:value-of select="@table_divisions"/>&lt;/b&gt;&lt;br/&gt;
            Maximum voltage for tables: &lt;b&gt;<xsl:value-of select="@max_v"/> <xsl:call-template name="getUnits">
               <xsl:with-param name="quantity">Voltage</xsl:with-param></xsl:call-template>&lt;/b&gt;&lt;br/&gt;
            Minimum voltage for tables: &lt;b&gt;<xsl:value-of select="@min_v"/> <xsl:call-template name="getUnits">
               <xsl:with-param name="quantity">Voltage</xsl:with-param></xsl:call-template>&lt;/b&gt;&lt;br/&gt;</xsl:with-param>
        </xsl:call-template> 
</xsl:template>


<xsl:template match="cml:voltage_gate | cml:voltage_conc_gate">
    
    <xsl:variable name="stateName" select="../../@state"/>
    
                <xsl:if test="count(cml:alpha) &gt; 0 and
                    count(cml:beta) &gt; 0">
                    <xsl:call-template name="tableRow">
                        <xsl:with-param name="name">Expression controlling gate:</xsl:with-param>
                        <xsl:with-param name="value">
                            &lt;table border="0"&gt;
                            &lt;tr&gt;
                            &lt;td&gt;
                            &lt;b&gt;d<xsl:value-of select="$stateName"/>(v,t)&lt;/b&gt;
                            &lt;/td&gt;
                            &lt;td rowspan="2" valign="center"&gt;&lt;b&gt;
                            = alpha(v) * (1-<xsl:value-of 
                            select="$stateName"/>) - beta(v) * <xsl:value-of select="$stateName"/>&lt;/b&gt;
                            &lt;/td&gt;                                
                            &lt;/tr&gt;
                            &lt;tr&gt;
                            &lt;td align="center" style="border-top:solid 1px black;"&gt;
                            &lt;b&gt;dt&lt;/b&gt;
                            &lt;/td&gt;            
                            &lt;/tr&gt;
                                
                            &lt;/table&gt;
                        </xsl:with-param>
                    </xsl:call-template> 
                </xsl:if>

                <xsl:if test="count(cml:tau) &gt; 0 and
                    count(cml:inf) &gt; 0">
                    <xsl:call-template name="tableRow">
                        <xsl:with-param name="name">Expression controlling gate:</xsl:with-param>
                        <xsl:with-param name="value">
                        
                        &lt;b&gt;
                            &lt;table border="0"&gt;
                            &lt;tr&gt;
                            &lt;td&gt;
                            &lt;b&gt;d<xsl:value-of select="$stateName"/>(v,t)&lt;/b&gt;
                            &lt;/td&gt;
                            &lt;td rowspan="2" valign="center"&gt;
                            &lt;b&gt;= (inf - <xsl:value-of 
                            select="$stateName"/>)/tau&lt;/b&gt;
                            &lt;/td&gt;                                
                            &lt;/tr&gt;
                            &lt;tr&gt;
                            &lt;td align="center" style="border-top:solid 1px black;"&gt;
                            &lt;b&gt;dt&lt;/b&gt;
                            &lt;/td&gt;            
                            &lt;/tr&gt;
                                
                            &lt;/table&gt;&lt;/b&gt;
                        
                        </xsl:with-param>
                    </xsl:call-template>
                </xsl:if>
          
                <xsl:for-each select='*'> <!-- alpha or beta or tau, ...-->
                
                    <xsl:call-template name="tableRow">
                        <xsl:with-param name="name">&amp;nbsp;&amp;nbsp; &lt;b&gt;<xsl:value-of select="name()"/>&lt;/b&gt;</xsl:with-param>
                        <xsl:with-param name="comment"></xsl:with-param>
                    </xsl:call-template>
            
            
                    <xsl:choose>
                        <xsl:when  test="name()='conc_dependence'">
                            <xsl:call-template name="tableRow">
                                <xsl:with-param name="name">Concentration dependent gate</xsl:with-param>
                                <xsl:with-param name="comment">The dynamics of this gate are dependent on both the potential difference across the
                                channel, and on the concentration of the substance specified here</xsl:with-param>
                                <xsl:with-param name="value">Name: &lt;b&gt;<xsl:value-of select="@name"/>&lt;/b&gt;&lt;br/&gt;
                                    Ion: &lt;b&gt;<xsl:value-of select="@ion"/>&lt;/b&gt;&lt;br/&gt;
                                    Variable as used in equation: &lt;b&gt;<xsl:value-of select="@variable_name"/>&lt;/b&gt;&lt;br/&gt;
                                    Minimum concentraton: &lt;b&gt;<xsl:value-of select="@min_conc"/>&lt;/b&gt;&lt;br/&gt;
                                    Maximum concentration: &lt;b&gt;<xsl:value-of select="@max_conc"/>&lt;/b&gt;
                                </xsl:with-param>
                            </xsl:call-template>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:choose>
                                <xsl:when  test="count(cml:parameterised_hh) &gt; 0">
                                    <xsl:call-template name="tableRow">
                                        <xsl:with-param name="name">Form of rate equation for &lt;b&gt;<xsl:value-of select="name()"/>&lt;/b&gt;</xsl:with-param>
                                        <xsl:with-param name="value">&lt;b&gt;Parameterised HH&lt;/b&gt;</xsl:with-param>
                                    </xsl:call-template>
                                    
                                    <xsl:call-template name="tableRow">
                                        <xsl:with-param name="name">Expression</xsl:with-param>
                                        <xsl:with-param name="value">&lt;b&gt;<xsl:value-of select="name()"/>(v) = <xsl:value-of select="cml:parameterised_hh/@expr" />&lt;/b&gt; &amp;nbsp;&amp;nbsp; &lt;i&gt;(<xsl:value-of select="cml:parameterised_hh/@type" />)&lt;/i&gt;</xsl:with-param>
                                    </xsl:call-template>

                                    <xsl:call-template name="tableRow">
                                        <xsl:with-param name="name">Parameter values</xsl:with-param>     
                                        <xsl:with-param name="value">               
                                            <xsl:for-each select="cml:parameterised_hh/cml:parameter">
                                                &lt;b&gt;<xsl:value-of select="@name"/> = <xsl:value-of select="@value"/>
                                                <xsl:if test="@name='A'"> <xsl:call-template name="getUnits">
                                                <xsl:with-param name="quantity">InvTime</xsl:with-param></xsl:call-template></xsl:if> 
                                                <xsl:if test="@name='k'"> <xsl:call-template name="getUnits">
                                                <xsl:with-param name="quantity">InvVoltage</xsl:with-param></xsl:call-template></xsl:if> 
                                                <xsl:if test="@name='d'"> <xsl:call-template name="getUnits">
                                                <xsl:with-param name="quantity">Voltage</xsl:with-param></xsl:call-template></xsl:if> &lt;/b&gt; 
                                                <xsl:if test="count(meta:notes) &gt; 0"><xsl:text>   </xsl:text>(<xsl:value-of select="meta:notes"/>)</xsl:if> 
                                                    
                                                &lt;br/&gt;
                                            </xsl:for-each>
                                        </xsl:with-param>
                                    </xsl:call-template>
                                    
                                    
                                    <xsl:call-template name="tableRow">
                                        <xsl:with-param name="name">Substituted</xsl:with-param>
                                        <xsl:with-param name="value"><xsl:choose>
                                            
                                            <xsl:when test="cml:parameterised_hh/@type = 'exponential'">
                                                &lt;b&gt;<xsl:value-of select="name()"/>(v) =  
                                                <xsl:value-of select="cml:parameterised_hh/cml:parameter[@name='A']/@value"/> * e&lt;sup&gt;
                                                <xsl:value-of select="cml:parameterised_hh/cml:parameter[@name='k']/@value"/> *(
                                                v - (<xsl:value-of select="cml:parameterised_hh/cml:parameter[@name='d']/@value"/>))&lt;/sup&gt;</xsl:when>
                                                
                                            <xsl:when test="cml:parameterised_hh/@type = 'sigmoid'">
                                                &lt;table border="0"&gt;
                                                    &lt;tr&gt;
                                                        &lt;td  rowspan="2" valign="center"&gt;
                                                            &lt;b&gt;<xsl:value-of select="name()"/>(v) =&lt;/b&gt;
                                                        &lt;/td&gt;
                                                        &lt;td align="center"&gt;
                                                            &lt;b&gt;<xsl:value-of select="cml:parameterised_hh/cml:parameter[@name='A']/@value"/>&lt;/b&gt;
                                                        &lt;/td&gt;
                                                    &lt;tr&gt;
                                                        &lt;td align="center" style="border-top:solid 1px black;"&gt;
                                                            &lt;b&gt;1+ e&lt;sup&gt; <xsl:value-of select="cml:parameterised_hh/cml:parameter[@name='k']/@value"/> * (
                                                            v - (<xsl:value-of select="cml:parameterised_hh/cml:parameter[@name='d']/@value"/>))&lt;/sup&gt;&lt;/b&gt;
                                                        &lt;/td&gt;            
                                                    &lt;/tr&gt;
                                                &lt;/table&gt;
                                            </xsl:when>
                                            
                                            <xsl:when test="cml:parameterised_hh/@type = 'linoid'">
                                                &lt;table border="0"&gt;
                                                    &lt;tr&gt;
                                                        &lt;td  rowspan="2" valign="center"&gt;
                                                            &lt;b&gt;<xsl:value-of select="name()"/>(v) =&lt;/b&gt;
                                                        &lt;/td&gt;
                                                        &lt;td align="center"&gt;
                                                            &lt;b&gt;<xsl:value-of select="cml:parameterised_hh/cml:parameter[@name='A']/@value"/> *
                                                            <xsl:value-of select="cml:parameterised_hh/cml:parameter[@name='k']/@value"/> * (
                                                            v - (<xsl:value-of select="cml:parameterised_hh/cml:parameter[@name='d']/@value"/>))&lt;/b&gt;
                                                        &lt;/td&gt;
                                                    &lt;tr&gt;
                                                        &lt;td align="center" style="border-top:solid 1px black;"&gt;
                                                            &lt;b&gt;1- e&lt;sup&gt; -(<xsl:value-of select="cml:parameterised_hh/cml:parameter[@name='k']/@value"/> * (
                                                            v - (<xsl:value-of select="cml:parameterised_hh/cml:parameter[@name='d']/@value"/>)))&lt;/sup&gt;&lt;/b&gt;
                                                        &lt;/td&gt;            
                                                    &lt;/tr&gt;
                                                &lt;/table&gt;
                                            </xsl:when>
                                                
                                            <xsl:otherwise>???</xsl:otherwise>
                                            <!--
                                            &lt;table border="0"&gt;
                            &lt;tr&gt;
                            &lt;td&gt;
                            d<xsl:value-of select="$stateName"/>(v,t)
                            &lt;/td&gt;
                            &lt;td rowspan="2" valign="center"&gt;
                            = (inf - <xsl:value-of 
                            select="$stateName"/>)/tau
                            &lt;/td&gt;                                
                            &lt;/tr&gt;
                            &lt;tr&gt;
                            &lt;td align="center" style="border-top:solid 1px black;"&gt;
                            dt
                            &lt;/td&gt;            
                            &lt;/tr&gt;
                                
                            &lt;/table&gt;-->
                                        </xsl:choose>&lt;/b&gt;</xsl:with-param>
                                    </xsl:call-template>
                                    
                                    <!--
                                    
                                    !! replace() doesn't seem to be implemented...!
                                    
                                    
                                    <xsl:call-template name="tableRow">
                                    <xsl:with-param name="name">Parameters substituted</xsl:with-param>
                                    <xsl:with-param name="value"><xsl:value-of select="name()"/>(v) = 
                                        
                                        
                                    <xsl:value-of select="replace(string(cml:parameterised_hh/@expr), 'A','iii')" /> 
                                        
                                        
                                    </xsl:with-param>
                                    </xsl:call-template>-->
                                    
                                </xsl:when>
                                

                                <xsl:when  test="count(cml:generic_equation_hh) &gt; 0">
                                    <xsl:call-template name="tableRow">
                                        <xsl:with-param name="name">Form of rate equation for <xsl:value-of select="name()"/></xsl:with-param>
                                        <xsl:with-param name="value">&lt;b&gt;Generic equation&lt;/b&gt;</xsl:with-param>
                                    </xsl:call-template> 
                                    <xsl:call-template name="tableRow">
                                        <xsl:with-param name="name">Expression</xsl:with-param>
                                        <xsl:with-param name="value">  &lt;b&gt;
                                            <xsl:call-template name="formatExpression">
                                                <xsl:with-param name="variable">
                                                    <xsl:value-of select="name()"/>
                                                </xsl:with-param>
                                                <xsl:with-param name="oldExpression">
                                                    <xsl:value-of select="cml:generic_equation_hh/@expr" />
                                                </xsl:with-param>
                                            </xsl:call-template>&lt;/b&gt;
                                        </xsl:with-param>
                                    </xsl:call-template>

                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:call-template name="tableRow">
                                        <xsl:with-param name="name">Form of rate equation</xsl:with-param>
                                        <xsl:with-param name="value">&lt;b&gt;Undetermined&lt;/b&gt;</xsl:with-param>
                                    </xsl:call-template>             
                                </xsl:otherwise>
                            </xsl:choose>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:for-each>
    
</xsl:template>






<xsl:template match="cml:ion">
    <xsl:call-template name="tableRow">
        <xsl:with-param name="name">Ion: &lt;b&gt;<xsl:value-of select="@name"/>&lt;/b&gt;</xsl:with-param>
        <xsl:with-param name="comment">One of the ions involved in this channel. Note that the reversal potential used here is a typical value, it should be determined for each cell type based on ionic concentrations</xsl:with-param>
        <xsl:with-param name="value">Charge: &lt;b&gt;<xsl:value-of select="@charge"/>&lt;/b&gt;
            <xsl:if test="count(@default_erev) &gt; 0">
                &lt;br/&gt;Default reversal potential: &lt;b&gt;<xsl:value-of select="@default_erev"/> <xsl:call-template name="getUnits">
                    <xsl:with-param name="quantity">Voltage</xsl:with-param></xsl:call-template>&lt;/b&gt;
            </xsl:if>
            <xsl:if test="count(@role) &gt; 0">
                &lt;br/&gt;Role of ion in process: &lt;b&gt;<xsl:value-of select="@role"/>&lt;/b&gt;
            </xsl:if>
            <xsl:if test="count(meta:notes) &gt; 0">
                &lt;br/&gt;&lt;br/&gt;&lt;span style="color:#a0a0a0;font-style: italic;font-size: 90%"&gt;<xsl:value-of select="meta:notes"/>&lt;/span&gt;
            </xsl:if>
          
        </xsl:with-param>
    </xsl:call-template>
</xsl:template>

<xsl:template match="cml:ion_concentration">
<h3>Ion concentration: <xsl:value-of select="@name"/></h3>


    <table frame="box" rules="all" align="centre" cellpadding="4">
        <xsl:call-template name="tableRow">
                <xsl:with-param name="name">Name</xsl:with-param>
                <xsl:with-param name="value">&lt;b&gt;<xsl:value-of select="@name"/>&lt;/b&gt;</xsl:with-param>
        </xsl:call-template>
        <xsl:if test="count(meta:notes) &gt; 0">
        <xsl:call-template name="tableRow">
                <xsl:with-param name="name">Description</xsl:with-param>
                <xsl:with-param name="comment">As described in ChannelML file</xsl:with-param>
                <xsl:with-param name="value">&lt;b&gt;<xsl:value-of select="meta:notes"/>&lt;/b&gt;</xsl:with-param>
        </xsl:call-template>
        </xsl:if>
        
        
<xsl:apply-templates select="meta:authorList"/>
        
        <xsl:apply-templates select="meta:publication"/>

        <xsl:apply-templates select="meta:neuronDBref"/>
        
        
        <xsl:call-template name="tableRow">
                <xsl:with-param name="name">Ion species</xsl:with-param>
                <xsl:with-param name="comment">The type of ion whose concentration will be altered</xsl:with-param>
                <xsl:with-param name="value">&lt;b&gt;<xsl:value-of select="cml:ion_species"/>&lt;/b&gt;</xsl:with-param>
        </xsl:call-template>
        
        <xsl:for-each select="cml:decaying_pool_model">
            <xsl:call-template name="tableRow">
                <xsl:with-param name="name">  Dynamic model: &lt;b&gt;<xsl:value-of select="name()"/>&lt;/b&gt;</xsl:with-param>
                <xsl:with-param name="comment">The model underlying the mechanism altering the ion concentration</xsl:with-param>
            </xsl:call-template>
            <xsl:call-template name="tableRow">
                <xsl:with-param name="name">Resting concentration</xsl:with-param>
                <xsl:with-param name="comment">The base level concentration of the ion</xsl:with-param>
                <xsl:with-param name="value">&lt;b&gt;<xsl:value-of select="cml:resting_conc"/> <xsl:call-template name="getUnits">
                    <xsl:with-param name="quantity">Concentration</xsl:with-param></xsl:call-template>&lt;/b&gt;
                </xsl:with-param>
            </xsl:call-template>
            <xsl:call-template name="tableRow">
                <xsl:with-param name="name">Decay Constant</xsl:with-param>
                <xsl:with-param name="comment">The rate of decay (tau) of the concentration back to resting level</xsl:with-param>
                <xsl:with-param name="value">&lt;b&gt;<xsl:value-of select="cml:decay_constant"/> <xsl:call-template name="getUnits">
                    <xsl:with-param name="quantity">Time</xsl:with-param></xsl:call-template>&lt;/b&gt;
                </xsl:with-param>
            </xsl:call-template>
            <xsl:call-template name="tableRow">
                <xsl:with-param name="name">Shell Thickness</xsl:with-param>
                <xsl:with-param name="comment">The thickness of a shell under the cell membrane where all the change in ion concentration is assumed to take place</xsl:with-param>
                <xsl:with-param name="value">&lt;b&gt;<xsl:value-of select="cml:pool_volume_info/cml:shell_thickness"/> <xsl:call-template name="getUnits">
                    <xsl:with-param name="quantity">Length</xsl:with-param></xsl:call-template>&lt;/b&gt;
                </xsl:with-param>
            </xsl:call-template>
        </xsl:for-each>
    </table>
</xsl:template>





<xsl:template match="cml:synapse_type">
<xsl:element name="a">
    <xsl:attribute name="name">Synapse_<xsl:value-of select="@name"/></xsl:attribute>
</xsl:element><h3>Synapse: <xsl:value-of select="@name"/></h3>

    <table frame="box" rules="all" align="centre" cellpadding="4">
        <xsl:call-template name="tableRow">
                <xsl:with-param name="name">Name</xsl:with-param>
                <xsl:with-param name="value">&lt;b&gt;<xsl:value-of select="@name"/>&lt;/b&gt;</xsl:with-param>
        </xsl:call-template>
        <xsl:if test="count(meta:notes) &gt; 0">
        <xsl:call-template name="tableRow">
                <xsl:with-param name="name">Description</xsl:with-param>
                <xsl:with-param name="comment">As described in ChannelML file</xsl:with-param>
                <xsl:with-param name="value">&lt;b&gt;<xsl:value-of select="meta:notes"/>&lt;/b&gt;</xsl:with-param>
        </xsl:call-template>
        </xsl:if>
        
<xsl:apply-templates select="meta:authorList"/>

        <xsl:apply-templates select="meta:publication"/>

        <xsl:apply-templates select="meta:neuronDBref"/>
        
        <xsl:apply-templates select="cml:doub_exp_syn"/>
        <xsl:apply-templates select="cml:blocking_syn"/>
        <xsl:apply-templates select="cml:plastic_syn"/>
    </table>

</xsl:template>



<xsl:template match="cml:doub_exp_syn">
    <xsl:call-template name="tableRow">
        <xsl:with-param name="name">Synaptic Mechanism Model: &lt;b&gt;Double Exponential Synapse&lt;/b&gt;</xsl:with-param>
        <xsl:with-param name="comment">The model underlying the synaptic mechanism</xsl:with-param>
    </xsl:call-template>
                    
    <xsl:call-template name="tableRow">
        <xsl:with-param name="name">Maximum conductance</xsl:with-param>
        <xsl:with-param name="comment">The peak conductance which the synapse will reach</xsl:with-param>
        <xsl:with-param name="value">&lt;b&gt;<xsl:value-of select="@max_conductance"/> <xsl:call-template name="getUnits">
                    <xsl:with-param name="quantity">Conductance</xsl:with-param></xsl:call-template>&lt;/b&gt;</xsl:with-param>
    </xsl:call-template>
    <xsl:call-template name="tableRow">
        <xsl:with-param name="name">Rise time</xsl:with-param>
        <xsl:with-param name="comment">Characteristic time (tau) over which the double exponential synaptic conductance rises</xsl:with-param>
        <xsl:with-param name="value">&lt;b&gt;<xsl:value-of select="@rise_time"/> <xsl:call-template name="getUnits">
                    <xsl:with-param name="quantity">Time</xsl:with-param></xsl:call-template>&lt;/b&gt;</xsl:with-param>
    </xsl:call-template>
    <xsl:call-template name="tableRow">
        <xsl:with-param name="name">Decay time</xsl:with-param>
        <xsl:with-param name="comment">Characteristic time (tau) over which the double exponential synaptic conductance decays</xsl:with-param>
        <xsl:with-param name="value">&lt;b&gt;<xsl:value-of select="@decay_time"/> <xsl:call-template name="getUnits">
                    <xsl:with-param name="quantity">Time</xsl:with-param></xsl:call-template>&lt;/b&gt;</xsl:with-param>
    </xsl:call-template>
    <xsl:call-template name="tableRow">
        <xsl:with-param name="name">Reversal potential</xsl:with-param>
        <xsl:with-param name="comment">The effective reversal potential for the ion flow through the synapse when the conductance is non zero</xsl:with-param>
        <xsl:with-param name="value">&lt;b&gt;<xsl:value-of select="@reversal_potential"/> <xsl:call-template name="getUnits">
                    <xsl:with-param name="quantity">Voltage</xsl:with-param></xsl:call-template>&lt;/b&gt;</xsl:with-param>
    </xsl:call-template>
</xsl:template>



<xsl:template match="cml:doub_exp_syn">
    <xsl:call-template name="tableRow">
        <xsl:with-param name="name">Synaptic Mechanism Model: &lt;b&gt;Double Exponential Synapse&lt;/b&gt;</xsl:with-param>
        <xsl:with-param name="comment">The model underlying the synaptic mechanism</xsl:with-param>
    </xsl:call-template>

    <xsl:apply-templates select="@max_conductance"/>
    <xsl:apply-templates select="@rise_time"/>
    <xsl:apply-templates select="@decay_time"/>
    <xsl:apply-templates select="@reversal_potential"/>
    
</xsl:template>


<xsl:template match="@max_conductance">
    <xsl:call-template name="tableRow">
        <xsl:with-param name="name">Maximum conductance</xsl:with-param>
        <xsl:with-param name="comment">The peak conductance which the synapse will reach</xsl:with-param>
        <xsl:with-param name="value">&lt;b&gt;<xsl:value-of select="."/> <xsl:call-template name="getUnits">
                    <xsl:with-param name="quantity">Conductance</xsl:with-param></xsl:call-template>&lt;/b&gt;</xsl:with-param>
    </xsl:call-template>
</xsl:template>

<xsl:template match="@rise_time">
    <xsl:call-template name="tableRow">
        <xsl:with-param name="name">Rise time</xsl:with-param>
        <xsl:with-param name="comment">Characteristic time (tau) over which the double exponential synaptic conductance rises</xsl:with-param>
        <xsl:with-param name="value">&lt;b&gt;<xsl:value-of select="."/> <xsl:call-template name="getUnits">
                    <xsl:with-param name="quantity">Time</xsl:with-param></xsl:call-template>&lt;/b&gt;</xsl:with-param>
    </xsl:call-template>
</xsl:template>

<xsl:template match="@decay_time">
    <xsl:call-template name="tableRow">
        <xsl:with-param name="name">Decay time</xsl:with-param>
        <xsl:with-param name="comment">Characteristic time (tau) over which the double exponential synaptic conductance decays</xsl:with-param>
        <xsl:with-param name="value">&lt;b&gt;<xsl:value-of select="."/> <xsl:call-template name="getUnits">
                    <xsl:with-param name="quantity">Time</xsl:with-param></xsl:call-template>&lt;/b&gt;</xsl:with-param>
    </xsl:call-template>
</xsl:template>

<xsl:template match="@reversal_potential">
    <xsl:call-template name="tableRow">
        <xsl:with-param name="name">Reversal potential</xsl:with-param>
        <xsl:with-param name="comment">The effective reversal potential for the ion flow through the synapse when the conductance is non zero</xsl:with-param>
        <xsl:with-param name="value">&lt;b&gt;<xsl:value-of select="."/> <xsl:call-template name="getUnits">
                    <xsl:with-param name="quantity">Voltage</xsl:with-param></xsl:call-template>&lt;/b&gt;</xsl:with-param>
    </xsl:call-template>
</xsl:template>



<xsl:template match="cml:blocking_syn">
    <xsl:call-template name="tableRow">
        <xsl:with-param name="name">Synaptic Mechanism Model: &lt;b&gt;Blocking Synapse&lt;/b&gt;</xsl:with-param>
        <xsl:with-param name="comment">The model underlying the synaptic mechanism</xsl:with-param>
    </xsl:call-template>
    
    <xsl:apply-templates select="@max_conductance"/>
    <xsl:apply-templates select="@rise_time"/>
    <xsl:apply-templates select="@decay_time"/>
    <xsl:apply-templates select="@reversal_potential"/>
    
    <xsl:apply-templates select="cml:block"/>
    
                    
</xsl:template>

<xsl:template match="cml:block">
    <xsl:call-template name="tableRow">
        <xsl:with-param name="name">Block of synaptic mechanism</xsl:with-param>
        <xsl:with-param name="comment">Information on how a species modifies the conductance of the synapse</xsl:with-param>
    </xsl:call-template>
    
    <xsl:call-template name="tableRow">
        <xsl:with-param name="name">Substance</xsl:with-param>
        <xsl:with-param name="comment">Ion or molecule which blocks the channel</xsl:with-param>
        <xsl:with-param name="value">&lt;b&gt;<xsl:value-of select="@species"/> &lt;/b&gt;</xsl:with-param>
    </xsl:call-template>
    
    <xsl:call-template name="tableRow">
        <xsl:with-param name="name">Concentration</xsl:with-param>
        <xsl:with-param name="comment">Concentration of species</xsl:with-param>
        <xsl:with-param name="value">&lt;b&gt;<xsl:value-of select="@conc"/> <xsl:call-template name="getUnits">
                    <xsl:with-param name="quantity">Concentration</xsl:with-param></xsl:call-template>&lt;/b&gt;</xsl:with-param>
    </xsl:call-template>
    
    
    <xsl:call-template name="tableRow">
        <xsl:with-param name="name">eta</xsl:with-param>
        
        <xsl:with-param name="value">&lt;b&gt;<xsl:value-of select="@eta"/> <xsl:call-template name="getUnits">
                    <xsl:with-param name="quantity">InvConcentration</xsl:with-param></xsl:call-template>&lt;/b&gt;</xsl:with-param>
    </xsl:call-template>
    
    
    <xsl:call-template name="tableRow">
        <xsl:with-param name="name">gamma</xsl:with-param>
        
        <xsl:with-param name="value">&lt;b&gt;<xsl:value-of select="@gamma"/> <xsl:call-template name="getUnits">
                    <xsl:with-param name="quantity">InvVoltage</xsl:with-param></xsl:call-template>&lt;/b&gt;</xsl:with-param>
    </xsl:call-template>
    
    <xsl:call-template name="tableRow">
        <xsl:with-param name="name">Expression defining block</xsl:with-param>
        
        <xsl:with-param name="value">
            &lt;table border="0"&gt;
                &lt;tr&gt;
                    &lt;td  rowspan="2" valign="center"&gt;
                        &lt;b&gt;G&lt;sub&gt;block&lt;/sub&gt;(v) =&lt;/b&gt;
                    &lt;/td&gt;
                    &lt;td align="center"&gt;
                        &lt;b&gt;1&lt;/b&gt;
                    &lt;/td&gt;
                &lt;tr&gt;
                    &lt;td align="center" style="border-top:solid 1px black;"&gt;
                        &lt;b&gt;1+ eta * [<xsl:value-of select="@species"/>] * e&lt;sup&gt;(-1 * gamma * v)&lt;/sup&gt;&lt;/b&gt;
                    &lt;/td&gt;            
                &lt;/tr&gt;
            &lt;/table&gt;
        </xsl:with-param>
    </xsl:call-template>
    
                    
</xsl:template>





<xsl:template match="cml:plastic_syn">
    <xsl:call-template name="tableRow">
        <xsl:with-param name="name">Synaptic Mechanism Model: &lt;b&gt;Plastic Synapse&lt;/b&gt;</xsl:with-param>
        <xsl:with-param name="comment">The model underlying the synaptic mechanism</xsl:with-param>
    </xsl:call-template>
        

    <xsl:apply-templates select="@max_conductance"/>

    <xsl:apply-templates select="@rise_time"/>
    
    <xsl:call-template name="tableRow">
        <xsl:with-param name="name">Decay time 1</xsl:with-param>
        <xsl:with-param name="comment">First characteristic time (tau) over which the double exponential synaptic conductance decays</xsl:with-param>
        <xsl:with-param name="value">&lt;b&gt;<xsl:value-of select="@decay_time_1"/> <xsl:call-template name="getUnits">
                    <xsl:with-param name="quantity">Time</xsl:with-param></xsl:call-template>&lt;/b&gt;</xsl:with-param>
    </xsl:call-template>
    <xsl:call-template name="tableRow">
        <xsl:with-param name="name">Decay time 2</xsl:with-param>
        <xsl:with-param name="comment">Second characteristic time (tau) over which the double exponential synaptic conductance decays</xsl:with-param>
        <xsl:with-param name="value">&lt;b&gt;<xsl:value-of select="@decay_time_2"/> <xsl:call-template name="getUnits">
                    <xsl:with-param name="quantity">Time</xsl:with-param></xsl:call-template>&lt;/b&gt;</xsl:with-param>
    </xsl:call-template>
    <xsl:call-template name="tableRow">
        <xsl:with-param name="name">Decay time 3</xsl:with-param>
        <xsl:with-param name="comment">Third characteristic time (tau) over which the double exponential synaptic conductance decays</xsl:with-param>
        <xsl:with-param name="value">&lt;b&gt;<xsl:value-of select="@decay_time_3"/> <xsl:call-template name="getUnits">
                    <xsl:with-param name="quantity">Time</xsl:with-param></xsl:call-template>&lt;/b&gt;</xsl:with-param>
    </xsl:call-template>
    
    <xsl:apply-templates select="@reversal_potential"/>

    
</xsl:template>









</xsl:stylesheet>
