<?xml version="1.0" encoding="UTF-8" ?>
<xsl:stylesheet version="1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:fifacom="urn:fifa.com"
  xmlns:xslext="urn:xslext.fifa.com"
  exclude-result-prefixes="xsl fifacom xslext">

  <xsl:output method="xml"
  version="1.0"
  encoding="UTF-8"
  indent="no"
  omit-xml-declaration="yes"/>

  <xsl:include href="../../../commonBlocks/xslt.include/slotIncluder.xslt"/>

  <xsl:variable name="isStatic.inner" select="//isStatic"/>
  <!--entity splitted in smaller parts to handle every customization needed-->
  <xsl:template match="Result" mode="score.result">
    <xsl:param name="enableResultLink" select="'1'"/>
    <div class="s-res">
      <xsl:if test="$enableResultLink = '1'">
        <xsl:text disable-output-escaping="yes"><![CDATA[<a href="]]></xsl:text>
        <xsl:value-of select="../url"/>
        <xsl:text disable-output-escaping="yes"><![CDATA[">]]></xsl:text>
      </xsl:if>
      <!--<span class="s-resText">0:0</span>-->
      <span class="s-resText">
        <!-- on static mobile we include the minutefile to show the match minute-->
        <xsl:choose>
          <xsl:when test="number(../Status)=1">
            <xsl:choose>
              <xsl:when test ="string-length(../MatchDate) &gt; 0 and xslext:FormatDate(../MatchDateUTC, 'yyyy-MM-ddTHH:mm:ss') != '0001-01-01T00:00:00'">
                <xsl:attribute name="class">
                  <xsl:text>s-resText wmcStatTime</xsl:text>
                </xsl:attribute>
                <xsl:attribute name="data">
                  <xsl:value-of select="xslext:FormatDate(../MatchDate, 'yyyy-MM-ddTHH:mm:ss')"/>
                  <xsl:text>;</xsl:text>
                  <xsl:value-of select="xslext:FormatDate(../MatchDateUTC, 'yyyy-MM-ddTHH:mm:ss')"/>
                </xsl:attribute>
                <xsl:value-of select="xslext:FormatDate(../MatchDate, 'HH:mm')"/>
              </xsl:when>
              <xsl:otherwise>
                <xsl:text disable-output-escaping ="yes">-:-</xsl:text>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:when>
          <xsl:otherwise>
            <xsl:variable name ="res">
              <xsl:value-of select="."/>
            </xsl:variable>

            <xsl:choose>
              <xsl:when test="xslext:GetCurrentLanguage() = 'A'">
                <xsl:variable name="resAr">
                  <xsl:value-of select="xslext:Replace($res, '-', ':')"/>
                </xsl:variable>
                <xsl:value-of select="xslext:Replace(xslext:ReverseMatchResult($resAr, true), ':', '-')"/>
              </xsl:when>
              <xsl:otherwise>
                <xsl:value-of select ="$res"/>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:otherwise>
        </xsl:choose>
        <xsl:text> </xsl:text>
      </span>
      <xsl:if test="$enableResultLink = '1'">
        <xsl:text disable-output-escaping="yes"><![CDATA[</a>]]></xsl:text>
      </xsl:if>
    </div>
  </xsl:template>

  <xsl:template match="Result" mode="score.status">
    <xsl:param name="useMinuteFile" />
    <xsl:param name="minuteFilePath" />
    <xsl:param name="isStatic" />
    <!--
    "s-min" could be an additional class to s-stat (if design needs to show additional info/different styles
    -->
    <div class="s-stat">
      <span class="s-statText">

        <xsl:choose>
          <xsl:when test ="../Status = '27'">
            <xsl:value-of select="xslext:Translate('forfeited')"/>
            <xsl:text> </xsl:text>
          </xsl:when>
          <xsl:when test ="../Status = '26'">
            <xsl:value-of select ="xslext:Translate('abandonedStatus')"/>
            <xsl:text> </xsl:text>
          </xsl:when>
          <xsl:when test ="../Status = '7'">
            <xsl:value-of select ="xslext:Translate('postponedStatus')"/>
            <xsl:text> </xsl:text>
          </xsl:when>
          <xsl:when test ="../Status = '8'">
            <xsl:value-of select ="xslext:Translate('matchStatus8')"/>
            <xsl:text> </xsl:text>
          </xsl:when>
          <xsl:when test ="number(../Status) = 0 and (../StatusRW != '')">
            <xsl:variable name ="vocTag">
              <xsl:value-of select="xslext:getMatchWinReason(../StatusRW)"/>
            </xsl:variable>
            <xsl:value-of select="xslext:TranslateAbbreviation($vocTag)"/>
          </xsl:when>
          <xsl:when test="((number(../Status) != 3) or ((../Report = '') or (../Report = 'N') or (../Report = '2') or (../Report = '3') or (../Report = '5') or (../Report = '7') or (../Report = '9') or (../Report = 'A') or (../Report = 'B') or (../Report = 'F'))) and (number(../Status) != 1)">
            <xsl:choose>
              <xsl:when test="(../Report = '2') or (../Report = '3')">
                <xsl:value-of select="xslext:TranslateAbbreviation('half-time')"/>
                <xsl:text> </xsl:text>
                <!--<xsl:text>half-time</xsl:text>-->
              </xsl:when>
              <xsl:when test="../Report = '5'">
                <xsl:value-of select="xslext:TranslateAbbreviation('end 2nd half')"/>
                <xsl:text> </xsl:text>
                <!--<xsl:text>end2ndhalfShort</xsl:text>-->
              </xsl:when>
              <xsl:when test="../Report = '7'">
                <xsl:value-of select="xslext:TranslateAbbreviation('end first extraShort')"/>
                <xsl:text> </xsl:text>
                <!--<xsl:text>End First Extra</xsl:text>-->
              </xsl:when>
              <xsl:when test="../Report = '9'">
                <xsl:value-of select="xslext:TranslateAbbreviation('endsecondextra')"/>
                <xsl:text> </xsl:text>
                <!--<xsl:text>End Second Extra</xsl:text>-->
              </xsl:when>
              <xsl:when test="../Report = 'A'">
                <xsl:value-of select="xslext:TranslateAbbreviation('penaltiesShort')"/>
                <xsl:text> </xsl:text>
                <!--<xsl:text>penalties</xsl:text>-->
              </xsl:when>
              <xsl:when test="../Report = 'B'">
                <xsl:value-of select="xslext:TranslateAbbreviation('end penalties')"/>
                <xsl:text> </xsl:text>
                <!--<xsl:text>endpenaltyphase</xsl:text>-->
              </xsl:when>
              <!--<xsl:when test="../Report = 'F'">
                <xsl:value-of select="xslext:TranslateAbbreviation('full-time')"/>
                <xsl:text> </xsl:text>
                -->
              <!--<xsl:text>full-time</xsl:text>-->
              <!--
              </xsl:when>-->
              <!--<xsl:when test="((../Report = '') or (../Report = 'N') or (../Report = '0')) and ((../Lineup = 'Y') or (../Lineup = 'T'))">
                <xsl:value-of select="xslext:TranslateAbbreviation('lineups')"/>
                <xsl:text> </xsl:text>
                -->
              <!--<xsl:text>lineup</xsl:text>-->
              <!--
              </xsl:when>-->
              <xsl:when test="((../Report = '') or (../Report = 'N')) and (../Lineup = 'N')">
                <xsl:text>-</xsl:text>
              </xsl:when>
              <!--<xsl:when test="(number(../Status) != 3)"> 
                <xsl:value-of select="../Status"/>
                <xsl:text></xsl:text>
              </xsl:when>-->
            </xsl:choose>
          </xsl:when>
          <xsl:when test ="../Status = '1' and ((../Lineup = 'Y') or (../Lineup = 'T'))">
            <xsl:value-of select="xslext:TranslateAbbreviation('lineups')"/>
            <xsl:text> </xsl:text>
          </xsl:when>
          <xsl:when test="../Status = '1' and ((../Lineup != 'Y') and (../Lineup != 'T'))">
            <xsl:text> </xsl:text>
          </xsl:when>
          <xsl:when test="../Status = '3'">
            <xsl:text> </xsl:text>
          </xsl:when>
          <!--<xsl:when test="../Status = '1' and ((../Lineup != 'Y') or (../Lineup != 'T'))">
            <xsl:attribute name="class">
              <xsl:text>s-statText wmcStatTime</xsl:text>
            </xsl:attribute>
            <xsl:attribute name="data">
              <xsl:value-of select="xslext:FormatDate(../MatchDate, 'yyyy-MM-ddTHH:mm:ss')"/>
              <xsl:text>;</xsl:text>
              <xsl:value-of select="xslext:FormatDate(../MatchDateUTC, 'yyyy-MM-ddTHH:mm:ss')"/>
            </xsl:attribute>
            <xsl:if test="xslext:FormatDate(../MatchDateUTC, 'yyyy-MM-ddTHH:mm:ss') != '0001-01-01T00:00:00'">
              <xsl:value-of select="xslext:FormatDate(../MatchDate, 'HH:mm')"/>
            </xsl:if>
          </xsl:when>-->
          <xsl:otherwise>
            <xsl:choose>
              <xsl:when test="(string($useMinuteFile) = 'true') and (string-length($minuteFilePath) > 0) and $isStatic='true'">
                <xsl:text disable-output-escaping="yes">&lt;!--#config ERRMSG=" "--&gt;</xsl:text>
                <xsl:value-of select="xslext:GenerateIncludeDirectiveSSINC($minuteFilePath)" disable-output-escaping ="yes"/>
                <xsl:text disable-output-escaping="yes">&lt;!--#config ERRMSG="&lt;span style='display:none'&gt;SSI Err&lt;/span&gt;"--&gt;</xsl:text>
                <xsl:text> </xsl:text>
              </xsl:when>
              <xsl:otherwise>
                <xsl:value-of select="../Minute"/>
                <xsl:text>'</xsl:text>
              </xsl:otherwise>
            </xsl:choose>

          </xsl:otherwise>
        </xsl:choose>

        <xsl:text> </xsl:text>

      </span>
    </div>
  </xsl:template>

  <xsl:template match="Result" mode="score.resultAndStatus">
    <xsl:param name="enableResultLink" select="'0'"/>
    <xsl:param name="minuteFilePath" />
    <xsl:param name="isStatic" />
    <xsl:param name="useMinuteFile" />



    <!--
    "s" could have 3 different additional classes:
    - is-live
    - is-upcoming
    - is-completed
    -->
    <div class="s">
      <xsl:apply-templates select="." mode="score.result">
        <xsl:with-param name="enableResultLink" select="$enableResultLink"/>
      </xsl:apply-templates>
      <xsl:if test="string-length(../IdMatchRelated)&gt;0 and number(../IdMatchRelated)&gt;0 and (string(../HasAggregate) = 'true')">
        <xsl:apply-templates select="." mode="score.aggregate"/>
      </xsl:if>
      <xsl:apply-templates select="." mode="score.status">
        <xsl:with-param name="useMinuteFile" select="$useMinuteFile" />
        <xsl:with-param name="minuteFilePath" select="$minuteFilePath" />
        <xsl:with-param name="isStatic" select="$isStatic.inner" />
      </xsl:apply-templates>
    </div>

  </xsl:template>

  <xsl:template match="Result" mode="score.aggregate">
    <xsl:if test="../Status = '0'">
      <div class="m-agg">
        <span class="aggText">
          <xsl:value-of select="xslext:Translate('aggregate')"/>
          <xsl:text> </xsl:text>
        </span>
        <span class="aggRes">
          <xsl:choose>
            <xsl:when test="xslext:GetCurrentLanguage() = 'A'">
              <xsl:value-of select="../ScoreAggrAwayTeam"/>
              <xsl:text>:</xsl:text>
              <xsl:value-of select="../ScoreAggrHomeTeam"/>
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of select="../ScoreAggrHomeTeam"/>
              <xsl:text>:</xsl:text>
              <xsl:value-of select="../ScoreAggrAwayTeam"/>
            </xsl:otherwise>
          </xsl:choose>
        </span>
        <xsl:text> </xsl:text>
      </div>
    </xsl:if>
  </xsl:template>





</xsl:stylesheet>