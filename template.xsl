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

      <xsl:for-each
        select="//FISCAL_DOC_HEADER//FISCAL_DOC_LINES//TAX_LINES[contains(TAX, 'ISS')]">
        <xsl:choose>
          <xsl:when test="REGIME_TYPE_FLAG='W'">
            <AliquotaServicos>
              <xsl:value-of select="format-number(number(TAX_RATE), '0.00')" />
            </AliquotaServicos>
            <ISSRetido>
              <xsl:text>true</xsl:text>
            </ISSRetido>
            <ValorIss>
              <xsl:text>0.00</xsl:text>
            </ValorIss>
          </xsl:when>

          <xsl:when
            test="REGIME_TYPE_FLAG='I' and TAX_REPORTING_CODES/REPORTING_TYPE_CODE='LACLS_BR_WHT_TYPE' and TAX_REPORTING_CODES/REP_CODE_TAX='WH'">
            <AliquotaServicos>
              <xsl:value-of select="format-number(number(TAX_RATE), '0.00')" />
            </AliquotaServicos>
            <ISSRetido>
              <xsl:text>true</xsl:text>
            </ISSRetido>
            <ValorIss>
              <xsl:text>0.00</xsl:text>
            </ValorIss>
          </xsl:when>

          <xsl:when
            test="REGIME_TYPE_FLAG='I' and (not(TAX_REPORTING_CODES/REPORTING_TYPE_CODE='LACLS_BR_WHT_TYPE') or not(TAX_REPORTING_CODES/REP_CODE_TAX='WH'))">
            <AliquotaServicos>
              <xsl:value-of select="format-number(number(TAX_RATE), '0.00')" />
            </AliquotaServicos>
            <ISSRetido>
              <xsl:text>false</xsl:text>
            </ISSRetido>
            <ValorIss>
              <xsl:value-of select="format-number(number(TAX_AMT), '0.00')" />
            </ValorIss>
          </xsl:when>

          <xsl:otherwise>
            <AliquotaServicos>
              <xsl:text>0.00</xsl:text>
            </AliquotaServicos>
            <ISSRetido>
              <xsl:text>false</xsl:text>
            </ISSRetido>
            <ValorIss>
              <xsl:text>0.00</xsl:text>
            </ValorIss>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:for-each>

      <xsl:if test="//FISCAL_DOC_LINES/LINE_AMT">
        <BaseCalculo>
          <xsl:value-of select="format-number(number(//FISCAL_DOC_LINES/LINE_AMT), '0.00')" />
        </BaseCalculo>
      </xsl:if>

      <ItemListaServico>
        <xsl:value-of
          select="substring-before(substring-after(//OTHER_PRODUCT_CLASSIFICATIONS[last()]/CATEGORY_CODE, '|'), '|')" />
      </ItemListaServico>

      <CodigoTributacaoMunicipio>
        <xsl:value-of
          select="substring-before(substring-after(substring-after(//OTHER_PRODUCT_CLASSIFICATIONS[last()]/CATEGORY_CODE, '|'), '|'), '|')" />
      </CodigoTributacaoMunicipio>

      <xsl:if test="//FIRST_PARTY_CITY_CODE">
        <CodigoMunicipio>
          <xsl:value-of select="//FIRST_PARTY_CITY_CODE" />
        </CodigoMunicipio>
      </xsl:if>

      <CPFCNPJTomador>
        <xsl:if test="//BILL_TO_PARTY_SITE_CPF">
          <CPF>
            <xsl:value-of select="//BILL_TO_PARTY_SITE_CPF" />
          </CPF>
        </xsl:if>
      </CPFCNPJTomador>

      <xsl:if test="//BILL_TO_PARTY_NAME">
        <RazaoSocialTomador>
          <xsl:value-of select="//BILL_TO_PARTY_NAME" />
        </RazaoSocialTomador>
      </xsl:if>

      <EnderecoTomador>
        <TipoLogradouro>
          <xsl:text>-</xsl:text>
        </TipoLogradouro>

        <xsl:choose>
          <xsl:when test="FISCAL_DOC_HEADER/SHIP_TO_PARTY_SITE_COUNTRY != 'BR'">
            <Logradouro>
              <xsl:value-of select="FISCAL_DOC_HEADER/SHIP_TO_PARTY_SITE_ADDRESS1" />
            </Logradouro>
          </xsl:when>
          <xsl:otherwise>
            <Logradouro>
              <xsl:value-of select="FISCAL_DOC_HEADER/BILL_TO_PARTY_SITE_ADDRESS1" />
            </Logradouro>
          </xsl:otherwise>
        </xsl:choose>

        <xsl:choose>
          <xsl:when test="FISCAL_DOC_HEADER/SHIP_TO_PARTY_SITE_COUNTRY != 'BR'">
            <NumeroEndereco>
              <xsl:value-of select="FISCAL_DOC_HEADER/SHIP_TO_PARTY_SITE_ADDRESS2" />
            </NumeroEndereco>
          </xsl:when>
          <xsl:otherwise>
            <NumeroEndereco>
              <xsl:value-of select="FISCAL_DOC_HEADER/BILL_TO_PARTY_SITE_ADDRESS2" />
            </NumeroEndereco>
          </xsl:otherwise>
        </xsl:choose>

        <xsl:choose>
          <xsl:when test="FISCAL_DOC_HEADER/SHIP_TO_PARTY_SITE_COUNTRY != 'BR'">
            <Bairro>
              <xsl:value-of select="FISCAL_DOC_HEADER/SHIP_TO_PARTY_SITE_ADDRESS4" />
            </Bairro>
          </xsl:when>
          <xsl:otherwise>
            <Bairro>
              <xsl:value-of select="FISCAL_DOC_HEADER/BILL_TO_PARTY_SITE_ADDRESS4" />
            </Bairro>
          </xsl:otherwise>
        </xsl:choose>

        <xsl:choose>
          <xsl:when test="FISCAL_DOC_HEADER/SHIP_TO_PARTY_SITE_COUNTRY != 'BR'">
            <Cidade>
              <xsl:value-of select="FISCAL_DOC_HEADER/SHIP_TO_PARTY_SITE_CITY_CODE" />
            </Cidade>
          </xsl:when>
          <xsl:otherwise>
            <Cidade>
              <xsl:value-of select="FISCAL_DOC_HEADER/BILL_TO_PARTY_SITE_CITY_CODE" />
            </Cidade>
          </xsl:otherwise>
        </xsl:choose>

        <xsl:choose>
          <xsl:when test="FISCAL_DOC_HEADER/SHIP_TO_PARTY_SITE_COUNTRY != 'BR'">
            <CidadeTomadorDescricao>
              <xsl:value-of select="FISCAL_DOC_HEADER/SHIP_TO_PARTY_SITE_CITY" />
            </CidadeTomadorDescricao>
          </xsl:when>
          <xsl:otherwise>
            <CidadeTomadorDescricao>
              <xsl:value-of select="FISCAL_DOC_HEADER/BILL_TO_PARTY_SITE_CITY" />
            </CidadeTomadorDescricao>
          </xsl:otherwise>
        </xsl:choose>

        <xsl:if test="//BILL_TO_PARTY_SITE_STATE">
          <xsl:choose>
            <xsl:when test="FISCAL_DOC_HEADER/SHIP_TO_PARTY_SITE_COUNTRY != 'BR'">
              <UF>
                <xsl:text>EX</xsl:text>
              </UF>
            </xsl:when>
            <xsl:otherwise>
              <UF>
                <xsl:value-of select="//BILL_TO_PARTY_SITE_STATE" />
              </UF>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:if>

        <xsl:choose>
          <xsl:when test="FISCAL_DOC_HEADER/SHIP_TO_PARTY_SITE_COUNTRY != 'BR'">
            <Pais>
              <xsl:value-of select="FISCAL_DOC_HEADER/SHIP_TO_PARTY_SITE_COUNTRY" />
            </Pais>
          </xsl:when>
          <xsl:otherwise>
            <Pais>
              <xsl:value-of select="FISCAL_DOC_HEADER/BILL_TO_PARTY_SITE_COUNTRY" />
            </Pais>
          </xsl:otherwise>
        </xsl:choose>
      </EnderecoTomador>

      <xsl:if test="//FISCAL_DOC_LINES/PRODUCT_DESCRIPTION">
        <Descricao>
          <xsl:value-of select="//FISCAL_DOC_LINES/PRODUCT_DESCRIPTION" />
        </Descricao>
      </xsl:if>
    </RPS>
  </xsl:template>
</xsl:stylesheet>