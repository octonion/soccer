<?xml version="1.0" encoding="UTF-8" ?>
<xsl:stylesheet version="1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:fifacom="urn:fifa.com"
  xmlns:xslext="urn:xslext.fifa.com"
	xmlns:basicext="urn:basicext.fifaExtension.com"
  exclude-result-prefixes="xsl fifacom xslext basicext">

  <xsl:output method="xml"
  version="1.0"
  encoding="UTF-8"
  indent="no"
  omit-xml-declaration="yes"/>

  <xsl:include href="../../commons/xslt.includes/commonElements.xslt"/>
  <xsl:include href="../../commons/xslt.includes/matchRow.xslt"/>
  <xsl:include href="../../commons/xslt.includes/competition.xslt"/>
  <xsl:variable name="parameters.list" select="/root/parameters/parameter"/>

  <xsl:variable name="xslMode" select ="$parameters.list[@name='xslMode']" />
  <xsl:variable name ="enableAccordion" select="$parameters.list[@name='enableAccordion']" />
  <xsl:variable name="showCompName">
    <xsl:choose>
      <xsl:when test="string-length(xslext:ParseParameter($xslMode,'showCompetitionName'))&gt;0">
        <xsl:value-of select="xslext:ParseParameter($xslMode,'showCompetitionName')"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="'false'"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>
  <xsl:variable name="showDate">
    <xsl:choose>
      <xsl:when test="string-length(xslext:ParseParameter($xslMode,'showDate'))&gt;0">
        <xsl:value-of select="xslext:ParseParameter($xslMode,'showDate')"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="'true'"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>
  <xsl:variable name="showGroup">
    <xsl:choose>
      <xsl:when test="string-length(xslext:ParseParameter($xslMode,'showGroupName'))&gt;0">
        <xsl:value-of select="xslext:ParseParameter($xslMode,'showGroupName')"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="'false'"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>
  <xsl:variable name="showMonth">
    <xsl:choose>
      <xsl:when test="string-length(xslext:ParseParameter($xslMode,'showMonth'))&gt;0">
        <xsl:value-of select="xslext:ParseParameter($xslMode,'showMonth')"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="'false'"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <xsl:variable name="showVenue">
    <xsl:choose>
      <xsl:when test="string-length(xslext:ParseParameter($xslMode,'showVenue'))&gt;0">
        <xsl:value-of select="xslext:ParseParameter($xslMode,'showVenue')"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="'false'"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>


  <!--this is an override example-->
  <xsl:template match="/">
    <xsl:variable name="time_start" select="basicext:GetJsTimeNow()"/>
    <xsl:variable name="comps" select="root/Competitions/Competition"/>
    <xsl:variable name="matches.all" select="root/Matches/Match"/>
    <xsl:variable name="isCurrentCalendar" select="root/CompetitionCalendar/IsCurrent"/>
    <xsl:variable name="inner.idcs" select="//IdCupSeason"/>
    <xsl:variable name="inner.competitionUrl" select="//CompetitionUrl"/>
    <xsl:for-each select="$comps">
      <xsl:variable name="idcs" select="IdCupSeason"/>
      <xsl:variable name="matches" select="$matches.all[IdCupSeason=$idcs]"/>
      <xsl:if test="count($matches)&gt;0">
        <!--BUILD BOX-->

        <xsl:if test="$showMonth='true'">
          <div class="month-label">
            <xsl:value-of select="xslext:FormatDate($parameters.list[@name='dateFrom'],'MMMM yyyy')"/>
          </div>
        </xsl:if>

        <div>
          <xsl:attribute name="class">
            <xsl:text>box accordion mc-competition-</xsl:text>
            <xsl:value-of select="IdCup"/>
            <xsl:text> filterable-competition</xsl:text>
            <xsl:if test="string-length(IdConfederation)&gt;0">
              <xsl:text> idconfed-</xsl:text>
              <xsl:value-of select="IdConfederation"/>
            </xsl:if>
            <xsl:if test ="string-length($enableAccordion) &gt; 0  and $enableAccordion = 'true-icon'">
              <xsl:text> accordion-onicon</xsl:text>
            </xsl:if>
          </xsl:attribute>
          <xsl:if test="string-length($inner.idcs)&gt;0">
            <xsl:attribute name="data-season">
              <xsl:value-of  select="$inner.idcs"/>
            </xsl:attribute>
          </xsl:if>
          <!--HEADER-->
          <div class="bH">
            <xsl:choose>
              <xsl:when test ="string-length(Url) &gt; 0">
                <a href="{Url}">
                  <xsl:apply-templates select="." mode="competition.header" />
                </a>
              </xsl:when>
              <xsl:otherwise>
                <xsl:apply-templates select="." mode="competition.header" />
              </xsl:otherwise>
            </xsl:choose>
            <xsl:if test ="string-length($enableAccordion) &gt; 0 and $enableAccordion = 'true-icon'">
              <div class="accordion-icon">
                <xsl:text> </xsl:text>
              </div>
            </xsl:if>
            <xsl:text> </xsl:text>
          </div>
          <div class="bC">
            <!--MATCHLIST-->
            <div>
              <xsl:if test="string-length($parameters.list[@name = 'containerClass']) > 0">
                <xsl:attribute name="class">
                  <xsl:value-of select="$parameters.list[@name = 'containerClass']"/>
                </xsl:attribute>
              </xsl:if>
              <xsl:if test="string-length(//DateFromStr)&gt;0">
                <xsl:attribute name="data-listdate">
                  <xsl:value-of  select="//DateFromStr"/>
                </xsl:attribute>
              </xsl:if>
              <xsl:apply-templates select="$parameters.list[@name = 'Title']" />
              <xsl:if test="$isCurrentCalendar = 'true'">
                <xsl:attribute name="class">
                  <xsl:text>listener</xsl:text>
                </xsl:attribute>
              </xsl:if>
              <xsl:if test="string-length($parameters.list[@name = 'dataSubType']) > 0">
                <xsl:attribute name="data-subType">
                  <xsl:value-of select="$parameters.list[@name = 'dataSubType']"/>
                </xsl:attribute>
              </xsl:if>
              <xsl:if test="count($matches)&gt;0">
                <xsl:for-each select ="$matches">
                  <xsl:variable name="grouptoshow">
                    <xsl:choose>
                      <xsl:when test="xslext:lowercase(GroupName)!='regular'">
                        <xsl:value-of select ="$showGroup"/>
                      </xsl:when>
                      <xsl:otherwise>
                        <xsl:text>false</xsl:text>
                      </xsl:otherwise>
                    </xsl:choose>
                  </xsl:variable>
                  <xsl:apply-templates select="." mode="match.row">
                    <xsl:with-param name="showCompetitionName" select ="$showCompName"/>
                    <!--<xsl:with-param name="showGroupName" select ="$grouptoshow"/>-->
                    <xsl:with-param name="showVenue" select="$showVenue"/>
                    <xsl:with-param name="showGroupName">
                      <xsl:choose>
                        <xsl:when test="number(Type)=105">
                          <xsl:value-of select="'false'"/>
                        </xsl:when>
                        <xsl:otherwise>
                          <xsl:value-of select ="$grouptoshow"/>
                        </xsl:otherwise>
                      </xsl:choose>
                    </xsl:with-param>
                    <xsl:with-param name="showDate" select ="$showDate"/>
                    <xsl:with-param name="enableRowLink">
                      <xsl:choose>
                        <xsl:when test="string-length(Url)&gt;0">
                          <xsl:value-of select ="'1'"/>
                        </xsl:when>
                        <xsl:otherwise>
                          <xsl:value-of select ="'0'"/>
                        </xsl:otherwise>
                      </xsl:choose>
                    </xsl:with-param>
                  </xsl:apply-templates>
                </xsl:for-each>
                <xsl:text> </xsl:text>
              </xsl:if>


              <xsl:if test="string-length($parameters.list[@name = 'MoreTag']) > 0 and  $parameters.list[@name = 'MoreTag'] != 'footerButton' and count(//Match)&gt;0">
                <xsl:variable name="mtag">
                  <xsl:value-of select="xslext:Replace(xslext:Translate($parameters.list[@name = 'MoreTag']),'\[CompetitionName\]',xslext:CupSeasonNameGet(IdCupSeason))"/>
                </xsl:variable>
                <div class="cf rr-qlCont">
                  <ul class="rr-ql moreLink">
                    <li class="first ">
                      <a>
                        <xsl:attribute name="href">
                          <xsl:choose>
                            <xsl:when test="string-length($parameters.list[@name = 'MoreUrl'])&gt;0">
                              <xsl:value-of select="$parameters.list[@name = 'MoreUrl']"/>
                            </xsl:when>
                            <xsl:otherwise>
                              <xsl:choose>
                                <xsl:when test="string-length(CompetitionUrl)&gt;0">
                                  <xsl:value-of select="CompetitionUrl"/>
                                </xsl:when>
                                <xsl:otherwise>
                                  <xsl:value-of select="$inner.competitionUrl"/>
                                </xsl:otherwise>
                              </xsl:choose>
                            </xsl:otherwise>
                          </xsl:choose>
                        </xsl:attribute>
                        <xsl:value-of select="$mtag"/>
                        <!--<xsl:value-of select="concat(xslext:Uppercase(substring($mtag, 1, 1)), substring(xslext:lowercase($mtag), 2))"/>-->
                        <xsl:text> </xsl:text>
                      </a>
                      <xsl:text> </xsl:text>
                    </li>
                    <xsl:text> </xsl:text>
                  </ul>
                  <xsl:text> </xsl:text>
                </div>
              </xsl:if>
              <xsl:text> </xsl:text>
            </div>
            <!--/MATCHLIST-->
            <xsl:text> </xsl:text>
          </div>
          <!--FOOTER-->
          <xsl:if test="count($matches)&gt;0">
            <div class="bF">
              <xsl:if test="$parameters.list[@name = 'MoreUrl']!='disabled' and $parameters.list[@name = 'MoreUrl']!=concat('disablekind-',./Type)">
                <xsl:choose>
                  <xsl:when test ="string-length($parameters.list[@name = 'MoreTag']) &gt; 0 and $parameters.list[@name = 'MoreTag'] = 'footerButton'">
                    <xsl:call-template name ="mlistFooterButton" />
                  </xsl:when>
                  <xsl:when test="string-length(CompetitionUrl)&gt;0 and string-length((./Name | ./CupSeasonName))&gt;0">
                    <xsl:call-template name ="moreDiv">
                      <xsl:with-param name ="url" select ="CompetitionUrl" />
                      <xsl:with-param name ="tag" select ="concat((./Name | ./CupSeasonName), ' &amp;raquo;')" />
                    </xsl:call-template>
                  </xsl:when>
                  <xsl:otherwise>
                    <xsl:if test ="string-length(./Url) &gt; 0" >
                      <xsl:call-template name ="moreDiv">
                        <xsl:with-param name ="url" select ="./Url" />
                        <xsl:with-param name ="tag" select ="concat((./Name | ./CupSeasonName), ' &amp;raquo;')" />
                      </xsl:call-template>
                    </xsl:if>
                  </xsl:otherwise>
                </xsl:choose>
              </xsl:if>
              <xsl:text> </xsl:text>
            </div>
          </xsl:if>
        </div>
      </xsl:if>
      <!--<xsl:if test="count(//Matches/Match[IdCupSeason=$idcs])&lt;=0">
        <div>
          <xsl:attribute name="class">
            <xsl:text>box accordion mc-competition-</xsl:text>
            <xsl:value-of select="IdCup"/>
            <xsl:text> filterable-competition</xsl:text>
            <xsl:if test="string-length(IdConfederation)&gt;0">
              <xsl:text> idconfed-</xsl:text>
              <xsl:value-of select="IdConfederation"/>
            </xsl:if>
            <xsl:if test ="string-length($enableAccordion) &gt; 0  and $enableAccordion = 'true-icon'">
              <xsl:text> accordion-onicon</xsl:text>
            </xsl:if>
          </xsl:attribute>
          -->
      <!--HEADER-->
      <!--
          <div class="bH">
            <xsl:choose>
              <xsl:when test ="string-length(Url) &gt; 0">
                <a href="{Url}">
                  <xsl:apply-templates select="." mode="competition.header" />
                </a>
              </xsl:when>
              <xsl:otherwise>
                <xsl:apply-templates select="." mode="competition.header" />
              </xsl:otherwise>
            </xsl:choose>
            <xsl:if test ="string-length($enableAccordion) &gt; 0 and $enableAccordion = 'true-icon'">
              <div class="accordion-icon">
                <xsl:text> </xsl:text>
              </div>
            </xsl:if>
            <xsl:text> </xsl:text>
          </div>
          <div class="bC">
            <div data-type="matches">
              <div class="m-head">
                <div class="m-date">
                  <xsl:value-of select="xslext:Translate('noFixturesAvailable')"/>
                  <xsl:text> </xsl:text>
                </div>
              </div>
              <xsl:text> </xsl:text>
            </div>
            <xsl:text> </xsl:text>
          </div>
        </div>
      </xsl:if>-->
      <!-- reset variables for matchlists-->
      <xsl:value-of select="xslext:SetVar('lastDt', '')"/>
      <xsl:value-of select="xslext:SetVar('csName', '')"/>
      <xsl:value-of select="xslext:SetVar('grpName', '')"/>
    </xsl:for-each>
    <span class="hidden">
      <xsl:value-of select="basicext:GetGoogleOffIndex()" disable-output-escaping="yes"/>
      <xsl:value-of select="concat('view xslt: ', /root/viewInfo/xslt)"/>
      <br/>
      <xsl:value-of select="concat('time_taken xslt: ', basicext:GetJsTimeNow() - $time_start)"/>
      <xsl:value-of select="basicext:GetGoogleOnIndex()" disable-output-escaping="yes"/>
    </span>
  </xsl:template>


  <xsl:template name ="mlistFooterButton">
    <div class="cf rr-qlCont m-listLink footerButton">
      <ul class="rr-ql moreLink">
        <li class="first fixture">
          <a href="{urlFixtures}">
            <xsl:value-of select ="xslext:Translate('fixtureAndResults')"/>
            <xsl:text> </xsl:text>
          </a>
        </li>
        <xsl:if test ="HasGroups = 'true'">
          <li class="standings">
            <a href="{urlStandings}">
              <xsl:value-of select ="xslext:Translate('standings')"/>
              <xsl:text> </xsl:text>
            </a>
          </li>
        </xsl:if>
      </ul>
    </div>
  </xsl:template>

  <xsl:template name ="moreDiv">
    <xsl:param name ="url" />
    <xsl:param name ="tag" />

    <div class="cf rr-qlCont m-listLink">
      <ul class="rr-ql moreLink">
        <li class="first ">
          <a>
            <xsl:attribute name="href">
              <xsl:value-of select ="$url"/>
            </xsl:attribute>
            <xsl:value-of select="$tag" disable-output-escaping ="yes"/>
            <xsl:text> </xsl:text>
          </a>
        </li>
      </ul>
    </div>

  </xsl:template>

</xsl:stylesheet>