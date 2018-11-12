#language: pt
#encoding: utf-8

@DOSSIE.ELETRONICO
Funcionalidade: PD - DOS - Dossiê Eletrônico
Contexto:
    Dado que eu esteja logado no DOS
    E que selecione a corporação "BRADESCO", o produto "Visa e Mastercard", a área "AF"
    E clicar no botão "OK"

@CT.INCLUIR.DOSSIE.ELETRONICO
Cenario: [AUT] Incluir Dossiê Eletrônico
    Quando clicar em "Incluir" na opção "Dossiê"
    E selecionar o Tipo de Dossiê "Contestação de Pagamento", preencher o Número do Cartão "6363680000181989", preencher a Descrição "teste de automação" e Valor "10.000,00"
    E clicar no botão "Confirmar"
    E clicar no botão "Gravar"
    Então a mensagem "Operação realizada com sucesso!" será exibida
    E o número do dossiê será armazenado
    E clicar no botão "Inserir Doc."
    E clicar no botão "Escolher arquivo" do navegador para selecionar o arquivo de teste
    E clicar no botão "Anexar"
    E selecionar o Tipo de docto. "Comprovantes de pagamento", preencher a Descrição do documento "teste de automação"
    E clicar no botão "Gravar"
    E clicar no botão "Confirmar"
    Então a mensagem "Operação realizada com sucesso." será exibida

@CT.CONSULTAR.DOSSIE.ELETRONICO
Cenario: [AUT] Consultar Dossiê Eletrônico
    Quando clicar em "Consultar" na opção "Dossiê"
    E digitar o "Número de dossiê" armazenado no campo "Dossiê"
    E clicar no botão "Pesquisar"
    Então o Dossiê recém criado deverá ser exibido na grade
