class EditFile

	def escrever_arquivo(arquivo, texto, tipo)
		File.open(arquivo, tipo) { |file| file.write(texto) }
	end

	def escrever_pasta(pasta)
		Dir.mkdir(pasta)
	end

	def escrever_arquivo_array(arquivo, texto_array, tipo)
		meu_arquivo = File.open(arquivo, tipo)
		texto_array.each do |chave, valor|
			meu_arquivo << "#{valor}\n"
		end
		#meu_arquivo.close
	end

	def ler_arquivo(arquivo)
		meu_arquivo = File.read(arquivo)
	end

	def ler_arquivo_binario(arquivo)
		meu_arquivo = File.open(arquivo,'rb')
	end

	def fecha_processos_excel
		require 'win32ole'
		wmi = WIN32OLE.connect("winmgmts://")
  		processos = wmi.ExecQuery("Select * from Win32_Process Where NAME = 'EXCEL.exe'")
		processos.each do |processo|
			Process.kill('KILL', processo.ProcessID.to_i)
		end
		sleep 2
	end
end
