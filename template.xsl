<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:output method="xml" indent="yes"/>

  <xsl:template match="/">
    <RPS>
      <ChaveRPS>
        <CPFCNPJPrestador>
          <CNPJ>
            <xsl:value-of select="//FIRST_PARTY_TAXPAYERID"/>
          </CNPJ>

          <InscricaoPrestador>
            <xsl:value-of select="//FIRST_PARTY_IM"/>
          </InscricaoPrestador>

          <xsl:if test="//LEGAL_ENTITY_NAME">
            <RazaoSocialPrestador>
              <xsl:value-of select="//LEGAL_ENTITY_NAME"/>
            </RazaoSocialPrestador>
          </xsl:if>

          <xsl:if test="//LEGAL_ENTITY_NAME">
            <NomeFantasiaPrestador>
              <xsl:value-of select="//LEGAL_ENTITY_NAME"/>
            </NomeFantasiaPrestador>
          </xsl:if>

          <FullAddress>
            <xsl:value-of select="concat(//FIRST_PARTY_ADDRESS1, ' ', //FIRST_PARTY_ADDRESS2, ' ', //FIRST_PARTY_ADDRESS3, ' ', //FIRST_PARTY_ADDRESS4, ' - CEP: ', //FIRST_PARTY_ZIP_CODE)"/>
          </FullAddress>

          <xsl:if test="//FIRST_PARTY_CITY">
            <CidadePrestador>
              <xsl:value-of select="//FIRST_PARTY_CITY"/>
            </CidadePrestador>
          </xsl:if>

          <xsl:if test="//FIRST_PARTY_STATE">
            <UFPrestador>
              <xsl:value-of select="//FIRST_PARTY_STATE"/>
            </UFPrestador>
          </xsl:if>

          <xsl:if test="//SERIES">
            <SerieRPS>
              <xsl:value-of select="//SERIES"/>
            </SerieRPS>
          </xsl:if>

        </CPFCNPJPrestador>
      </ChaveRPS>
    </RPS>
  </xsl:template>
</xsl:stylesheet>
