<xsl:stylesheet version="2.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:output method="xml" version="1.0" encoding="utf-8" indent="yes" />

  <xsl:variable name="docHeader" select="//FISCAL_DOC_HEADER" />
  <xsl:variable name="docLines" select="$docHeader/FISCAL_DOC_LINES" />
  <xsl:variable name="lastCategoryCode"
    select="$docLines/OTHER_PRODUCT_CLASSIFICATIONS[last()]/CATEGORY_CODE" />

  <xsl:template match="/">
    <SynchroId xmlns="http://www.synchro.com.br/nfe"
      xsi:schemaLocation="http://www.synchro.com.br/nfe SynNFSePedidoEnvioRPS_V01.xsd"
      xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
      <SistemaOrigem>
        <xsl:text>SynchroNFSe</xsl:text>
      </SistemaOrigem>
      <ChaveOrigem>
        <xsl:value-of select="//TRX_ID" />
      </ChaveOrigem>
      <CodIBGEMun>
        <xsl:value-of select="//FIRST_PARTY_CITY_CODE" />
      </CodIBGEMun>
      <CpfCnpjPrestador>
        <xsl:value-of select="//FIRST_PARTY_TAXPAYERID" />
      </CpfCnpjPrestador>
      <PedidoEnvioRPS>
        <Cabecalho Versao="1" />
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

            <xsl:if test="//RPS_NUMBER">
              <NumeroRPS>
                <xsl:value-of select="//RPS_NUMBER" />
              </NumeroRPS>
            </xsl:if>
          </ChaveRPS>

          <TipoRPS>
            <xsl:text>1</xsl:text>
          </TipoRPS>

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
              select="format-number(number($docLines/TRX_LINE_QUANTITY) * number($docLines/UNIT_PRICE), '0.00')" />
          </ValorServicos>

          <ValorDeducoes>
            <xsl:text>0</xsl:text>
          </ValorDeducoes>

          <ValorPIS>
            <xsl:choose>
              <xsl:when test="$docLines//TAX_LINES[contains(TAX, 'PIS') and REGIME_TYPE_FLAG='W']">
                <xsl:value-of select="//TAX_RATE" />
              </xsl:when>
              <xsl:when
                test="$docLines//TAX_LINES[contains(TAX, 'PIS') and REGIME_TYPE_FLAG='I' and TAX_REPORTING_CODES[REPORTING_TYPE_CODE='LACLS_BR_WHT_TYPE'and REP_CODE_TAX='WH']]">
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
                test="$docLines//TAX_LINES[contains(TAX, 'COFINS') and REGIME_TYPE_FLAG='W']">
                <xsl:value-of select="//TAX_RATE" />
              </xsl:when>
              <xsl:when
                test="$docLines//TAX_LINES[contains(TAX, 'COFINS') and REGIME_TYPE_FLAG='I' and TAX_REPORTING_CODES[REPORTING_TYPE_CODE='LACLS_BR_WHT_TYPE' and REP_CODE_TAX='WH']]">
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

          <xsl:if test="$docLines/PRODUCT_DESCRIPTION">
            <DescricaoCodServico>
              <xsl:value-of select="$docLines/PRODUCT_DESCRIPTION" />
            </DescricaoCodServico>
          </xsl:if>

          <CodigoCnae>
            <xsl:value-of
              select="substring-before(//OTHER_PRODUCT_CLASSIFICATIONS[last()]/CATEGORY_CODE, '|')" />
          </CodigoCnae>

          <xsl:for-each select="$docLines//TAX_LINES[contains(TAX, 'ISS')]">
            <xsl:choose>
              <xsl:when test="REGIME_TYPE_FLAG='W'">
                <AliquotaServicos>
                  <xsl:value-of select="format-number(number(TAX_RATE), '0.00')" />
                </AliquotaServicos>
              </xsl:when>
              <xsl:when
                test="REGIME_TYPE_FLAG='I' and TAX_REPORTING_CODES/REPORTING_TYPE_CODE='LACLS_BR_WHT_TYPE' and TAX_REPORTING_CODES/REP_CODE_TAX='WH'">
                <AliquotaServicos>
                  <xsl:value-of select="format-number(number(TAX_RATE), '0.00')" />
                </AliquotaServicos>
              </xsl:when>
              <xsl:when
                test="REGIME_TYPE_FLAG='I' and (not(TAX_REPORTING_CODES/REPORTING_TYPE_CODE='LACLS_BR_WHT_TYPE') or not(TAX_REPORTING_CODES/REP_CODE_TAX='WH'))">
                <AliquotaServicos>
                  <xsl:value-of select="format-number(number(TAX_RATE), '0.00')" />
                </AliquotaServicos>
              </xsl:when>
              <xsl:otherwise>
                <AliquotaServicos>
                  <xsl:text>0.00</xsl:text>
                </AliquotaServicos>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:for-each>

          <xsl:variable name="ISSRetido">
            <xsl:for-each select="$docLines//TAX_LINES[contains(TAX, 'ISS')]">
              <xsl:choose>
                <xsl:when test="REGIME_TYPE_FLAG='W'">
                  <xsl:value-of select="'true'" />
                </xsl:when>
                <xsl:when
                  test="REGIME_TYPE_FLAG='I' and TAX_REPORTING_CODES/REPORTING_TYPE_CODE='LACLS_BR_WHT_TYPE' and TAX_REPORTING_CODES/REP_CODE_TAX='WH'">
                  <xsl:value-of select="'true'" />
                </xsl:when>
                <xsl:when
                  test="REGIME_TYPE_FLAG='I' and (not(TAX_REPORTING_CODES/REPORTING_TYPE_CODE='LACLS_BR_WHT_TYPE') or not(TAX_REPORTING_CODES/REP_CODE_TAX='WH'))">
                  <xsl:value-of select="'false'" />
                </xsl:when>
                <xsl:otherwise>
                  <xsl:value-of select="'false'" />
                </xsl:otherwise>
              </xsl:choose>
            </xsl:for-each>
          </xsl:variable>

          <ISSRetido>
            <xsl:value-of select="$ISSRetido" />
          </ISSRetido>

          <xsl:variable name="ValorIssRetido">
            <xsl:choose>
              <xsl:when test="$ISSRetido = 'true'">
                <xsl:value-of select="number(TAX_AMT)" />
              </xsl:when>
              <xsl:otherwise>
                <xsl:value-of select="0" />
              </xsl:otherwise>
            </xsl:choose>
          </xsl:variable>

          <xsl:variable name="ValorIss">
            <xsl:for-each select="$docLines//TAX_LINES[contains(TAX, 'ISS')]">
              <xsl:choose>
                <xsl:when test="REGIME_TYPE_FLAG='W'">
                  <xsl:value-of select="format-number(0, '0.00')" />
                </xsl:when>
                <xsl:when
                  test="REGIME_TYPE_FLAG='I' and TAX_REPORTING_CODES/REPORTING_TYPE_CODE='LACLS_BR_WHT_TYPE' and TAX_REPORTING_CODES/REP_CODE_TAX='WH'">
                  <xsl:value-of select="format-number(0, '0.00')" />
                </xsl:when>
                <xsl:when
                  test="REGIME_TYPE_FLAG='I' and (not(TAX_REPORTING_CODES/REPORTING_TYPE_CODE='LACLS_BR_WHT_TYPE') or not(TAX_REPORTING_CODES/REP_CODE_TAX='WH'))">
                  <xsl:value-of select="format-number(number(TAX_AMT), '0.00')" />
                </xsl:when>
                <xsl:otherwise>
                  <xsl:value-of select="format-number(0, '0.00')" />
                </xsl:otherwise>
              </xsl:choose>
            </xsl:for-each>
          </xsl:variable>

          <ValorIss>
            <xsl:value-of select="$ValorIss" />
          </ValorIss>

          <xsl:variable name="BaseCalculo">
            <xsl:value-of select="format-number(number($docLines/LINE_AMT), '0.00')" />
          </xsl:variable>

          <xsl:if test="$docLines/LINE_AMT">
            <BaseCalculo>
              <xsl:value-of select="$BaseCalculo" />
            </BaseCalculo>
          </xsl:if>

          <ValorLiquidoNfse>
            <xsl:value-of
              select="format-number(number($BaseCalculo) - number($ValorIssRetido), '0.00')" />
          </ValorLiquidoNfse>

          <Tributavel>
            <xsl:choose>
              <xsl:when test="//FISCAL_DOC_LINES/BILLABLE_FLAG = 'Y'">
                <xsl:text>S</xsl:text>
              </xsl:when>
              <xsl:when test="//FISCAL_DOC_LINES/BILLABLE_FLAG = 'N'">
                <xsl:text>N</xsl:text>
              </xsl:when>
              <xsl:otherwise>
                <xsl:text>S</xsl:text>
              </xsl:otherwise>
            </xsl:choose>
          </Tributavel>

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
              <xsl:when test="$docHeader/SHIP_TO_PARTY_SITE_COUNTRY != 'BR'">
                <Logradouro>
                  <xsl:value-of select="$docHeader/SHIP_TO_PARTY_SITE_ADDRESS1" />
                </Logradouro>
              </xsl:when>
              <xsl:otherwise>
                <Logradouro>
                  <xsl:value-of select="$docHeader/BILL_TO_PARTY_SITE_ADDRESS1" />
                </Logradouro>
              </xsl:otherwise>
            </xsl:choose>

            <xsl:choose>
              <xsl:when test="$docHeader/SHIP_TO_PARTY_SITE_COUNTRY != 'BR'">
                <NumeroEndereco>
                  <xsl:value-of select="$docHeader/SHIP_TO_PARTY_SITE_ADDRESS2" />
                </NumeroEndereco>
              </xsl:when>
              <xsl:otherwise>
                <NumeroEndereco>
                  <xsl:value-of select="$docHeader/BILL_TO_PARTY_SITE_ADDRESS2" />
                </NumeroEndereco>
              </xsl:otherwise>
            </xsl:choose>

            <xsl:choose>
              <xsl:when test="$docHeader/SHIP_TO_PARTY_SITE_COUNTRY != 'BR'">
                <Bairro>
                  <xsl:value-of select="$docHeader/SHIP_TO_PARTY_SITE_ADDRESS4" />
                </Bairro>
              </xsl:when>
              <xsl:otherwise>
                <Bairro>
                  <xsl:value-of select="$docHeader/BILL_TO_PARTY_SITE_ADDRESS4" />
                </Bairro>
              </xsl:otherwise>
            </xsl:choose>

            <xsl:choose>
              <xsl:when test="$docHeader/SHIP_TO_PARTY_SITE_COUNTRY != 'BR'">
                <Cidade>
                  <xsl:value-of select="$docHeader/SHIP_TO_PARTY_SITE_CITY_CODE" />
                </Cidade>
              </xsl:when>
              <xsl:otherwise>
                <Cidade>
                  <xsl:value-of select="$docHeader/BILL_TO_PARTY_SITE_CITY_CODE" />
                </Cidade>
              </xsl:otherwise>
            </xsl:choose>

            <xsl:choose>
              <xsl:when test="$docHeader/SHIP_TO_PARTY_SITE_COUNTRY != 'BR'">
                <CidadeTomadorDescricao>
                  <xsl:value-of select="$docHeader/SHIP_TO_PARTY_SITE_CITY" />
                </CidadeTomadorDescricao>
              </xsl:when>
              <xsl:otherwise>
                <CidadeTomadorDescricao>
                  <xsl:value-of select="$docHeader/BILL_TO_PARTY_SITE_CITY" />
                </CidadeTomadorDescricao>
              </xsl:otherwise>
            </xsl:choose>

            <xsl:if test="//BILL_TO_PARTY_SITE_STATE">
              <xsl:choose>
                <xsl:when test="$docHeader/SHIP_TO_PARTY_SITE_COUNTRY != 'BR'">
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
              <xsl:when test="$docHeader/SHIP_TO_PARTY_SITE_COUNTRY != 'BR'">
                <Pais>
                  <xsl:value-of select="$docHeader/SHIP_TO_PARTY_SITE_COUNTRY" />
                </Pais>
              </xsl:when>
              <xsl:otherwise>
                <Pais>
                  <xsl:value-of select="$docHeader/BILL_TO_PARTY_SITE_COUNTRY" />
                </Pais>
              </xsl:otherwise>
            </xsl:choose>
          </EnderecoTomador>

          <xsl:choose>
            <xsl:when test="$docHeader/SHIP_TO_PARTY_SITE_COUNTRY != 'BR'">
              <EmailTomador>
                <xsl:value-of select="$docHeader/SHIP_TO_PARTY_SITE_EMAIL" />
              </EmailTomador>
            </xsl:when>
            <xsl:otherwise>
              <EmailTomador>
                <xsl:value-of select="$docHeader/BILL_TO_PARTY_SITE_EMAIL" />
              </EmailTomador>
            </xsl:otherwise>
          </xsl:choose>

          <xsl:if test="$docLines/PRODUCT_DESCRIPTION">
            <Descricao>
              <xsl:value-of select="$docLines/PRODUCT_DESCRIPTION" />
            </Descricao>
          </xsl:if>

          <Discriminacao>
            <xsl:value-of select="$docLines/PRODUCT_DESCRIPTION" />
          </Discriminacao>

          <CodigoPaisServico>
            <xsl:text>0055</xsl:text>
          </CodigoPaisServico>

          <ExigibilidadeISS>
            <xsl:choose>
              <xsl:when test="number($ValorIss) > 0">
                <xsl:text>1</xsl:text>
              </xsl:when>
              <xsl:otherwise>
                <xsl:text>0</xsl:text>
              </xsl:otherwise>
            </xsl:choose>
          </ExigibilidadeISS>

          <Competencia>
            <xsl:value-of select="substring-before(//TRX_DATE, '.')" />
          </Competencia>

          <IncentivoFiscal>
            <xsl:text>1</xsl:text>
          </IncentivoFiscal>
        </RPS>
      </PedidoEnvioRPS>
    </SynchroId>
  </xsl:template>
</xsl:stylesheet>