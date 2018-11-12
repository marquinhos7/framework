# encoding: utf-8
require 'magic_encoding'
require 'utils/Utils'
require 'pages/api/Locators'

class APIPage < APIPageLocators
    # def initialize
    #     @driver = $browser
    #     @tela = 'DOS'
    #     @path_file_dossie = 'texts/nr_dossie_eletronico.txt'
    #     @edit_file = EditFile.new
    # end

    # def obter_txt_dossie
    #     return @edit_file.ler_arquivo(@path_file_dossie)
    # end

    # def preencher_nr_dossie(numero)
    #     preencher_textfield(txtfield_nr_dossie, numero, "TextField - valor digitado #{numero}")
    # end

    # def pesquisar_nr_dossie_grid(numero)
    #     pesquisar_valor_coluna(table_grid_dossies, numero, "Dossiês")
    # end

end
