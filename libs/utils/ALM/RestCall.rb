class RestCall < ALM::REST

    def initialize
        # to implement when necessary
    end

    def obter_dados_ALM(nome_testset, nome_cenario)
	    @dados_ct = obtem_dados_ct('TESTSET_NAME', 'TEST_NAME', nome_testset, nome_cenario)

        @test_testset = @dados_ct['TESTSET_NAME']
        @test_id = @dados_ct['TEST_ID'].to_i
        @test_instance_id = @dados_ct['TEST_INSTANCE_ID'].to_i
        @test_set_id = @dados_ct['TEST_SET_ID'].to_i
        @test_type = @dados_ct['TEST_TYPE']
        @test_name = @dados_ct['TEST_NAME']
    end

    # def checar_status_ALM
    #     pending
    # end

    def conectar_ALM
        @alm_rest = ALM::REST.new('FIS_BRASIL', 'FIS_Brasil')
	    @alm_rest.autenticar('LC5370407', 'FIS@FEV2018')
    end

    def desconectar_ALM
         @alm_rest.desconectar
    end

    def criar_run_ALM
        @criar_run = @alm_rest.criar_run(Hash[
											'name' => @test_name,
											'test-id' => @test_id,
											'testcycl-id' => @test_instance_id,
                                            'cycle-id' => @test_set_id,
											'subtype-id' => 'hp.qc.run.' + @test_type,
											'owner' => 'lc5370407',
											'status' => 'Not Completed'
											# 'user-01' => 'Real'
											]
                                        )
        @run_id = @alm_rest.obter_valor_XML("//Entity/Fields/Field[@Name='id']/Value", @criar_run, 'run')
    end

    def obter_steps_ALM
        @obter_steps_gerais = @alm_rest.obter_steps(Hash[
                                                        'parent-id' => @run_id
                                                        ]
                                                    )
        step_id = @alm_rest.obter_valor_XML("//Entity/Fields/Field[@Name='id']/Value", @obter_steps_gerais, 'steps')
        step_name = @alm_rest.obter_valor_XML("//Entity/Fields/Field[@Name='name']/Value", @obter_steps_gerais, 'steps')
        description = @alm_rest.obter_valor_XML("//Entity/Fields/Field[@Name='description']/Value", @obter_steps_gerais, 'description')

        steps_count = step_id.count

        if steps_count >= 1 then
            @steps_geral = []
            for counter in 0..steps_count.to_i
                @steps_geral << {
                                'step_id' => step_id[counter],
                                'step_name' => step_name[counter],
                                'step_description' => @alm_rest.obter_valor_HTML(description[counter])
                                # 'step_description' => description[counter] #get complete html node with tags
                                # 'step_description' => @alm_rest.obter_valor_XML("//span", description[counter], 'steps_def') #get only values without accents (no parse)
                            }
            end
            return @steps_geral
        else
            raise 'Não há steps para o CT indicado.'
        end
    end

    # def criar_step_ALM(nome_passo, mensagem_erro="", status_run)
    #     case status_run
    #         when 'Passed'
    #             descricao = @alm_rest.sub_maiusculas(nome_passo)
    #         when 'Failed'
    #             descricao = @alm_rest.sub_maiusculas(nome_passo) + ' (Erro: ' + mensagem_erro + ')'
    #     end
    #     @alm_rest.criar_step(Hash[
    #                             'execution-date' =>formata_data_atual('aaaa-mm-dd'),
    #                             'description' => @alm_rest.sub_maiusculas(descricao),
    #                             'name' => @alm_rest.sub_maiusculas(nome_passo),
    #                             'test-id' => @test_id,
    #                             'status' => status_run,
    #                             'parent-id' => @run_id
    #                             ]
    #                         )
    # end

    def atualizar_step_ALM(step_name, mensagem_erro="", status_run, step_id, step_description)
        case status_run
            when 'Passed'
                descricao = @alm_rest.sub_maiusculas(step_description)
            when 'Failed'
                descricao = @alm_rest.sub_maiusculas(step_description)
                actual = 'Erro: ' + mensagem_erro
        end
        @alm_rest.atualizar_step(Hash[
                                    'execution-date' =>formata_data_atual('aaaa-mm-dd'),
                                    'description' => descricao,
                                    'name' => step_name,
                                    'test-id' => @test_id,
                                    'status' => status_run,
                                    'parent-id' => @run_id,
                                    'id' => step_id,
                                    'actual' => actual
                                    ]
                                )
    end

    def enviar_email_ALM(nome_email)
        @alm_rest.enviar_email(Hash[
                                    'to-recipients' => nome_email,
                                    'subject' => 'CT ' + @test_name + ', FALHOU.',
                                    'comment' => '<h3>ATENÇÃO</h3>
                                                    <p>O seguinte caso de teste <b><font color="#FF0000">falhou: <br /></br />"' + @test_name + '" - Ciclo "' + @test_cycle + '"</font></b></p>
                                                    <p>A falha ocorreu no step: <b><font color="#FF0000">' + @step_name.capitalize + '</font></b>,
                                                    <p>com o seguinte erro técnico: <b><font color="#FF0000">' + scenario.exception.message + '</font></b>.
                                                    <br />
                                                    <p>Obrigado.</p>'
                                    ],
                                    'tests',
                                    @test_id
                                )
    end

    def atualizar_run_ALM(status_run)
        @alm_rest.atualizar_run(Hash[
                                    'id' => @run_id,
                                    'status' => status_run
                                    ]
                                )
    end

    def enviar_evidencia_ALM(entidade, caminho_arquivo)
        case entidade
        when 'runs'
            @entity_id = @run_id
        when 'test-instances'
            @entity_id = @test_instance_id
        end
        @alm_rest.enviar_evidencia(Hash[
										'caminho_arquivo' => caminho_arquivo,
										'entity_id' => @entity_id,
										'entidade' => entidade
										]
									)
    end

end