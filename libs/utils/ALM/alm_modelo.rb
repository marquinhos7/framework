require 'rest-client'
require 'base64'
require 'nokogiri'

enc = Base64.encode64('lc5370407:Sfcitb2017')
authHeader = 'Basic '+enc.to_s
$test_id = '591'

response = RestClient::Request.execute(
	:method => :get, 
	:url => 'http://10.8.236.81:8080/qcbin/authentication-point/authenticate',
	:headers => {:'Authorization' => authHeader }, 
	:proxy => 'http://re034846:Vida!Res@proxycenesp.resource.com.br:3128/'
)

# Get ALM token
@token = response.cookies.values[0]

cookiesresponse = RestClient::Request.execute(
	:method => :post, 
	:url => 'http://10.8.236.81:8080/qcbin/rest/site-session', 
	:cookies => {:LWSSO_COOKIE_KEY => @token},
	:proxy => 'http://re034846:Vida!Res@proxycenesp.resource.com.br:3128/'
	)

######### FIM LOGIN #########	
	
#XML RUN
# $xml_run = %{<Entity Type="run">
# 			<Fields>
# 				<Field Name="name">
# 					<Value>Teste Edu</Value>
# 				</Field>
# 				<Field Name="test-id">
# 					<Value>1161</Value>
# 				</Field>
# 				<Field Name="testcycl-id">
# 					<Value>#{$test_id.to_s}</Value>
# 				</Field>
# 				<Field Name="subtype-id">
# 					<Value>hp.qc.run.QUICKTEST_TEST</Value>
# 				</Field>
# 				<Field Name="owner">
# 					<Value>eduardo.tavares.spd</Value>
# 				</Field>
# 				<Field Name="status">
# 					<Value>Passed</Value>
# 				</Field>
# 			</Fields>
# 		</Entity>}

begin
	#POST EXAMPLE
	post_run = RestClient::Request.execute(
		:method => :get,  
		:url => 'http://10.8.236.81:8080/qcbin/rest/domains/FIS_BRASIL/projects/FIS_Brasil/customization/entities/test-instance/fields', 
		# :payload => $xml_run,
		:headers => {
					:'Content-Type' => 'application/xml', 
					:'Accept' => 'application/xml'
				},
		:cookies => {
					:LWSSO_COOKIE_KEY => cookiesresponse.cookies.values[2],
					:QCSession => cookiesresponse.cookies.values[3]
				},
		:proxy => 'http://re034846:Vida!Res@proxycenesp.resource.com.br:3128/'
		)
	puts post_run
	# $run_id = Nokogiri::XML(post_run).xpath("//Entity/Fields/Field[@Name='id']/Value").text
rescue RestClient::ExceptionWithResponse => err
	puts err.response
end

#XML RUN
# $xml_run = %{<Entity Type="run">
# 			<Fields>
# 				<Field Name="id">
# 					<Value>#{$run_id.to_s}</Value>
# 				</Field>
# 				<Field Name="status">
# 					<Value>Passed</Value>
# 				</Field>
# 			</Fields>
# 		</Entity>}

# begin
# 	#POST RUN
# 	update_run = RestClient::Request.execute(
# 		:method => :put,  
# 		:url => 'https://almcielo.saas.hp.com/qcbin/rest/domains/CIELO/projects/PJ_000212_BoB_Aut_Spread/runs/'+$run_id.to_s, 
# 		:payload => $xml_run,
# 		:headers => {
# 					:'Content-Type' => 'application/xml', 
# 					:'Accept' => 'application/xml'
# 				},
# 		:cookies => {
# 					:LWSSO_COOKIE_KEY => cookiesresponse.cookies.values[2],
# 					:QCSession => cookiesresponse.cookies.values[3]
# 				},
# 		:proxy => 'http://proxypac:8080/'
# 		)
# 	puts update_run.code
# rescue RestClient::ExceptionWithResponse => err
# 	puts err.response
# end

# abort

# (0..5).each do |contador|
# 	#XML RUN STEP
# 	$xml_run_step = %{<Entity Type="run-step">
# 						<Fields>
# 							<Field Name="execution-date">
# 								<Value>2016-09-21</Value>
# 							</Field>
# 							<Field Name="description">
# 								<Value>Descrição #{contador}</Value>
# 							</Field>
# 							<Field Name="name">
# 								<Value>Step #{contador}</Value>
# 							</Field>
# 							<Field Name="test-id">
# 								<Value>1161</Value>
# 							</Field>
# 							<Field Name="status">
# 								<Value>Passed</Value>
# 							</Field>
# 							<Field Name="parent-id">
# 								<Value>#{$run_id.to_s}</Value>
# 							</Field>
# 						</Fields>
# 					</Entity>}

# 	begin
# 		#POST RUN STEP
# 		post_run_step = RestClient::Request.execute(
# 			:method => :post,  
# 			:url => 'https://almcielo.saas.hp.com/qcbin/rest/domains/CIELO/projects/PJ_000212_BoB_Aut_Spread/run-steps', 
# 			:payload => $xml_run_step,
# 			:headers => {
# 						:'Content-Type' => 'application/xml', 
# 						:'Accept' => 'application/xml'
# 					},
# 			:cookies => {
# 						:LWSSO_COOKIE_KEY => cookiesresponse.cookies.values[2],
# 						:QCSession => cookiesresponse.cookies.values[3]
# 					},
# 			:proxy => 'http://proxypac:8080/'
# 			)
# 		#puts post_run_step.code
# 	rescue RestClient::ExceptionWithResponse => err
# 		puts err.response
# 	end

# end

# arquivo = File.open('/Projects/1-ARV-TB6/report_edu.html','rb')

# begin
# 	#$run_id = 2889
# 	#POST RUN ATTACHMENT
# 	post_run_attach = RestClient::Request.execute(
# 		:method => :post,  
# 		:url => 'https://almcielo.saas.hp.com/qcbin/rest/domains/CIELO/projects/PJ_000212_BoB_Aut_Spread/runs/'+$run_id.to_s+'/attachments', 
# 		:payload => arquivo,
# 		:headers => {
# 					:'Content-Type' => 'application/octet-stream',
# 					:'Slug' => File.basename(arquivo)
# 				},
# 		:cookies => {
# 					:LWSSO_COOKIE_KEY => cookiesresponse.cookies.values[2],
# 					:QCSession => cookiesresponse.cookies.values[3]
# 				},
# 		:proxy => 'http://proxypac:8080/'
# 		)
# 	puts post_run_attach
# 	arquivo.close
# rescue RestClient::ExceptionWithResponse => err
# 	puts err.response
# end

# #######################################################################
# ## SAMPLES ############################################################
# #######################################################################
	
# # #GET
# # get_values = Nokogiri::XML(RestClient::Request.execute(
# 	# :method => :get,  
# 	# :url => 'https://almcielo.saas.hp.com/qcbin/rest/domains/CIELO/projects/PJ_000212_BoB_Aut_Spread/customization/entities/test-set/fields?required=true', 
# 	# :cookies => {
# 				# :ALM_USER => cookiesresponse.cookies.values[0],
# 				# :JSESSIONID => cookiesresponse.cookies.values[1],
# 				# :LWSSO_COOKIE_KEY => cookiesresponse.cookies.values[2],
# 				# :QCSession => cookiesresponse.cookies.values[3],
# 				# :'XSRF-TOKEN' => cookiesresponse.cookies.values[4]
# 			# },
# 	# :proxy => 'http://proxypac:8080/'
# 	# )
# # )
