<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:output method="xml" indent="yes" />

  <xsl:template match="/">
    <RPS>
      <ChaveRPS>
        <CPFCNPJPrestador>
          <CNPJ>
            <xsl:value-of select="//FIRST_PARTY_TAXPAYERID" />
          </CNPJ>
        </CPFCNPJPrestador>

        <InscricaoPrestador>
          <xsl:value-of select="//FIRST_PARTY_IM" />
        </InscricaoPrestador>

        <xsl:if test="//LEGAL_ENTITY_NAME">
          <RazaoSocialPrestador>
            <xsl:value-of select="//LEGAL_ENTITY_NAME" />
          </RazaoSocialPrestador>
        </xsl:if>

        <xsl:if test="//LEGAL_ENTITY_NAME">
          <NomeFantasiaPrestador>
            <xsl:value-of select="//LEGAL_ENTITY_NAME" />
          </NomeFantasiaPrestador>
        </xsl:if>

        <EnderecoPrestador>
          <xsl:value-of
            select="concat(//FIRST_PARTY_ADDRESS1, ' ', //FIRST_PARTY_ADDRESS2, ' ', //FIRST_PARTY_ADDRESS3, ' ', //FIRST_PARTY_ADDRESS4, ' - CEP: ', //FIRST_PARTY_ZIP_CODE)" />
        </EnderecoPrestador>

        <xsl:if test="//FIRST_PARTY_CITY">
          <CidadePrestador>
            <xsl:value-of select="//FIRST_PARTY_CITY" />
          </CidadePrestador>
        </xsl:if>

        <xsl:if test="//FIRST_PARTY_STATE">
          <UFPrestador>
            <xsl:value-of select="//FIRST_PARTY_STATE" />
          </UFPrestador>
        </xsl:if>

        <xsl:if test="//SERIES">
          <SerieRPS>
            <xsl:value-of select="//SERIES" />
          </SerieRPS>
        </xsl:if>
      </ChaveRPS>

      <DataEmissao>
        <xsl:value-of select="substring-before(//TRX_DATE, 'T')" />
      </DataEmissao>

      <NaturezaOperacao>
        <xsl:value-of
          select="substring-after(substring-after(substring-after(//OTHER_PRODUCT_CLASSIFICATIONS[last()]/CATEGORY_CODE, '|'), '|'), '|')" />
      </NaturezaOperacao>

      <OptanteSimplesNacional>2</OptanteSimplesNacional>

      <IncentivadorCultural>2</IncentivadorCultural>

      <StatusRPS>
        <xsl:choose>
          <xsl:when test="//REQUEST_TYPE = 'FISCAL_DOC_STATUS'">N</xsl:when>
          <xsl:when test="//REQUEST_TYPE = 'CANCELLATION'">C</xsl:when>
          <xsl:when test="//REQUEST_TYPE = 'VOID'">E</xsl:when>
        </xsl:choose>
      </StatusRPS>

      <TributacaoRPS>
        <xsl:value-of select="//SERVICE_SITUATION" />
      </TributacaoRPS>

      <ValorServicos>
        <xsl:value-of
          select="format-number(number(//FISCAL_DOC_LINES/TRX_LINE_QUANTITY) * number(//FISCAL_DOC_LINES/UNIT_PRICE), '0.00')" />
      </ValorServicos>

      <ValorDeducoes>0</ValorDeducoes>

      <ValorPIS>
        <xsl:choose>
          <xsl:when
            test="//FISCAL_DOC_HEADER//FISCAL_DOC_LINES//TAX_LINES[contains(TAX, 'PIS') and REGIME_TYPE_FLAG='W']">
            <xsl:value-of select="//TAX_RATE" />
          </xsl:when>
          <xsl:when
            test="//FISCAL_DOC_HEADER//FISCAL_DOC_LINES//TAX_LINES[contains(TAX, 'PIS') and REGIME_TYPE_FLAG='I' and TAX_REPORTING_CODES[REPORTING_TYPE_CODE='LACLS_BR_WHT_TYPE'and REP_CODE_TAX='WH']]">
            <xsl:value-of select="//TAX_RATE" />
          </xsl:when>
          <xsl:otherwise>
            <xsl:text>0.00</xsl:text>
          </xsl:otherwise>
        </xsl:choose>
      </ValorPIS>

      <ValorCOFINS>
        <xsl:choose>
          <xsl:when
            test="//FISCAL_DOC_HEADER//FISCAL_DOC_LINES//TAX_LINES[contains(TAX, 'COFINS') and REGIME_TYPE_FLAG='W']">
            <xsl:value-of select="//TAX_RATE" />
          </xsl:when>
          <xsl:when
            test="//FISCAL_DOC_HEADER//FISCAL_DOC_LINES//TAX_LINES[contains(TAX, 'COFINS') and REGIME_TYPE_FLAG='I' and TAX_REPORTING_CODES[REPORTING_TYPE_CODE='LACLS_BR_WHT_TYPE' and REP_CODE_TAX='WH']]">
            <xsl:value-of select="//TAX_RATE" />
          </xsl:when>
          <xsl:otherwise>
            <xsl:text>0.00</xsl:text>
          </xsl:otherwise>
        </xsl:choose>
      </ValorCOFINS>

      <CodigoServico>
        <xsl:value-of
          select="substring-before(substring-after(substring-after(//OTHER_PRODUCT_CLASSIFICATIONS[last()]/CATEGORY_CODE, '|'), '|'), '|')" />
      </CodigoServico>

      <xsl:if test="//FISCAL_DOC_LINES/PRODUCT_DESCRIPTION">
        <DescricaoCodServico>
          <xsl:value-of select="//FISCAL_DOC_LINES/PRODUCT_DESCRIPTION" />
        </DescricaoCodServico>
      </xsl:if>

      <CodigoCnae>
        <xsl:value-of
          select="substring-before(//OTHER_PRODUCT_CLASSIFICATIONS[last()]/CATEGORY_CODE, '|')" />
      </CodigoCnae>

      <AliquotaServicos>
        <xsl:choose>
          <xsl:when
            test="//FISCAL_DOC_HEADER//FISCAL_DOC_LINES//TAX_LINES[contains(TAX, 'ISS') and REGIME_TYPE_FLAG='W']">
            <xsl:value-of select="TAX_RATE" />
          </xsl:when>

          <xsl:when
            test="//FISCAL_DOC_HEADER//FISCAL_DOC_LINES//TAX_LINES[contains(TAX, 'ISS') and REGIME_TYPE_FLAG='I' and TAX_REPORTING_CODES[REPORTING_TYPE_CODE='LACLS_BR_WHT_TYPE' and REP_CODE_TAX='WH']]">
            <xsl:value-of select="TAX_RATE" />
          </xsl:when>

          <xsl:when
            test="//FISCAL_DOC_HEADER//FISCAL_DOC_LINES//TAX_LINES[contains(TAX, 'ISS') and REGIME_TYPE_FLAG='I' and TAX_REPORTING_CODES[REPORTING_TYPE_CODE != 'LACLS_BR_WHT_TYPE' and REP_CODE_TAX != 'WH']]">
            <xsl:value-of select="TAX_RATE" />
          </xsl:when>
          <xsl:otherwise>
            <xsl:text>0.00</xsl:text>
          </xsl:otherwise>
        </xsl:choose>
      </AliquotaServicos>
    </RPS>
  </xsl:template>

</xsl:stylesheet>