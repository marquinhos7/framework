require 'rubygems'
require 'httparty'
require 'json'
require 'sinatra'

class Consulta
    include HTTParty
    base_uri "10.30.39.70:3000"
    default_params :output => 'json'
    format :json

    def setup(idServ, dado)
        response = HTTParty.get("http://10.30.39.70:3000/servico/#{idServ}")
        response.parsed_response[dado]['nome']
    end


    def cenariosParam(idServ)
        response = HTTParty.get("http://10.30.39.70:3000/servico/#{idServ}")
        response.parsed_response['cenarios'].each{|value|"value:#{value}"}.each {|x| puts x['nome']}
    end


    def etapasParam(idServ, id_etapa)
        response = HTTParty.get("http://10.30.39.70:3000/servico/#{idServ}")
        x = response.parsed_response['cenarios'].each{|value|"value:#{value}"}.each{|x| puts x['etapas'][id_etapa]}
    end    


    def param(idServ, id)
        response = HTTParty.get("http://10.30.39.70:3000/servico/#{idServ}")
        response.parsed_response['cenarios'].each{|value|"value:#{value}"}.each{|x| puts x['etapas'][0]['parametro']}

    end    


    def etapasParam_new(idServ, id)
        cen = []
        cenarios = cenariosParam(idServ)
        cenarios.each_with_index do |cenario, index|
            cen[index] = {cenario['nome'] => cenario['etapas']}
        end
        parametro = []
        parametros = param(idServ, id)
        parametros.each_with_index do |parametro, index|
            parametro[index] = {parametro['nome'] => parametro['parametro']}     
        end 
    end   




    def acao
        response = HTTParty.get('http://10.30.39.70:3000/acao/')
    end   
end    

def teste(idServ, dado, etapas)
    @result = HTTParty.get("http://10.30.39.70:3000/servico/#{idServ}")
    
    @result.parsed_response[dado][1][etapas].to_json

    puts @result.json_body

end


#   puts Consulta.etapas(0).inspect

teste(1, 'cenarios', 'etapas')
    # consultaCenario = Consulta.new  
    # consultaCenario.param(0, 0)     
    