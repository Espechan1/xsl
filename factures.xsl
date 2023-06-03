<?xml version="1.0" encoding="UTF-8" ?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0">

    <xsl:output method="html" encoding="UTF-8" indent="yes"/>

    <xsl:key name="client" match="client" use="@codi"/>
    <xsl:key name="producte" match="producte" use="@codi"/>

    <xsl:template match="celler">
        <html>
            <head>
                <title>EspeWine</title>
                <link rel="stylesheet" href="estil.css"/>
            </head>
            <body>
                <div>
                    <xsl:apply-templates select="factures/factura"/>
                </div>
                <script>
                    date = new Date();
                    year = date.getFullYear();
                    month = date.getMonth() + 1;
                    day = date.getDate();
                    var elements = document.getElementsByClassName("data");
                    for (var i = 0; i &lt; elements.length; i++) {
                        elements[i].innerHTML = month + "/" + day + "/" + year;
                    }
                    
                    var tiposPago = document.getElementsByClassName("tipoPago");
                    var metodos = ["Visa", "Cheque", "Efectiu", "Prestamo"];
                    for (var i = 0; i &lt; tiposPago.length; i++) {
                        let rand = Math.random() * metodos.length;
                        tiposPago[i].innerHTML = metodos[Math.floor(rand)];
                    }
                </script>
            </body>
        </html>
    </xsl:template>

    <xsl:template match="factura">
        <div class="pagina">
            <div class="encabezado">
                <img src="logo.svg" alt="logo"/>
                <div class="titulo">EspeWine</div>
                <img src="logo.svg" alt="logo"/>
            </div>
            
            <div class="datos">
                <div class="datos_empresa">
                    <div >CÓD. FACTURA:</div>
                    <div>
                        <xsl:value-of select="@numero"/>
                    </div>
                    <div>Empresa:</div>
                    <div>ESPEWINE, S.L.U.</div>
                    <div>NIF empresa:</div>
                    <div>43183447G</div>
                </div>
                
                <div class="datos_cliente">
                    <xsl:variable name="codi_client" select="comprador/@codi"/>
                    <xsl:variable name="client" select="//client[@codi=$codi_client]"/>
                    <div>CÓD. CLIENTE:</div>
                    <div>
                        <xsl:value-of select="$client/@codi"/>
                    </div>
                    <div>CLIENTE:</div>
                    <div>
                        <xsl:value-of select="$client/nom"/>
                    </div>
                    <div>TELÉFONO DE CONTACTO 1:</div>
                    <div>
                        <xsl:value-of select="$client/telefon[1]"/>
                    </div>
                    <div>TELÉFONO DE CONTACTO 2:</div>
                    <div>
                        <xsl:value-of select="$client/telefon[2]"/>
                    </div>
                </div>
            </div>
            
            <div class="compra">
                <div class="titulo_compra">CÓDIGO</div>
                <div class="titulo_compra">UDS.</div>
                <div class="titulo_compra">PRODUCTO</div>
                <div class="titulo_compra">PRECIO</div>
                <div class="titulo_compra">IVA</div>
                <div class="titulo_compra">IMPORTE</div>

                <xsl:call-template name="compra">
                    <xsl:with-param name="contador" select="1"/>
                </xsl:call-template>
            </div>

            <xsl:variable name="total">
                <xsl:for-each select="unitats">

                    <xsl:variable name="codi_producte" select="@codi"/>

                    <xsl:variable name="producte" select="//producte[@codi=$codi_producte]"/>
                    <xsl:element name="parcial">
                        <xsl:value-of select=". * $producte/@preu"/>
                    </xsl:element>
                </xsl:for-each>
            </xsl:variable>
            <div class="total">
                <div>Total</div>
                <div class="calculo">
                    <xsl:value-of select="format-number(sum($total/parcial), '#.00€')"/>
                </div>
            </div>

            <xsl:variable name="codi_client" select="comprador/@codi"/>
            <xsl:variable name="client" select="//client[@codi=$codi_client]"/>
            <div class="footer">
                <div>
                    <p>FIRMA</p>
                        <p class="firma">
                        <xsl:value-of
                                select="substring(substring-after($client/nom, ','), 2, 1), '.', substring-before($client/nom, ' ')"/>
                    </p>
                </div>
                <div class="pago">
                    <p>MÉTODOS DE PAGO</p>
                    <p class="tipoPago">pago</p>
                </div>
            </div>
        </div>
    </xsl:template>

    <xsl:template name="compra">
        <xsl:param name="contador"/>
        <xsl:choose>
            <xsl:when test="unitats[$contador]">
                <xsl:variable name="codi_producte" select="unitats[$contador]/@codi"/>
                <xsl:variable name="producte" select="key('producte', $codi_producte)"/>
                <xsl:variable name="preu" select="$producte/@preu"/>

                <div><xsl:value-of select="$codi_producte"/></div>
                <div><xsl:value-of select="unitats[$contador]"/></div>
                <div><xsl:value-of select="$producte"/></div>
                <div><xsl:value-of select="format-number($preu, '#.00€')"/></div>
                <div>iva</div>
                <div><xsl:value-of select="format-number($preu * unitats[$contador], '#.00€')"/></div>

            </xsl:when>
            <xsl:otherwise>
                <div></div>
                <div></div>
                <div></div>
                <div></div>
                <div></div>
                <div></div>
            </xsl:otherwise>
        </xsl:choose>

        <xsl:if test="not($contador = 13)">
            <xsl:call-template name="compra">
                <xsl:with-param name="contador" select="1 + $contador"/>
            </xsl:call-template>
        </xsl:if>
    </xsl:template>
</xsl:stylesheet>