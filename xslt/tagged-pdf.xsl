<xsl:stylesheet version="1.0"
xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <!-- A rough and ready XSL transform from Tagged PDF XML serialization to HTML -->
  <xsl:template match="/Document|/DocumentFragment">
    <html>
      <body>
        <xsl:apply-templates/>
      </body>
    </html>
  </xsl:template>
  <xsl:template match="Link[@href]">
    <!-- /Link href="xxx" -> a href="xxx" -->
    <a>
      <xsl:apply-templates select="@*|node()"/>
    </a>
  </xsl:template>
  <xsl:template match="L/LI/Lbl">
    <!-- Discard superflous Lbl tags in list items -->
  </xsl:template>
  <xsl:template match="L">
    <ul>
      <xsl:apply-templates/>
    </ul>
  </xsl:template>
  <xsl:template match="FENote|Note">
    <!-- /FENote /Note -> /fn -->
    <fn>
      <xsl:apply-templates/>
    </fn>
  </xsl:template>
  <xsl:template match="Span[@TextDecorationType='Underline']">
    <!-- underline -->
    <u>
       <xsl:apply-templates/>
    </u>
  </xsl:template>
  <xsl:template match="TOCI|DocumentFragment|Formula|Form">
    <div>
      <xsl:apply-templates/>
    </div>
  </xsl:template>
  <xsl:template match="Artifact|Reference|RB|RT|Warichu|RP|RT|TagSuspect|ReversedChars|Clip|BibEntry|Annot|Link|LBody">
    <!-- currently omitted tags -->
    <xsl:apply-templates/>
  </xsl:template>
  <xsl:template match="Mark">
    <!-- marked content region -->
    <xsl:value-of select=".//text()"/>
  </xsl:template>
  <xsl:template match="@*|node()">
    <!-- Identity transform -->
    <xsl:copy>
      <xsl:apply-templates/>
    </xsl:copy>
  </xsl:template>
</xsl:stylesheet>
