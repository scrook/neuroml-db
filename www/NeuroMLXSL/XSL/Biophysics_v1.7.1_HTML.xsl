<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="1.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:bio="http://morphml.org/biophysics/schema"
    xmlns:cml="http://morphml.org/channelml/schema"
    xmlns:meta="http://morphml.org/metadata/schema" >

    <xsl:import href="../ReadableUtils.xsl"/>
    
<!--

    This file is used to convert v1.7.1 Biophysics info to a "neuroscientist friendly" HTML view
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
    
    
    
    <xsl:when test="@type='Channel Mechanism'">
        <xsl:call-template name="tableRow">
            <xsl:with-param name="name">Channel Mechanism: &lt;b&gt;<xsl:value-of select="@name"/>&lt;/b&gt;</xsl:with-param>
            <xsl:with-param name="comment">An active membrane conductance</xsl:with-param>
            <xsl:with-param name="value">
            <xsl:if test="(count(@passiveConductance) &gt; 0 and ( @passiveConductance='true' or @passiveConductance='1')) or
                          (count(@passive_conductance) &gt; 0 and ( @passive_conductance='true' or @passive_conductance='1'))">
                This is a &lt;b&gt;Passive Conductance&lt;/b&gt; and so conductance density (&lt;b&gt;gmax&lt;/b&gt;) and 
                reversal potential (&lt;b&gt;e&lt;/b&gt;) should be sufficient parameters to specify the mechanism fully.
            </xsl:if>
            <xsl:for-each select="bio:parameter">&lt;p&gt;
                <xsl:choose>
                    <xsl:when test="@name='gmax'">
                        Conductance density (&lt;b&gt;gmax&lt;/b&gt;) of &lt;b&gt;<xsl:value-of select="@value"/> <xsl:call-template name="getUnitsInSystem">
                                <xsl:with-param name="quantity">Conductance Density</xsl:with-param>
                                <xsl:with-param name="xmlFileUnitSystem"><xsl:value-of select="$xmlFileUnitSystem"/></xsl:with-param>
                        </xsl:call-template>&lt;/b&gt; on: &lt;b&gt;<xsl:for-each select="bio:group"><xsl:value-of select="."/>&amp;nbsp;</xsl:for-each>&lt;/b&gt;
                    </xsl:when>
                    <xsl:when test="@name='e'">
                        Reversal potential (&lt;b&gt;e&lt;/b&gt;) of &lt;b&gt;<xsl:value-of select="@value"/> <xsl:call-template name="getUnitsInSystem">
                                <xsl:with-param name="quantity">Voltage</xsl:with-param>
                                <xsl:with-param name="xmlFileUnitSystem"><xsl:value-of select="$xmlFileUnitSystem"/></xsl:with-param>
                        </xsl:call-template>&lt;/b&gt; on: &lt;b&gt;<xsl:for-each select="bio:group"><xsl:value-of select="."/>&amp;nbsp;</xsl:for-each>&lt;/b&gt;
                    </xsl:when>
                    <xsl:otherwise>
                        Parameter &lt;b&gt;<xsl:value-of select="@name"/>&lt;/b&gt; has value  &lt;b&gt;<xsl:value-of select="@value"/> &lt;/b&gt; on: &lt;b&gt;<xsl:for-each select="bio:group"><xsl:value-of select="."/>&amp;nbsp;</xsl:for-each>&lt;/b&gt;
                    </xsl:otherwise>
                </xsl:choose>&lt;/p&gt;
            </xsl:for-each>
            </xsl:with-param>
        </xsl:call-template>
    </xsl:when>
    
    
    
    </xsl:choose>

</xsl:template>



<xsl:template match="bio:specificCapacitance | bio:spec_capacitance">
    
    <xsl:variable name="xmlFileUnitSystem"><xsl:value-of select="../@units"/></xsl:variable>   
    
    <xsl:call-template name="tableRow">
            <xsl:with-param name="name">Specific Capacitance</xsl:with-param>
            <xsl:with-param name="comment">This is the capacitance per unit area of the membrane</xsl:with-param>
            <xsl:with-param name="value">
                
                <xsl:for-each select="bio:parameter">&lt;p&gt;Specific Capacitance of &lt;b&gt;

                    <xsl:value-of select="@value"/> <xsl:call-template name="getUnitsInSystem">
                                    <xsl:with-param name="quantity">Specific Capacitance</xsl:with-param>
                                    <xsl:with-param name="xmlFileUnitSystem"><xsl:value-of select="$xmlFileUnitSystem"/></xsl:with-param>
                                    </xsl:call-template>&lt;/b&gt; on: &lt;b&gt;<xsl:for-each select="bio:group"><xsl:value-of select="."/>&amp;nbsp;</xsl:for-each>&lt;/b&gt;
                </xsl:for-each>
              
            </xsl:with-param>
        </xsl:call-template>
</xsl:template>



<xsl:template match="bio:specificAxialResistance | bio:spec_axial_resistance">
    
    <xsl:variable name="xmlFileUnitSystem"><xsl:value-of select="../@units"/></xsl:variable>   
    
    <xsl:call-template name="tableRow">
            <xsl:with-param name="name">Specific Axial Resistance</xsl:with-param>
            <xsl:with-param name="comment">This is the specific cytoplasmic resistance along a dendrite/axon</xsl:with-param>
            <xsl:with-param name="value">
                
                <xsl:for-each select="bio:parameter">&lt;p&gt;Specific Axial Resistance of &lt;b&gt;
                    
                    <xsl:value-of select="@value"/> <xsl:call-template name="getUnitsInSystem">
                        <xsl:with-param name="quantity">Specific Resistance</xsl:with-param>
                        <xsl:with-param name="xmlFileUnitSystem"><xsl:value-of select="$xmlFileUnitSystem"/></xsl:with-param>
                    </xsl:call-template>&lt;/b&gt; on: &lt;b&gt;<xsl:for-each select="bio:group"><xsl:value-of select="."/>&amp;nbsp;</xsl:for-each>&lt;/b&gt;
                </xsl:for-each>
            </xsl:with-param>
        </xsl:call-template>
</xsl:template>




<xsl:template match="bio:initialMembPotential | bio:init_memb_potential">
    
    <xsl:variable name="xmlFileUnitSystem"><xsl:value-of select="../@units"/></xsl:variable>   
    
    <xsl:call-template name="tableRow">
            <xsl:with-param name="name">Initial Membrane Potential</xsl:with-param>
            <xsl:with-param name="comment">This quantity is often required for computational simulations and specifies the potential
                difference across the membrane at the start of the simulation.</xsl:with-param>
            <xsl:with-param name="value">
                
                <xsl:for-each select="bio:parameter">&lt;p&gt;Initial Membrane Potential &lt;b&gt;

                    <xsl:value-of select="@value"/> <xsl:call-template name="getUnitsInSystem">
                                    <xsl:with-param name="quantity">Voltage</xsl:with-param>
                                    <xsl:with-param name="xmlFileUnitSystem"><xsl:value-of select="$xmlFileUnitSystem"/></xsl:with-param>
                                    </xsl:call-template>&lt;/b&gt; on: &lt;b&gt;<xsl:for-each select="bio:group"><xsl:value-of select="."/>&amp;nbsp;</xsl:for-each>&lt;/b&gt;
                </xsl:for-each>
            </xsl:with-param>
        </xsl:call-template>
</xsl:template>

</xsl:stylesheet>
