Before do |feature|

end

After do |feature|

end

Before do |scenario|

  $testset = ENV['TESTSET_ALM']
  $alm = ENV['EVIDENCIA_ALM']

  $tag_cenario = scenario.source_tag_names
  $cenario_nome = scenario.name
  $step_counter = 0

  # get all steps from cucumber testcase
  $passos = scenario.test_steps.map(&:name)
  $passos.delete('AfterStep hook')

  ###############################################
  # TODO: GET TABLE CUCUMBER VALUES
  # $passos = scenario.all_source
  # $passos = scenario.test_steps.map(&:name)
  # $passos.delete('AfterStep hook')
  ###############################################

  if $alm == 'S' and !$testset.nil?
    # get user/password for test case according to DB settings
    sql = DB::Mysql.new user: 'robot', passwd: 'FIS2017!', host: '172.16.47.22', port: 3306, db: 'gestao_teste_hml'
    login = sql.get_login($testset, $cenario_nome)
    $usuario = login[0]
    $senha = decode_string(login[1])

    # connect and get all necessary data for ALM integration
    $rest_ALM = RestCall.new
    $rest_ALM.conectar_ALM
    $rest_ALM.obter_dados_ALM($testset, $cenario_nome)
    $rest_ALM.criar_run_ALM
    $steps = $rest_ALM.obter_steps_ALM

    # Deep object copy
    $steps_final = Marshal.load(Marshal.dump($steps))

    # Verifies if feature and ALM have the same steps
    $counter_feature = 0
    $passos.each do |step_feature|
      step_ALM = remove_texto($steps_final[$counter_feature]['step_description'],['Dado','Então','Quando','E']).strip
      raise "Há diferença entre o passo da feature (#{step_feature}) e o passo do ALM (#{step_ALM})." unless step_feature == step_ALM
      $counter_feature += 1
    end

  else
    if ENV['USUARIO']
      $usuario = ENV['USUARIO']
    else
      raise 'Por gentileza, atribua um valor ao parâmetro: USUARIO'
    end
    if ENV['SENHA']
      $senha = ENV['SENHA']
    else
      raise 'Por gentileza, atribua um valor ao parâmetro: SENHA'
    end
  end

  dados_cabecalho = {
                    'h_descCT' => $cenario_nome
                    }
  word_open_template(dados_cabecalho)

end

AfterStep do |scenario|

  if $alm == 'S'
    # visual evidences
    word_insert_step("#{$steps[$step_counter]['step_name'].strip} - #{$steps[$step_counter]['step_description'].strip}", $encoded_img, 'Passed')
    # record passed step in ALM integration
    $rest_ALM.atualizar_step_ALM(
                                $steps[$step_counter]['step_name'],
                                nil,
                                'Passed',
                                $steps[$step_counter]['step_id'],
                                $steps[$step_counter]['step_description']
                              )
  else
    word_insert_step("Step #{$step_counter + 1} - #{$passos[$step_counter]}", $encoded_img, 'Passed')
  end

  $encoded_img = nil
  $step_counter += 1

end

After do |scenario|

  if scenario.failed?

    # $email_recipient = 'email$email.com' # digite o email que receberá alerta de falha de execução do teste.
    sleep 1
    $status_run = 'Failed'

    if $alm == 'S'
      word_insert_step("#{$steps[$step_counter]['step_name'].strip} - #{$steps[$step_counter]['step_description'].strip}", $encoded_img, $status_run)
      # $rest_ALM.enviar_email_ALM($email_recipient)
      $rest_ALM.atualizar_step_ALM(
                                  $steps[$step_counter]['step_name'],
                                  scenario.exception.message,
                                  $status_run,
                                  $steps[$step_counter]['step_id'],
                                  $steps[$step_counter]['step_description']
                                )
    else
      word_insert_step("Step #{$step_counter + 1} - #{$passos[$step_counter]}", $encoded_img, $status_run)
    end

  else
    $status_run = 'Passed'
  end

  obter_evidencia
  $browser.close

end

##########################################################################
# GLOBAL HOOKS ###########################################################
##########################################################################

at_exit do
  begin
    report_path = word_saveas($cenario_nome)
    if $alm == 'S'
      $rest_ALM.atualizar_run_ALM($status_run)
      $rest_ALM.enviar_evidencia_ALM('runs', report_path) # Run Evidence
      # $rest_ALM.enviar_evidencia_ALM('test-instances', report_path) # TestCase Evidence
      $rest_ALM.desconectar_ALM
    end
  rescue => e
    #nothing to do because it will appear on report.
  end
end
