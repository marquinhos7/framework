# encoding: utf-8

require 'magic_encoding'
require 'pages/api/global/ReutilizaveisPage'

global = ReutilizaveisPage.new

# ########################################################################################################################
# #DADO
# ########################################################################################################################

# Dado(/^que eu esteja logado no DOS$/) do
#     home_page.logout
#     home_page.validar_http_500
#     login_page.realizar_login($usuario, $senha)
#     home_page.validar_pagina_carregada
#     obter_evidencia
# end

# Dado(/^que selecione a corporação "([^"]*)", o produto "([^"]*)", a área "([^"]*)"$/) do |corp, produto, area|
#     global.selecionar_corporacao(corp)
#     global.selecionar_produto(produto)
#     global.selecionar_area(area)
#     obter_evidencia
# end

# ########################################################################################################################
# #QUANDO
# ########################################################################################################################

# Quando(/^clicar no botão "([^"]*)"$/) do |opcao|
#     global.clicar_botao_opcao(opcao)
#     obter_evidencia
# end

# ########################################################################################################################
# #ENTAO
# ########################################################################################################################