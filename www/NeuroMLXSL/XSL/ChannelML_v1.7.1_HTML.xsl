<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="1.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:cml="http://morphml.org/channelml/schema"
    xmlns:meta="http://morphml.org/metadata/schema" >

    <xsl:import href="../ReadableUtils.xsl"/>

<!--

    This file is used to convert ChannelML files to a "neuroscientist friendly" HTML view.

    This file has been developed as part of the neuroConstruct project

    Funding for this work has been received from the Medical Research Council

    Author: Padraig Gleeson
    Copyright 2007 Department of Physiology, UCL

-->

<xsl:output method="html" indent="yes" />

<xsl:variable name="xmlFileUnitSystem"><xsl:value-of select="/cml:channelml/@units"/></xsl:variable>



<!--Main template-->

<xsl:template match="/cml:channelml">
<h3>ChannelML v1.7.1 file</h3>

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



<xsl:template match="cml:status">
    <xsl:call-template name="tableRow">
            <xsl:with-param name="name">Status</xsl:with-param>
            <xsl:with-param name="comment">Status of element in file</xsl:with-param>
            <xsl:with-param name="value">&lt;b&gt;&lt;span style="color:
                <xsl:choose>
                    <xsl:when test="@value='stable'">green"&gt;Stable</xsl:when>
                    <xsl:when test="@value='in_progress'">#DD8C00"&gt;In progress, use with caution</xsl:when>
                    <xsl:when test="@value='known_issues'">red"&gt;Known issues. Should not be used in any simulations!</xsl:when>
                    <xsl:otherwise>red"&gt;Indeterminate status!</xsl:otherwise>
                </xsl:choose>
                &lt;/span&gt;
                &lt;/b&gt;
                <xsl:for-each select="meta:comment">&lt;br/&gt;Comment: <xsl:value-of select="."/></xsl:for-each>
                <xsl:for-each select="meta:issue">&lt;br/&gt; &lt;span style="color:#DD8C00"&gt;  Issue: <xsl:value-of select="."/>&lt;/span&gt;</xsl:for-each>
                <xsl:for-each select="meta:contributor/meta:name">&lt;br/&gt;Contributor: <xsl:value-of select="."/></xsl:for-each>
                </xsl:with-param>
    </xsl:call-template>
</xsl:template>


<xsl:template match="cml:channel_type">
<h3>Channel: <xsl:value-of select="@name"/></h3>


<table frame="box" rules="all" align="centre" cellpadding="4" width ="100%">
<xsl:call-template name="tableRow">
        <xsl:with-param name="name">Name</xsl:with-param>
        <xsl:with-param name="value">&lt;b&gt;<xsl:value-of select="@name"/>&lt;/b&gt;</xsl:with-param>
</xsl:call-template>



<xsl:apply-templates select="cml:status"/> 


<xsl:if test="count(meta:notes) &gt; 0">
<xsl:call-template name="tableRow">
        <xsl:with-param name="name">Description</xsl:with-param>
        <xsl:with-param name="comment">As described in the ChannelML file</xsl:with-param>
        <xsl:with-param name="value">&lt;b&gt;<xsl:value-of select="meta:notes"/>&lt;/b&gt;</xsl:with-param>
</xsl:call-template>
</xsl:if>


<xsl:apply-templates select="meta:authorList"/>

<xsl:apply-templates select="meta:publication"/>

<xsl:apply-templates select="meta:neuronDBref"/>

<xsl:apply-templates select="meta:modelDBref"/>


<xsl:apply-templates select="cml:current_voltage_relation/cml:ohmic"/>
<xsl:apply-templates select="cml:current_voltage_relation/cml:integrate_and_fire"/>

<!--
<xsl:if test="count(cml:current_voltage_relation/cml:ohmic) &gt; 0">

    <xsl:call-template name="tableRow">
        <xsl:with-param name="name">Current voltage relationship</xsl:with-param>
        <xsl:with-param name="comment">Note: only ohmic and integrate_and_fire current voltage relationships are supported in current specification</xsl:with-param>
        <xsl:with-param name="value">&lt;b&gt;Ohmic&lt;/b&gt;</xsl:with-param>
    </xsl:call-template>

   <xsl:variable name="ionname"><xsl:value-of select="cml:current_voltage_relation/cml:ohmic/@ion"/></xsl:variable>


    <xsl:call-template name="tableRow">
        <xsl:with-param name="name">Ion involved in channel</xsl:with-param>

        <xsl:with-param name="comment">The ion which is actually flowing through the channel and its default reversal potential</xsl:with-param>

        <xsl:with-param name="value">&lt;b&gt;<xsl:value-of select="$ionname"/> (E&lt;sub&gt;<xsl:value-of
        select="$ionname"/>&lt;/sub&gt; iiii= <xsl:value-of select="../cml:ion[string(@name) = string($ionname)]/@default_erev"/><xsl:call-template name="getUnits">
            <xsl:with-param name="quantity">Voltage</xsl:with-param></xsl:call-template>&lt;/b&gt;)</xsl:with-param>
    </xsl:call-template>

    <xsl:if test="count(cml:current_voltage_relation/cml:ohmic/cml:conductance) &gt; 0">
        <xsl:call-template name="tableRow">
            <xsl:with-param name="name">Maximum conductance density</xsl:with-param>
            <xsl:with-param name="value">&lt;b&gt;G&lt;sub&gt;max&lt;/sub&gt; = <xsl:value-of select="cml:current_voltage_relation/cml:ohmic/cml:conductance/@default_gmax"/> <xsl:call-template name="getUnits">
                <xsl:with-param name="quantity">Conductance Density</xsl:with-param></xsl:call-template>&lt;/b&gt;</xsl:with-param>
        </xsl:call-template>


        <xsl:for-each select="cml:current_voltage_relation/cml:ohmic/cml:conductance/cml:rate_adjustments/cml:q10_settings">
            <xsl:call-template name="tableRow">
                <xsl:with-param name="name">Q10 scaling</xsl:with-param>
                <xsl:with-param name="comment">Q10 scaling affects the tau in the rate equations. It allows rate equations experimentally calculated at one temperature
                to be used at a different temperature.</xsl:with-param>

                <xsl:with-param name="value">
                    <xsl:choose>
                        <xsl:when test="count(@gate) &gt; 0">Gate Q10 adjustment applied to: &lt;b&gt;<xsl:value-of select="@gate"/>&lt;/b&gt;</xsl:when>
                        <xsl:otherwise>Gate Q10 adjustment applied to: &lt;b&gt;all&lt;/b&gt;</xsl:otherwise>
                    </xsl:choose> &lt;br/&gt;
                    Q10_factor: &lt;b&gt;<xsl:value-of select="@q10_factor"/>&lt;/b&gt; &lt;br/&gt;
                    Experimental temperature (at which rate constants below were determined): &lt;b&gt;<xsl:value-of select="@experimental_temp"/>  &lt;sup&gt;o&lt;/sup&gt;C  &lt;/b&gt; &lt;br/&gt;
                    Expression for tau at T using tauExp as calculated from rate equations:
                           &lt;b&gt;tau(T) = tauExp / <xsl:value-of select="@q10_factor"/>^((T - <xsl:value-of select="@experimental_temp"/>)/10)&lt;/b&gt; &lt;br/&gt;

                </xsl:with-param>
            </xsl:call-template>
        </xsl:for-each>


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

            <xsl:with-param name="value">&lt;b&gt;G&lt;sub&gt;<xsl:value-of select="$ionname"/>&lt;/sub&gt;(v,t) = G&lt;sub&gt;max&lt;/sub&gt;
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
            <xsl:with-param name="value">&lt;b&gt;I&lt;sub&gt;<xsl:value-of select="$ionname"/>&lt;/sub&gt;(v,t) = G&lt;sub&gt;<xsl:value-of select="$ionname"/>&lt;/sub&gt;(v,t)<xsl:text> * </xsl:text>(v - E&lt;sub&gt;<xsl:value-of select="$ionname"/>&lt;/sub&gt;)&lt;/b&gt;</xsl:with-param>
        </xsl:call-template>

    </xsl:if>

</xsl:if>

-->



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
                <xsl:with-param name="value">&lt;b&gt;Hodgkin Huxley single state transition&lt;/b&gt;</xsl:with-param>
            </xsl:call-template>

                <xsl:for-each select='cml:transition'>

                    <xsl:apply-templates/>

                </xsl:for-each>

            </xsl:for-each>

        </table>
<br/>
<br/>



        </xsl:for-each>


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



<xsl:template match="cml:integrate_and_fire">


    <xsl:call-template name="tableRow">
        <xsl:with-param name="name">Current voltage relationship</xsl:with-param>
        <xsl:with-param name="comment">Note: only ohmic and integrate_and_fire current voltage relationships are supported in current specification</xsl:with-param>
        <xsl:with-param name="value">&lt;b&gt;Integrate and Fire&lt;/b&gt;</xsl:with-param>
    </xsl:call-template>


    <xsl:call-template name="tableRow">
        <xsl:with-param name="name">Threshold</xsl:with-param>
        <xsl:with-param name="comment">Voltage at which the mechanism causes the segment/cell to fire, i.e. membrane potential will be reset to v_reset</xsl:with-param>
        <xsl:with-param name="value">&lt;b&gt;threshold =  <xsl:value-of select="@threshold"/>
                <xsl:call-template name="getUnits"><xsl:with-param name="quantity">Voltage</xsl:with-param></xsl:call-template> &lt;/b&gt;</xsl:with-param>
    </xsl:call-template>

    <xsl:call-template name="tableRow">
        <xsl:with-param name="name">Refractory period</xsl:with-param>
        <xsl:with-param name="comment">Time after a spike during which the segment will be clamped to v_reset (clamping current given by i = g_refrac*(v - v_reset))</xsl:with-param>
        <xsl:with-param name="value">&lt;b&gt;t_refrac =  <xsl:value-of select="@t_refrac"/>
                <xsl:call-template name="getUnits"><xsl:with-param name="quantity">Time</xsl:with-param></xsl:call-template> &lt;/b&gt;</xsl:with-param>
    </xsl:call-template>

    <xsl:call-template name="tableRow">
        <xsl:with-param name="name">Reset membrane potential</xsl:with-param>
        <xsl:with-param name="comment">Membrane potential is reset to this after spiking</xsl:with-param>
        <xsl:with-param name="value">&lt;b&gt; v_reset = <xsl:value-of select="@v_reset"/>
                <xsl:call-template name="getUnits"><xsl:with-param name="quantity">Voltage</xsl:with-param></xsl:call-template> &lt;/b&gt;</xsl:with-param>
    </xsl:call-template>

    <xsl:call-template name="tableRow">
        <xsl:with-param name="name">Conductance dureing refractory period</xsl:with-param>
        <xsl:with-param name="comment">Conductance during the period t_refrac after a spike, when the current due to this mechanism is given by i = g_refrac*(v - v_reset), therefore a high value for g_refrac, e.g. 100 microsiemens, will effectively clamp the cell at v_reset</xsl:with-param>
        <xsl:with-param name="value">&lt;b&gt; g_refrac = <xsl:value-of select="@g_refrac"/>
                <xsl:call-template name="getUnits"><xsl:with-param name="quantity">Conductance</xsl:with-param></xsl:call-template> &lt;/b&gt;</xsl:with-param>
    </xsl:call-template>



</xsl:template>



<xsl:template match="cml:ohmic">


    <xsl:call-template name="tableRow">
        <xsl:with-param name="name">Current voltage relationship</xsl:with-param>
        <xsl:with-param name="comment">Note: only ohmic and integrate_and_fire current voltage relationships are supported in current specification</xsl:with-param>
        <xsl:with-param name="value">&lt;b&gt;Ohmic&lt;/b&gt;</xsl:with-param>
    </xsl:call-template>

   <xsl:variable name="ionname"><xsl:value-of select="@ion"/></xsl:variable>


    <xsl:call-template name="tableRow">
        <xsl:with-param name="name">Ion involved in channel</xsl:with-param>

        <xsl:with-param name="comment">The ion which is actually flowing through the channel and its default reversal potential</xsl:with-param>

        <xsl:with-param name="value">&lt;b&gt;<xsl:value-of select="$ionname"/> (E&lt;sub&gt;<xsl:value-of
        select="$ionname"/>&lt;/sub&gt; = <xsl:value-of select="../../../cml:ion[string(@name) = string($ionname)]/@default_erev"/><xsl:call-template name="getUnits">
            <xsl:with-param name="quantity">Voltage</xsl:with-param></xsl:call-template>&lt;/b&gt;)</xsl:with-param>
    </xsl:call-template>

    <xsl:if test="count(cml:conductance) &gt; 0">
        <xsl:call-template name="tableRow">
            <xsl:with-param name="name">Maximum conductance density</xsl:with-param>
            <xsl:with-param name="value">&lt;b&gt;G&lt;sub&gt;max&lt;/sub&gt; = <xsl:value-of select="cml:conductance/@default_gmax"/> <xsl:call-template name="getUnits">
                <xsl:with-param name="quantity">Conductance Density</xsl:with-param></xsl:call-template>&lt;/b&gt;</xsl:with-param>
        </xsl:call-template>
        
        <xsl:if test="count(cml:conductance/meta:notes) &gt; 0">
            <xsl:call-template name="tableRow">
                <xsl:with-param name="name">Comment on conductance</xsl:with-param>
                <xsl:with-param name="value">&lt;b&gt;<xsl:value-of select="cml:conductance/meta:notes"/>&lt;/b&gt;</xsl:with-param>
            </xsl:call-template>
        </xsl:if>


        <xsl:for-each select="cml:conductance/cml:rate_adjustments/cml:q10_settings">
            <xsl:call-template name="tableRow">
                <xsl:with-param name="name">Q10 scaling</xsl:with-param>
                <xsl:with-param name="comment">Q10 scaling affects the tau in the rate equations. It allows rate equations experimentally calculated at one temperature
                to be used at a different temperature.</xsl:with-param>

                <xsl:with-param name="value">
                    &lt;table  border="0"&gt;&lt;tr&gt;&lt;td&gt;<xsl:choose>
                        <xsl:when test="count(@gate) &gt; 0">Q10 adjustment applied to gate: &lt;/td&gt; &lt;td&gt;&amp;nbsp;&amp;nbsp; &lt;b&gt;<xsl:value-of select="@gate"/>&lt;/b&gt;</xsl:when>
                        <xsl:otherwise>Q10 adjustment applied to gates: &lt;/td&gt; &lt;td&gt;&amp;nbsp;&amp;nbsp; &lt;b&gt;all&lt;/b&gt;</xsl:otherwise>
                    </xsl:choose> &lt;/td&gt;&lt;/tr&gt;
                    <xsl:choose><xsl:when test="count(@q10_factor) &gt; 0">
                    &lt;tr&gt;&lt;td&gt; Q10_factor: &lt;/td&gt; &lt;td&gt;&amp;nbsp;&amp;nbsp; &lt;b&gt;<xsl:value-of select="@q10_factor"/>&lt;/b&gt; &lt;/td&gt;&lt;/tr&gt;
                    &lt;tr&gt;&lt;td&gt; Experimental temperature (at which rate constants below were determined): &lt;/td&gt; &lt;td&gt;&amp;nbsp;&amp;nbsp; &lt;b&gt;<xsl:value-of select="@experimental_temp"/>  &lt;sup&gt;o&lt;/sup&gt;C  &lt;/b&gt; &lt;/td&gt;&lt;/tr&gt;
                    &lt;tr&gt;&lt;td&gt; Expression for tau at T using tauExp as calculated from rate equations: &lt;/td&gt; &lt;td&gt;&amp;nbsp;&amp;nbsp;
                           &lt;b&gt;tau(T) = tauExp / <xsl:value-of select="@q10_factor"/>^((T - <xsl:value-of select="@experimental_temp"/>)/10)&lt;/b&gt; &lt;/td&gt;&lt;/tr&gt;
                           </xsl:when><xsl:when test="count(@fixed_q10) &gt; 0">
                    &lt;tr&gt;&lt;td&gt; Fixed Q10 value (i.e. only specified at one temperature): &lt;/td&gt; &lt;td&gt;&amp;nbsp;&amp;nbsp; &lt;b&gt;<xsl:value-of select="@fixed_q10"/>&lt;/b&gt; &lt;/td&gt;&lt;/tr&gt;
                    &lt;tr&gt;&lt;td&gt; Experimental temperature (sims at other temps should be disallowed): &lt;/td&gt; &lt;td&gt;&amp;nbsp;&amp;nbsp; &lt;b&gt;<xsl:value-of select="@experimental_temp"/>  &lt;sup&gt;o&lt;/sup&gt;C  &lt;/b&gt; &lt;/td&gt;&lt;/tr&gt;
                                        &lt;tr&gt;&lt;td&gt; Expression for tau at T using tauExp as calculated from rate equations: &lt;/td&gt; &lt;td&gt;&amp;nbsp;&amp;nbsp;
                           &lt;b&gt;tau(T) = tauExp / <xsl:value-of select="@fixed_q10"/>&lt;/b&gt; &lt;/td&gt;&lt;/tr&gt;
                    </xsl:when></xsl:choose>
                           
                    &lt;/table&gt;

                </xsl:with-param>
            </xsl:call-template>
        </xsl:for-each>


        <xsl:if test="count(cml:conductance/cml:rate_adjustments/cml:offset) &gt; 0">
            <xsl:call-template name="tableRow">
                <xsl:with-param name="name">Voltage offset</xsl:with-param>
                <xsl:with-param name="comment">This introduces a shift in the voltage dependence of the rate equations.
                    If, for example, the equation parameters being used in a model were from a different species,
                    this offset can be introduced to alter the firing threshold to something closer to the species
                    being modelled. See mappings for details.</xsl:with-param>
                <xsl:with-param name="value">&lt;b&gt;<xsl:value-of select="cml:conductance/cml:rate_adjustments/cml:offset/@value"/> <xsl:call-template name="getUnits">
        <xsl:with-param name="quantity">Voltage</xsl:with-param></xsl:call-template>&lt;/b&gt;</xsl:with-param>
            </xsl:call-template>
        </xsl:if>

        <xsl:call-template name="tableRow">
            <xsl:with-param name="name">Conductance expression</xsl:with-param>
            <xsl:with-param name="comment">Expression giving the actual conductance as a function of time and voltage</xsl:with-param>

            <xsl:with-param name="value">&lt;b&gt;G&lt;sub&gt;<xsl:value-of select="$ionname"/>&lt;/sub&gt;(v,t) = G&lt;sub&gt;max&lt;/sub&gt;
                <xsl:for-each select="cml:conductance/cml:gate">
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
            <xsl:with-param name="value">&lt;b&gt;I&lt;sub&gt;<xsl:value-of select="$ionname"/>&lt;/sub&gt;(v,t) =
                G&lt;sub&gt;<xsl:value-of select="$ionname"/>&lt;/sub&gt;(v,t)<xsl:text> * </xsl:text>(v - E&lt;sub&gt;<xsl:value-of select="$ionname"/>&lt;/sub&gt;)&lt;/b&gt;</xsl:with-param>
        </xsl:call-template>

    </xsl:if>

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

            <xsl:if test="count(cml:tau) = 0 and count(cml:inf) = 0">
                <xsl:call-template name="tableRow">
                    <xsl:with-param name="name">Expression controlling gate:</xsl:with-param>
                    <xsl:with-param name="value">

                        &lt;table border="0"&gt;
                            &lt;tr&gt;
                                &lt;td&gt;
                                    &lt;b&gt;d<xsl:value-of select="$stateName"/>(v,t)&lt;/b&gt;
                                &lt;/td&gt;

                                &lt;td rowspan="2" valign="center"&gt;
                                    &lt;b&gt; = alpha(v) * (1-<xsl:value-of select="$stateName"/>)
                                                    - beta(v) * <xsl:value-of select="$stateName"/>&lt;/b&gt;
                                &lt;/td&gt;

                                &lt;td rowspan="2" valign="center"&gt;
                                    &amp;nbsp;&amp;nbsp;or&amp;nbsp;&amp;nbsp;
                                &lt;/td&gt;

                                &lt;td&gt;
                                    &lt;b&gt;d<xsl:value-of select="$stateName"/>(v,t)&lt;/b&gt;
                                &lt;/td&gt;

                                 &lt;td rowspan="2" valign="center"&gt;
                                    &lt;b&gt; = &lt;/b&gt;
                                &lt;/td&gt;

                                &lt;td rowspan="1" valign="center"&gt;
                                    &lt;b&gt;inf(v) - <xsl:value-of select="$stateName"/>&lt;/b&gt;
                                &lt;/td&gt;

                            &lt;/tr&gt;
                            &lt;tr&gt;

                                &lt;td align="center" style="border-top:solid 1px black;"&gt;
                                    &lt;b&gt;dt&lt;/b&gt;
                                &lt;/td&gt;

                                &lt;td align="center" style="border-top:solid 1px black;"&gt;
                                    &lt;b&gt;dt&lt;/b&gt;
                                &lt;/td&gt;


                                &lt;td align="center" style="border-top:solid 1px black;"&gt;
                                    &lt;b&gt;tau(v)&lt;/b&gt;
                                &lt;/td&gt;
                            &lt;/tr&gt;
                        &lt;/table&gt;

                    </xsl:with-param>
                </xsl:call-template>
            </xsl:if>

            <xsl:if test="count(cml:tau) &gt; 0 or count(cml:inf) &gt; 0">
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
                                    &lt;b&gt; = &lt;/b&gt;
                                &lt;/td&gt;

                                &lt;td rowspan="1" valign="center"&gt;
                                    &lt;b&gt;inf(v) - <xsl:value-of select="$stateName"/>&lt;/b&gt;
                                &lt;/td&gt;

                            &lt;/tr&gt;
                            &lt;tr&gt;
                                &lt;td align="center" style="border-top:solid 1px black;"&gt;
                                    &lt;b&gt;dt&lt;/b&gt;
                                &lt;/td&gt;

                                &lt;td align="center" style="border-top:solid 1px black;"&gt;
                                    &lt;b&gt;tau(v)&lt;/b&gt;
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

                <xsl:for-each select="meta:notes">
                    <xsl:call-template name="tableRow">
                        <xsl:with-param name="name">Notes</xsl:with-param>
                        <xsl:with-param name="comment">Comment from ChannelML file on this rate equation</xsl:with-param>
                        <xsl:with-param name="value">&lt;b&gt;<xsl:value-of select="."/>&lt;/b&gt;</xsl:with-param>
                    </xsl:call-template>
                </xsl:for-each>

                <xsl:choose>
                    <xsl:when  test="name()='conc_dependence'">
                        <xsl:call-template name="tableRow">
                            <xsl:with-param name="name">Concentration dependent gate</xsl:with-param>
                            <xsl:with-param name="comment">The dynamics of this gate are dependent on both the potential difference across the
                            channel, and on the concentration of the substance specified here</xsl:with-param>
                            <xsl:with-param name="value">Name: &lt;b&gt;<xsl:value-of select="@name"/>&lt;/b&gt;&lt;br/&gt;
                                Ion: &lt;b&gt;<xsl:value-of select="@ion"/>&lt;/b&gt;&lt;br/&gt;
                                Variable as used in equation below: &lt;b&gt;<xsl:value-of select="@variable_name"/>&lt;/b&gt;&lt;br/&gt;
                                Min concentration: &lt;b&gt;<xsl:value-of select="@min_conc"/>&lt;/b&gt; (required by simulators for table of voltage/conc dependencies)&lt;br/&gt;
                                Max concentration: &lt;b&gt;<xsl:value-of select="@max_conc"/>&lt;/b&gt; (required by simulators for table of voltage/conc dependencies)
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
                                    <xsl:with-param name="value">&lt;b&gt;<xsl:value-of select="name()"/>(v) = <xsl:choose>
                                        <xsl:when test="cml:parameterised_hh/@type='linoid'" >A*(k*(v-d)) / (1 - exp(-(k*(v-d))))</xsl:when>
                                        <xsl:when test="cml:parameterised_hh/@type='exponential'" >A*exp(k*(v-d))</xsl:when>
                                        <xsl:when test="cml:parameterised_hh/@type='sigmoid'" >A / (1 + exp(k*(v-d)))</xsl:when>
                                        <xsl:otherwise >Unsupported expression type!</xsl:otherwise>
                                        
                                    </xsl:choose>&lt;/b&gt; &amp;nbsp;&amp;nbsp; &lt;i&gt;(<xsl:value-of select="cml:parameterised_hh/@type" />)&lt;/i&gt;</xsl:with-param>
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

                                    </xsl:choose>&lt;/b&gt;</xsl:with-param>
                                </xsl:call-template>


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

            <xsl:if test="count(cml:alpha) &gt; 0 and
                    count(cml:beta) &gt; 0 and count(cml:tau) = 0">

                <xsl:call-template name="tableRow">
                    <xsl:with-param name="name">&amp;nbsp;&amp;nbsp; &lt;b&gt;tau&lt;/b&gt;</xsl:with-param>
                    <xsl:with-param name="comment"></xsl:with-param>
                </xsl:call-template>


                <xsl:call-template name="tableRow">
                    <xsl:with-param name="name">Expression for tau</xsl:with-param>
                    <xsl:with-param name="comment"></xsl:with-param>
                    <xsl:with-param name="value">

                        &lt;table border="0"&gt;
                            &lt;tr&gt;

                                &lt;td rowspan="2" valign="center"&gt;
                                    &lt;b&gt;tau(v) = &lt;/b&gt;
                                &lt;/td&gt;

                                 &lt;td  align="center"&gt;
                                    &lt;b&gt;1&lt;/b&gt;
                                &lt;/td&gt;

                            &lt;/tr&gt;
                            &lt;tr&gt;

                                &lt;td align="center" style="border-top:solid 1px black;"&gt;
                                    &lt;b&gt;alpha(v) + beta(v)&lt;/b&gt;
                                &lt;/td&gt;

                            &lt;/tr&gt;
                        &lt;/table&gt;

                        &lt;/b&gt;
                    </xsl:with-param>

                </xsl:call-template>

            </xsl:if>

            <xsl:if test="count(cml:alpha) &gt; 0 and
                    count(cml:beta) &gt; 0 and count(cml:inf) = 0">

                <xsl:call-template name="tableRow">
                    <xsl:with-param name="name">&amp;nbsp;&amp;nbsp; &lt;b&gt;inf&lt;/b&gt;</xsl:with-param>
                    <xsl:with-param name="comment"></xsl:with-param>
                </xsl:call-template>


                <xsl:call-template name="tableRow">
                    <xsl:with-param name="name">Expression for inf</xsl:with-param>
                    <xsl:with-param name="comment"></xsl:with-param>
                    <xsl:with-param name="value">

                        &lt;table border="0"&gt;
                            &lt;tr&gt;

                                &lt;td rowspan="2" valign="center"&gt;
                                    &lt;b&gt;inf(v) = &lt;/b&gt;
                                &lt;/td&gt;

                                 &lt;td  align="center"&gt;
                                    &lt;b&gt;alpha(v)&lt;/b&gt;
                                &lt;/td&gt;

                            &lt;/tr&gt;
                            &lt;tr&gt;

                                &lt;td align="center" style="border-top:solid 1px black;"&gt;
                                    &lt;b&gt;alpha(v) + beta(v)&lt;/b&gt;
                                &lt;/td&gt;

                            &lt;/tr&gt;
                        &lt;/table&gt;

                        &lt;/b&gt;
                    </xsl:with-param>
                </xsl:call-template>

            </xsl:if>


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
        
                

<xsl:apply-templates select="cml:status"/> 

        
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
        <xsl:apply-templates select="meta:modelDBref"/>


        <xsl:call-template name="tableRow">
                <xsl:with-param name="name">Ion species</xsl:with-param>
                <xsl:with-param name="comment">The type of ion whose concentration will be altered</xsl:with-param>
                <xsl:with-param name="value">&lt;b&gt;<xsl:value-of select="cml:ion_species"/><xsl:value-of select="cml:ion_species/@name"/>&lt;/b&gt;</xsl:with-param>
        </xsl:call-template>

        <xsl:for-each select="cml:decaying_pool_model">
            <xsl:call-template name="tableRow">
                <xsl:with-param name="name">  Dynamic model: &lt;b&gt;<xsl:value-of select="name()"/>&lt;/b&gt;</xsl:with-param>
                <xsl:with-param name="comment">The model underlying the mechanism altering the ion concentration</xsl:with-param>
            </xsl:call-template>
            <xsl:call-template name="tableRow">
                <xsl:with-param name="name">Resting concentration</xsl:with-param>
                <xsl:with-param name="comment">The base level concentration of the ion</xsl:with-param>
                <xsl:with-param name="value">&lt;b&gt;<xsl:value-of select="cml:resting_conc"/><xsl:value-of select="@resting_conc"/> <!-- Either element or attr will be present...-->
                    <xsl:call-template name="getUnits">
                    <xsl:with-param name="quantity">Concentration</xsl:with-param></xsl:call-template>&lt;/b&gt;
                </xsl:with-param>
            </xsl:call-template>
            
            
            <xsl:choose>
                <xsl:when test="count(cml:decay_constant) &gt; 0 or count(@decay_constant) &gt; 0">
                    <xsl:call-template name="tableRow">
                        <xsl:with-param name="name">Decay Constant</xsl:with-param>
                        <xsl:with-param name="comment">The rate of decay (tau) of the concentration back to resting level</xsl:with-param>
                        <xsl:with-param name="value">&lt;b&gt;<xsl:value-of select="cml:decay_constant"/><xsl:value-of select="@decay_constant"/> <!-- Either element or attr will be present...-->
                            <xsl:call-template name="getUnits">
                            <xsl:with-param name="quantity">Time</xsl:with-param></xsl:call-template>&lt;/b&gt;
                        </xsl:with-param>
                    </xsl:call-template>
                </xsl:when>
                <xsl:when test="count(cml:inv_decay_constant) &gt; 0 or count(@inv_decay_constant) &gt; 0">
                    <xsl:call-template name="tableRow">
                        <xsl:with-param name="name">Inverse Decay Constant</xsl:with-param>
                        <xsl:with-param name="comment">The reciprocal of the rate of decay of the concentration back to resting level</xsl:with-param>
                        <xsl:with-param name="value">&lt;b&gt;<xsl:value-of select="cml:inv_decay_constant"/><xsl:value-of select="@inv_decay_constant"/>  <!-- Either element or attr will be present...-->
                            <xsl:call-template name="getUnits">
                            <xsl:with-param name="quantity">InvTime</xsl:with-param></xsl:call-template>&lt;/b&gt;
                        </xsl:with-param>
                    </xsl:call-template>
                </xsl:when>
            </xsl:choose>
            
            
            
            
            <xsl:if test="count(cml:ceiling) &gt; 0 or count(@ceiling) &gt; 0">
                <xsl:call-template name="tableRow">
                    <xsl:with-param name="name">Concentration ceiling</xsl:with-param>
                    <xsl:with-param name="comment">The maximum concentration which the ion pool should be allowed get to.</xsl:with-param>
                    <xsl:with-param name="value">&lt;b&gt;<xsl:value-of select="cml:ceiling"/><xsl:value-of select="@ceiling"/> <!-- Either element or attr will be present...-->
                        <xsl:call-template name="getUnits">
                            <xsl:with-param name="quantity">Concentration</xsl:with-param>
                        </xsl:call-template>&lt;/b&gt;
                    </xsl:with-param>
                </xsl:call-template>
            </xsl:if>
            
            
            <xsl:if test="count(cml:pool_volume_info) &gt; 0">
                <xsl:call-template name="tableRow">
                    <xsl:with-param name="name">Shell Thickness</xsl:with-param>
                    <xsl:with-param name="comment">The thickness of a shell under the cell membrane where all the change in ion concentration is assumed to take place</xsl:with-param>
                    <xsl:with-param name="value">&lt;b&gt;<xsl:value-of select="cml:pool_volume_info/cml:shell_thickness"/><xsl:value-of select="cml:pool_volume_info/@shell_thickness"/> 
                    <xsl:call-template name="getUnits">
                        <xsl:with-param name="quantity">Length</xsl:with-param></xsl:call-template>&lt;/b&gt;
                    </xsl:with-param>
                </xsl:call-template>
            </xsl:if>
            
            
            <xsl:if test="count(cml:fixed_pool_info) &gt; 0">
                <xsl:call-template name="tableRow">
                    <xsl:with-param name="name">Pool info</xsl:with-param>
                    <xsl:with-param name="comment">In this case the parameter (phi) which determines how quickly the internal pool 'fills' is given as a fixed 
                    value. Note this is not an ideal way to express this value, but needed to be included as this was the parameter which was all 
                    that was present in a number of models, e.g. Traub et al. 2003 Layer 2/3 cell. The dC/dt will be calculated from dC/dt = 
                    - phi * Ica + [Ca]/decay_constant. See mod/GENESIS impl for more details</xsl:with-param>
                    <xsl:with-param name="value">&lt;b&gt;<xsl:value-of select="cml:fixed_pool_info/cml:phi"/> &lt;/b&gt;
                    </xsl:with-param>
                </xsl:call-template>
            </xsl:if>
            
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
        
        

<xsl:apply-templates select="cml:status"/> 

        
        
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
        <xsl:apply-templates select="meta:modelDBref"/>

        <xsl:apply-templates select="cml:electrical_syn"/>
        <xsl:apply-templates select="cml:doub_exp_syn"/>
        <xsl:apply-templates select="cml:blocking_syn"/>
        <xsl:apply-templates select="cml:multi_decay_syn"/>
    </table>

</xsl:template>



<xsl:template match="cml:electrical_syn">
    <xsl:call-template name="tableRow">
        <xsl:with-param name="name">Synaptic Mechanism Model: &lt;b&gt;Electrical Synapse&lt;/b&gt;</xsl:with-param>
        <xsl:with-param name="comment">The model underlying the synaptic mechanism</xsl:with-param>
    </xsl:call-template>
    

    <xsl:call-template name="tableRow">
        <xsl:with-param name="name">Conductance</xsl:with-param>
        <xsl:with-param name="comment">The conductance of the electrical connection</xsl:with-param>
        <xsl:with-param name="value">&lt;b&gt;<xsl:value-of select="@conductance"/> <xsl:call-template name="getUnits">
                    <xsl:with-param name="quantity">Conductance</xsl:with-param></xsl:call-template>&lt;/b&gt;</xsl:with-param>
    </xsl:call-template>
    
    </xsl:template>

<xsl:template match="cml:doub_exp_syn">
    <xsl:call-template name="tableRow">
        <xsl:with-param name="name">Synaptic Mechanism Model: &lt;b&gt;Double Exponential Synapse&lt;/b&gt;</xsl:with-param>
        <xsl:with-param name="comment">The model underlying the synaptic mechanism</xsl:with-param>
    </xsl:call-template>
    
    <xsl:call-template name="tableRow">
        <xsl:with-param name="name">Expression for conductance</xsl:with-param>
        <xsl:with-param name="value">
    
    &lt;table border="0"&gt;
                &lt;tr&gt;
                    &lt;td  colspan="2" valign="center"&gt;
                        &lt;b&gt;G(t) = max_conductance * A * ( e&lt;sup&gt;-t/decay_time&lt;/sup&gt; - e&lt;sup&gt;-t/rise_time&lt;/sup&gt; ) &amp;nbsp;&amp;nbsp; for t >= 0  &lt;/b&gt;
                    &lt;/td&gt;
             
                    
                &lt;/tr&gt;
                
                &lt;tr&gt;
                    &lt;td  colspan="2" &gt;&amp;nbsp;&lt;/td&gt;
                &lt;/tr&gt;
                
                &lt;tr&gt;
                    &lt;td colspan="2" &gt;where the normalisation factor is:&lt;/td&gt;
                &lt;/tr&gt;
                
                &lt;tr&gt;
                    &lt;td  rowspan="2" valign="center"&gt;
                        &lt;b&gt;A =&lt;/b&gt;
                    &lt;/td&gt;
                    &lt;td align="center"&gt;
                        &lt;b&gt;1&lt;/b&gt;
                    &lt;/td&gt;
                &lt;/tr&gt;
                &lt;tr&gt;
                    &lt;td align="center" style="border-top:solid 1px black;"&gt;
                        &lt;b&gt; e&lt;sup&gt;-peak_time / decay_time&lt;/sup&gt; - e&lt;sup&gt; -peak_time / rise_time&lt;/sup&gt;  &lt;/sup&gt;&lt;/b&gt;
                    &lt;/td&gt;
                &lt;/tr&gt;
                
                &lt;tr&gt;
                    &lt;td  colspan="2" &gt;and the time to reach max conductance is:&lt;/td&gt;
                &lt;/tr&gt;
                
                &lt;tr&gt;
                    &lt;td  valign="center"&gt;
                        &lt;b&gt;peak_time =&lt;/b&gt;
                    &lt;/td&gt;
                    &lt;td align="center"&gt;
                        &lt;b&gt;&lt;sup&gt;(decay_time * rise_time)&lt;/sup&gt;/&lt;sub&gt;(decay_time - rise_time)&lt;/sub&gt; * ln(&lt;sup&gt;decay_time&lt;/sup&gt;/&lt;sub&gt;rise_time&lt;/sub&gt;)&lt;/b&gt;
                    &lt;/td&gt;
                &lt;/tr&gt;
                
                &lt;tr&gt;
                    &lt;td  colspan="2" &gt;&amp;nbsp;&lt;/td&gt;
                &lt;/tr&gt;
                
                &lt;tr&gt;
                    &lt;td  colspan="2" &gt;Note that if rise_time = 0 this simplifies to a &lt;u&gt;single exponential synapse&lt;/u&gt;:&lt;/td&gt;
                &lt;/tr&gt;
                
                &lt;tr&gt;
                    &lt;td  colspan="2" valign="center"&gt;
                        &lt;b&gt;G(t) = max_conductance * e&lt;sup&gt;-t/decay_time&lt;/sup&gt; &amp;nbsp;&amp;nbsp;  for t >= 0    &lt;/b&gt;
                    &lt;/td&gt;
                
                &lt;tr&gt;
                    &lt;td  colspan="2" &gt;&amp;nbsp;&lt;/td&gt;
                &lt;/tr&gt;
                
                &lt;tr&gt;
                    &lt;td  colspan="2" &gt;Note also if decay_time = rise_time = alpha_time, the waveform is for an &lt;u&gt;alpha synapse&lt;/u&gt; with peak at alpha_time:&lt;/td&gt;
                &lt;/tr&gt;
                
                &lt;tr&gt;
                    &lt;td  colspan="2" valign="center"&gt;
                        &lt;b&gt;G(t) = max_conductance * (&lt;sup&gt;t&lt;/sup&gt;/&lt;sub&gt;alpha_time&lt;/sub&gt;) * e&lt;sup&gt;( 1 - t/alpha_time)&lt;/sup&gt; &amp;nbsp;&amp;nbsp;  for t >= 0    &lt;/b&gt;
                    &lt;/td&gt;
             
                    
                &lt;/tr&gt;
                
            &lt;/table&gt;
    
    
    </xsl:with-param>
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





<xsl:template match="cml:multi_decay_syn">
    <xsl:call-template name="tableRow">
        <xsl:with-param name="name">Synaptic Mechanism Model: &lt;b&gt;Multi decay time course Synapse&lt;/b&gt;</xsl:with-param>
        <xsl:with-param name="comment">The model underlying the synaptic mechanism</xsl:with-param>
    </xsl:call-template>


    <xsl:apply-templates select="@max_conductance"/>

    <xsl:apply-templates select="@rise_time"/>
    <xsl:apply-templates select="@decay_time"/>

    

    <xsl:call-template name="tableRow">
        <xsl:with-param name="name">Maximum conductance 2</xsl:with-param>
        <xsl:with-param name="comment">The peak value of the 2nd (usually slower) component of the synaptic conductance</xsl:with-param>
        <xsl:with-param name="value">&lt;b&gt;<xsl:value-of select="@max_conductance_2"/> <xsl:call-template name="getUnits">
                    <xsl:with-param name="quantity">Conductance</xsl:with-param></xsl:call-template>&lt;/b&gt;</xsl:with-param>
    </xsl:call-template>
    
    <xsl:call-template name="tableRow">
        <xsl:with-param name="name">Decay time 2</xsl:with-param>
        <xsl:with-param name="comment">Second characteristic time (tau) over which the 2nd (usually slower) component of the synaptic conductance decays</xsl:with-param>
        <xsl:with-param name="value">&lt;b&gt;<xsl:value-of select="@decay_time_2"/> <xsl:call-template name="getUnits">
                    <xsl:with-param name="quantity">Time</xsl:with-param></xsl:call-template>&lt;/b&gt;</xsl:with-param>
    </xsl:call-template>
    
    
    
    <xsl:if test="count(@max_conductance_3) &gt; 0">
        <xsl:call-template name="tableRow">
            <xsl:with-param name="name">Maximum conductance 3</xsl:with-param>
            <xsl:with-param name="comment">The peak value of the 3rd (usually quite slow) component of the synaptic conductance</xsl:with-param>
            <xsl:with-param name="value">&lt;b&gt;<xsl:value-of select="@max_conductance_3"/> <xsl:call-template name="getUnits">
                        <xsl:with-param name="quantity">Conductance</xsl:with-param></xsl:call-template>&lt;/b&gt;</xsl:with-param>
        </xsl:call-template>
    </xsl:if>
    
    <xsl:if test="count(@decay_time_3) &gt; 0">
        <xsl:call-template name="tableRow">
            <xsl:with-param name="name">Decay time 3</xsl:with-param>
            <xsl:with-param name="comment">Third characteristic time (tau) over which the 2nd (usually quite slow) component of the synaptic conductance decays</xsl:with-param>
            <xsl:with-param name="value">&lt;b&gt;<xsl:value-of select="@decay_time_3"/> <xsl:call-template name="getUnits">
                        <xsl:with-param name="quantity">Time</xsl:with-param></xsl:call-template>&lt;/b&gt;</xsl:with-param>
        </xsl:call-template>
    </xsl:if>
        
    <xsl:apply-templates select="@reversal_potential"/>


</xsl:template>









</xsl:stylesheet>
