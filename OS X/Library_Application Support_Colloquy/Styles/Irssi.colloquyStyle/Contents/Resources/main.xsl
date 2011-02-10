<?xml version='1.0' encoding='iso-8859-1'?>
<xsl:stylesheet version='1.0' 
	xmlns:xsl='http://www.w3.org/1999/XSL/Transform'
	xmlns:exsl="http://exslt.org/common"
	xmlns:str="http://exslt.org/strings"
        extension-element-prefixes="exsl str">

	<xsl:output omit-xml-declaration="yes" indent="no" />
        <xsl:param name="consecutiveMessage" />

	<!-- Copyright (c) 2006 Koen Vervloesem -->
        <xsl:template match="/">
                <xsl:choose>
                        <xsl:when test="$consecutiveMessage = 'yes'">
                                <xsl:apply-templates select="/envelope/message[last()]" />
                        </xsl:when>
                        <xsl:otherwise>
                                <xsl:apply-templates />
                        </xsl:otherwise>
                </xsl:choose>
        </xsl:template>

	<xsl:template match="envelope">
		<xsl:apply-templates select="message"/>
	</xsl:template>

	<xsl:template match="message">

		<xsl:variable name="envelopeClasses">
			<xsl:text>envelope</xsl:text>
			<xsl:if test="@highlight = 'yes'">
				<xsl:text> highlight</xsl:text>
			</xsl:if>
			<xsl:if test="@action = 'yes'">
				<xsl:text> action</xsl:text>
			</xsl:if>
			<xsl:if test="@type = 'notice'">
				<xsl:text> notice</xsl:text>
			</xsl:if>
			<xsl:if test="../@ignored = 'yes'">
				<xsl:text> ignore</xsl:text>
			</xsl:if>
		</xsl:variable>

		<xsl:variable name="sender" select="../sender" />

                <xsl:variable name="senderClasses">
			<xsl:text>member</xsl:text>
			<xsl:if test="$sender/@self = 'yes'">
                        	<xsl:text> self</xsl:text>
                        </xsl:if>
			<xsl:if test="$sender/@class">
				<xsl:value-of select="concat(' ', $sender/@class)"/>
			</xsl:if>
                </xsl:variable>

		<xsl:variable name="hostmask" select="$sender/@hostmask" />

		<xsl:variable name="tooltip" select="concat($sender, '&#xA;', $hostmask)"/>

		<xsl:variable name="properIdentifier">
			<xsl:choose>
				<xsl:when test="@id">
					<xsl:value-of select="@id" />
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="../@id" />
					<xsl:text>.</xsl:text>
					<xsl:value-of select="position()" />
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

		<!-- See RFC2812 for all legal characters in an IRC nick -->
		<xsl:variable name="senderHash" select="number(translate($sender,
		'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890[]\`_^{|}-',
		'123456789012345678901234567890123456789012345678901234567890123456789012'))" />

		<xsl:variable name="senderColor">
			<xsl:choose>
				<xsl:when test="$sender/@self = 'yes'">colorself</xsl:when>
				<xsl:when test="string-length($sender/text()) &gt; 0">
					<xsl:value-of select="concat('color', $senderHash mod 36)" />
				</xsl:when>
			</xsl:choose>
		</xsl:variable>

		<div id="{$properIdentifier}" class="{$envelopeClasses}">
			<div class="timestamp">
				<xsl:call-template name="time">
					<xsl:with-param name="date" select="@received" />
				</xsl:call-template>
			</div>
			<a href="member:{$sender}" class="{$senderClasses} {$senderColor}" title="{$tooltip}"><xsl:value-of select="$sender" /></a>
			<span class="message">
				<xsl:apply-templates select="child::node()" mode="copy" />
			</span>
		</div>

	</xsl:template>

	<xsl:template match="event">

		<xsl:variable name="netsplit">
			<xsl:if test="reason != ''">
				<xsl:variable name="servers" select="str:tokenize(reason, ' ')"/>
				<xsl:if test="count($servers) = 2">
					<xsl:variable name="domains1" select="str:tokenize($servers[1], '.')"/>
					<xsl:variable name="domains2" select="str:tokenize($servers[2], '.')"/>
					<xsl:if test="count($domains1) &gt; 1 and count($domains2) &gt; 1">
						<xsl:text>yes</xsl:text>
					</xsl:if>
				</xsl:if>
			</xsl:if>
		</xsl:variable>

		<xsl:variable name="eventClasses">
			<xsl:text>event </xsl:text>
			<xsl:value-of select="@name"/>
			<xsl:if test="$netsplit = 'yes' or contains(reason/text(), 'error') or contains(reason/text(), 'timeout') or contains(reason/text(), 'closed') or contains(reason/text(), 'Lost terminal') or contains(reason/text(), 'collision') or contains(reason/text(), 'timed out') or contains(reason/text(), 'reset') or contains(reason/text(), 'K-lined')">
				<xsl:text> conerror</xsl:text>
			</xsl:if>
		</xsl:variable>

		<div class="{$eventClasses}">
			<div class="timestamp">
				<xsl:call-template name="time">
					<xsl:with-param name="date" select="@occurred" />
				</xsl:call-template>
			</div>
			<span class="message">
				<xsl:apply-templates select="message/child::node()" mode="copy" />
				<xsl:if test="reason != ''">
					<span class="reason">
						<xsl:choose>
							<xsl:when test="$netsplit = 'yes'">
								<xsl:text>Netsplit between </xsl:text>
								<xsl:value-of select="concat(substring-before(reason, ' '), ' and ', substring-after(reason, ' '))"/>
							</xsl:when>
							<xsl:otherwise>
								<xsl:apply-templates select="reason/child::node()" mode="copy"/>
							</xsl:otherwise>
						</xsl:choose>
					</span>
				</xsl:if>
			</span>
		</div>
	</xsl:template>

	<xsl:template match="span[@class='member']" mode="copy">
                <xsl:variable name="memberClasses">
			<xsl:text>member</xsl:text>
			<xsl:choose>
				<xsl:when test="../../who/text() = current() and ../../who/@class">
					<xsl:value-of select="concat(' ', ../../who/@class)"/>
				</xsl:when>
				<xsl:when test="../../by/text() = current() and ../../by/@class">
					<xsl:value-of select="concat(' ', ../../by/@class)"/>
				</xsl:when>
			</xsl:choose>
                </xsl:variable>
		<a href="member:{current()}" class="{$memberClasses}"><xsl:value-of select="current()" /></a>
		<xsl:if test="(../../@name='memberJoined' or ../../@name='memberParted') and ../../who/@hostmask">
			<span class="hostmask">
				<xsl:value-of select="../../who/@hostmask" />
			</span>
		</xsl:if>
	</xsl:template>
	
	<xsl:template match="span[starts-with(@class, 'emoticon')]" mode="copy">
		<xsl:element name="span">
			<xsl:attribute name="class">
				<xsl:value-of select="@class"/>
			</xsl:attribute>
			<xsl:attribute name="title">
				<xsl:value-of select="substring-after(@class, 'emoticon ')"/>
			</xsl:attribute>
			<xsl:apply-templates select="child::node()" mode="copy" />
		</xsl:element>
	</xsl:template>

	<!--<xsl:template match="message//text()" mode="copy">-->
		<!--<xsl:variable name="output">-->
			<!--<xsl:call-template name="embedWordsInElement">
				<xsl:with-param name="string" select="."/>
				<xsl:with-param name="target" select="'*'"/>
				<xsl:with-param name="replacement" select="'strong'"/>
				<xsl:with-param name="after" select="''"/>
			</xsl:call-template>-->
		<!--</xsl:variable>
		<xsl:copy><xsl:apply-templates select="exsl:node-set($output)" mode="copy2" /></xsl:copy>-->
	<!--</xsl:template>

	<xsl:template match="message//text()" mode="copy2">
		<xsl:call-template name="embedWordsInElement">
			<xsl:with-param name="string" select="."/>
			<xsl:with-param name="target" select="'_'"/>
			<xsl:with-param name="replacement" select="'em'"/>
			<xsl:with-param name="after" select="''"/>
		</xsl:call-template>
	</xsl:template>-->

	<xsl:template match="@*|*" mode="copy">
		<xsl:copy><xsl:apply-templates select="@*|node()" mode="copy" /></xsl:copy>
	</xsl:template>

	<!--<xsl:template match="@*|*" mode="copy2">
		<xsl:copy><xsl:apply-templates select="@*|node()" mode="copy2" /></xsl:copy>
	</xsl:template>-->

	<xsl:template name="time">
        	<xsl:param name="date" /> <!-- YYYY-MM-DD HH:MM:SS +/-HHMM -->

		<xsl:variable name="hour" select="substring($date, 12, 2)"/>
		<xsl:variable name="minutes" select="substring($date, 15, 2)"/>
		<xsl:variable name="seconds" select="substring($date, 18, 2)"/>
		<xsl:variable name="hour12">
			<xsl:choose>
				<xsl:when test="$hour &gt; 12">
					<xsl:value-of select="format-number($hour - 12, '00')" />
				</xsl:when>
				<xsl:when test="$hour = 0">
					<xsl:text>12</xsl:text>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="$hour" />
				</xsl:otherwise>
			</xsl:choose>		
		</xsl:variable>
		<xsl:variable name="pm">
			<xsl:choose>
				<xsl:when test="$hour &gt; $hour12">
					<xsl:text> pm</xsl:text>
				</xsl:when>
				<xsl:otherwise>
					<xsl:text> am</xsl:text>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>		

		<span class="hour12">
			<xsl:value-of select="$hour12"/>
		</span>
		<span class="hour">
			<xsl:value-of select="$hour"/>
		</span>
		<xsl:text>:</xsl:text>
		<xsl:value-of select="$minutes"/>
		<span class="seconds">
			<xsl:text>:</xsl:text>
			<xsl:value-of select="$seconds"/>
		</span>
		<span class="pm">
			<xsl:value-of select="$pm"/>
		</span>
	</xsl:template>

	<!--<xsl:template name="embedWordsInElement">
  		<xsl:param name="string"/>
 		<xsl:param name="target"/>
		<xsl:param name="replacement"/>
		<xsl:param name="after"/>

		<xsl:variable name="begintarget" select="concat(' ', $target)"/>
		<xsl:variable name="endtarget" select="concat($target, ' ')"/>
		
		<xsl:if test="$string != ''">
		<xsl:choose>
			<xsl:when test="$after=''">
				<xsl:choose>
 					<xsl:when test="starts-with($string, $target)">
						<xsl:call-template name="embedWordsInElement">
						        <xsl:with-param name="string" 
						             select="substring($string, 2)"/>
					       		<xsl:with-param name="target" select="$target"/>
						       	<xsl:with-param name="replacement" 
				             			select="$replacement"/>
							<xsl:with-param name="after" select="$target"/>
						</xsl:call-template>
					</xsl:when>
		    			<xsl:when test="contains($string, $begintarget)">
   						<xsl:value-of select="substring-before($string, $begintarget)"/>
						<xsl:call-template name="embedWordsInElement">
						        <xsl:with-param name="string" 
						             select="substring-after($string, $begintarget)"/>
					        	<xsl:with-param name="target" select="$target"/>
					        	<xsl:with-param name="replacement" 
			             				select="$replacement"/>
							<xsl:with-param name="after" select="$begintarget"/>
						</xsl:call-template>
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="$string"/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:when>
			<xsl:when test="$after=$target">
 				<xsl:choose>
		    			<xsl:when test="contains($string, $endtarget) and not(contains(substring-before($string, $endtarget), ' ') and not(contains(substring-before($string, $endtarget), $target))">
						<xsl:element name="{$replacement}">
							<xsl:value-of select="$target"/>
	   						<xsl:value-of select="substring-before($string, $endtarget)"/>
							<xsl:value-of select="$target"/>
						</xsl:element>
						<xsl:text> </xsl:text>
						<xsl:call-template name="embedWordsInElement">
						        <xsl:with-param name="string" 
						             select="substring-after($string, $endtarget)"/>
					        	<xsl:with-param name="target" select="$target"/>
					        	<xsl:with-param name="replacement" 
			             				select="$replacement"/>
							<xsl:with-param name="after" select="$endtarget"/>
						</xsl:call-template>
					</xsl:when>
		    			<xsl:when test="contains($string, $begintarget)">
   						<xsl:value-of select="concat($target, substring-before($string, $begintarget))"/>
						<xsl:call-template name="embedWordsInElement">
						        <xsl:with-param name="string" 
						             select="substring-after($string, $begintarget)"/>
					        	<xsl:with-param name="target" select="$target"/>
					        	<xsl:with-param name="replacement" 
			             				select="$replacement"/>
							<xsl:with-param name="after" select="$begintarget"/>
						</xsl:call-template>
					</xsl:when>
		    			<xsl:when test="substring($string, string-length($string)) = $target and not(contains(substring-before($string, $target), ' '))">
						<xsl:element name="{$replacement}">
							<xsl:value-of select="$target"/>
							<xsl:value-of select="$string"/>
						</xsl:element>
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="$target"/>
						<xsl:value-of select="$string"/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:when>
			<xsl:when test="$after=$begintarget">
 				<xsl:choose>
		    			<xsl:when test="contains($string, $endtarget) and not(contains(substring-before($string, $endtarget), ' '))">
						<xsl:text> </xsl:text>
						<xsl:element name="{$replacement}">
							<xsl:value-of select="$target"/>
	   						<xsl:value-of select="substring-before($string, $endtarget)"/>
							<xsl:value-of select="$target"/>
						</xsl:element>
						<xsl:text> </xsl:text>
						<xsl:call-template name="embedWordsInElement">
						        <xsl:with-param name="string" 
						             select="substring-after($string, $endtarget)"/>
					        	<xsl:with-param name="target" select="$target"/>
					        	<xsl:with-param name="replacement" 
			             				select="$replacement"/>
							<xsl:with-param name="after" select="$endtarget"/>
						</xsl:call-template>
					</xsl:when>
		    			<xsl:when test="contains($string, $begintarget)">
   						<xsl:value-of select="concat($begintarget, substring-before($string, $begintarget))"/>
						<xsl:call-template name="embedWordsInElement">
						        <xsl:with-param name="string" 
						             select="substring-after($string, $begintarget)"/>
					        	<xsl:with-param name="target" select="$target"/>
					        	<xsl:with-param name="replacement" 
			             				select="$replacement"/>
							<xsl:with-param name="after" select="$begintarget"/>
						</xsl:call-template>
					</xsl:when>
		    			<xsl:when test="substring($string, string-length($string)) = $target and not(contains(substring-before($string, $target), ' '))">
						<xsl:text> </xsl:text>
						<xsl:element name="{$replacement}">
							<xsl:value-of select="$target"/>
							<xsl:value-of select="$string"/>
						</xsl:element>
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="$begintarget"/>
						<xsl:value-of select="$string"/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:when>
			<xsl:when test="$after=$endtarget">
				<xsl:choose>
 					<xsl:when test="starts-with($string, $target)">
						<xsl:call-template name="embedWordsInElement">
						        <xsl:with-param name="string" 
						             select="substring($string, 2)"/>
					       		<xsl:with-param name="target" select="$target"/>
						       	<xsl:with-param name="replacement" 
				             			select="$replacement"/>
							<xsl:with-param name="after" select="$target"/>
						</xsl:call-template>
					</xsl:when>
		    			<xsl:when test="contains($string, $begintarget)">
   						<xsl:value-of select="substring-before($string, $begintarget)"/>
						<xsl:call-template name="embedWordsInElement">
						        <xsl:with-param name="string" 
						             select="substring-after($string, $begintarget)"/>
					        	<xsl:with-param name="target" select="$target"/>
					        	<xsl:with-param name="replacement" 
			             				select="$replacement"/>
							<xsl:with-param name="after" select="$begintarget"/>
						</xsl:call-template>
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="$string"/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:when>
		</xsl:choose>
		</xsl:if>
	</xsl:template>-->

</xsl:stylesheet>
