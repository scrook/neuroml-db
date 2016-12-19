<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="1.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:bio="http://morphml.org/biophysics/schema"
    xmlns:cml="http://morphml.org/channelml/schema"
    xmlns:meta="http://morphml.org/metadata/schema" >

    <xsl:import href="../ReadableUtils.xsl"/>
    
<!--

    This file is used to convert v1.5 Biophysics info to a "neuroscientist friendly" HTML view
    This file is taken from the neuroConstruct source code
    
    This file has been developed as part of the neuroConstruct project
    
    Funding for this work has been received from the Medical Research Council
    
    Author: Padraig Gleeson
    Copyright 2007 Department of Physiology, UCL
    
-->

<xsl:output method="html" indent="yes" />

<xsl:template match="bio:mechanism">

    <xsl:variable name="xmlFileUnitSystem"><xsl:value-of select="../@units"/></xsl:variable>   
    
    <xsl:choose>
        <!--
    <xsl:when test="@type='Initial Membrane Potential'">
        <xsl:call-template name="tableRow">
            <xsl:with-param name="name">Initial Membrane Potential</xsl:with-param>
            <xsl:with-param name="comment">This quantity is often required for computational simulations and specifies the potential
                difference across the membrane at the start of the simulation. This is an optional field</xsl:with-param>
            <xsl:with-param name="value"><xsl:value-of select="@value"/> <xsl:call-template name="getUnitsInSystem">
                                <xsl:with-param name="quantity">Voltage</xsl:with-param>
                                <xsl:with-param name="xmlFileUnitSystem"><xsl:value-of select="$xmlFileUnitSystem"/></xsl:with-param>
                        </xsl:call-template>
            </xsl:with-param>
        </xsl:call-template>
    </xsl:when>
    
    <xsl:when test="@type='Specific Capacitance'">
        <xsl:call-template name="tableRow">
            <xsl:with-param name="name">Specific Capacitance</xsl:with-param>
            <xsl:with-param name="comment">This is the capacitance per unit area of the membrane</xsl:with-param>
            <xsl:with-param name="value"><xsl:value-of select="@value"/> <xsl:call-template name="getUnitsInSystem">
                                <xsl:with-param name="quantity">Specific Capacitance</xsl:with-param>
                                <xsl:with-param name="xmlFileUnitSystem"><xsl:value-of select="$xmlFileUnitSystem"/></xsl:with-param>
                        </xsl:call-template>
            </xsl:with-param>
        </xsl:call-template>
    </xsl:when>
    
    <xsl:when test="@type='Specific Axial Resistance'">
        <xsl:call-template name="tableRow">
            <xsl:with-param name="name">Specific Axial Resistance</xsl:with-param>
            <xsl:with-param name="comment">This is the specific cytoplasmic resistance along a dendrite/axon</xsl:with-param>
            <xsl:with-param name="value"><xsl:value-of select="@value"/> <xsl:call-template name="getUnitsInSystem">
                                <xsl:with-param name="quantity">Specific Resistance</xsl:with-param>
                                <xsl:with-param name="xmlFileUnitSystem"><xsl:value-of select="$xmlFileUnitSystem"/></xsl:with-param>
                        </xsl:call-template>
            </xsl:with-param>
        </xsl:call-template>
    </xsl:when>-->
    
    
    
    <xsl:when test="@type='Channel Mechanism'">
        <xsl:call-template name="tableRow">
            <xsl:with-param name="name">Channel Mechanism: &lt;b&gt;<xsl:value-of select="@name"/>&lt;/b&gt;</xsl:with-param>
            <xsl:with-param name="comment">An active membrane conductance</xsl:with-param>
            <xsl:with-param name="value">
            <xsl:for-each select="bio:parameter">&lt;p&gt;
                <xsl:choose>
                    <xsl:when test="@name='gmax'">
                        Conductance density of &lt;b&gt;<xsl:value-of select="@value"/> <xsl:call-template name="getUnitsInSystem">
                                <xsl:with-param name="quantity">Conductance Density</xsl:with-param>
                                <xsl:with-param name="xmlFileUnitSystem"><xsl:value-of select="$xmlFileUnitSystem"/></xsl:with-param>
                        </xsl:call-template>&lt;/b&gt; on &lt;b&gt;<xsl:for-each select="bio:group"><xsl:value-of select="."/>&amp;nbsp;</xsl:for-each>&lt;/b&gt;
                    </xsl:when>
                </xsl:choose>&lt;/p&gt;
            </xsl:for-each>
            </xsl:with-param>
        </xsl:call-template>
    </xsl:when>
    
    
    <!--
    <xsl:when test="@type='Potential Synaptic Connection Location'">
        <xsl:call-template name="tableRow">
            <xsl:with-param name="name">Potential Synapse Location</xsl:with-param>
            <xsl:with-param name="comment">The name of a Synaptic Mechanism and the groups of cables which are 
                potential locations of this synapse type</xsl:with-param>
            <xsl:with-param name="value">Synaptic mechanism &lt;b&gt;<xsl:value-of select="@name"/>&lt;/b&gt; can be present on group 
            &lt;b&gt;<xsl:value-of select="group"/>&lt;/b&gt;</xsl:with-param>
        </xsl:call-template>
    </xsl:when>-->
    
    
    
    </xsl:choose>

</xsl:template>


</xsl:stylesheet>
