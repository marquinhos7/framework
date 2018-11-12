require 'magic_encoding'
require 'pages/api/Page'

consulta_dossie_eletronico = APIPage.new

# ########################################################################################################################
# # DADO
# ########################################################################################################################


# ########################################################################################################################
# # QUANDO
# ########################################################################################################################

# Quando(/^digitar o "([^"]*)" armazenado no campo "([^"]*)"$/) do |nr_dossie, txt_dossie|
#     $dossie = consulta_dossie_eletronico.obter_txt_dossie
#     consulta_dossie_eletronico.preencher_nr_dossie($dossie)
#     obter_evidencia
# end

# ########################################################################################################################
# # ENTAO
# ########################################################################################################################

# Então(/^o Dossiê recém criado deverá ser exibido na grade$/) do
#     consulta_dossie_eletronico.pesquisar_nr_dossie_grid($dossie)
#     obter_evidencia
# end