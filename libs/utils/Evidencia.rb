
def word_open_template(dados_cabecalho = {})
    $word = WIN32OLE.new('Word.Application')
    $word.Visible = false
    file = __dir__ + '/../../PD/DOS/docs/Template_PD.docx'
    $document = $word.Documents.Open(file)

    ################# Word HeaderMap ################
    header_table = $document.Tables(1)

    h_cliente = header_table.Cell(2,2).Range
    h_projeto = header_table.Cell(3,2).Range
    h_num_defect = header_table.Cell(3,4).Range
    h_desc = header_table.Cell(4,2).Range
    h_plat = header_table.Cell(5,2).Range
    h_modulo = header_table.Cell(5,4).Range
    h_ambiente = header_table.Cell(6,2).Range
    h_data = header_table.Cell(6,4).Range
    h_autor = header_table.Cell(7,2).Range
    h_resp_hom = header_table.Cell(8,2).Range
    h_descCT = header_table.Cell(9,2).Range
    #################################################

    h_cliente.Text = "cliente"
    h_projeto.Text = "projeto"
    h_num_defect.Text = "num_defect"
    h_desc.Text = "descrição"
    h_plat.Text = "plataforma"
    h_modulo.Text = "modulo"
    h_ambiente.Text = "ambiente"
    h_data.Text = Time.now.strftime("%d/%m/%Y")
    h_autor.Text = "teste"
    h_resp_hom.Text = "responsável"
    h_descCT.Text = dados_cabecalho['h_descCT']
end

def word_insert_step(step_desc, img, status)
   puts $document.paragraphs.count
    $document.paragraphs.last.range.sections.add # adicionar nova página
    # $document.sections($document.sections.count-1).Range.sections.add

    $document.paragraphs.add
    obj_step = $document.paragraphs.last.range
    obj_step.text = step_desc
    status == 'Passed' ? obj_step.Font.ColorIndex = 10 : obj_step.Font.ColorIndex = 6 # true: green / false: red
    obj_step.Font.Bold = true
    obj_step.Font.size = 14

    unless img.nil?
        $document.paragraphs.add
        obj_image = $document.paragraphs.last.range
        obj_canvas = obj_image.InlineShapes.AddPicture img, false, true
        obj_canvas.ScaleHeight = 75
        obj_canvas.ScaleWidth = 75
        obj_canvas.PictureFormat.CropLeft = 200
        obj_canvas.PictureFormat.CropRight = 200
        obj_canvas.PictureFormat.CropTop = 5
        obj_canvas.PictureFormat.CropBottom = 50
    end
end

def word_PD_footer
    file = __dir__ + '/../../PD/DOS/docs/Template_footer_PD.docx'
    doc = $word.Documents.Open(file)
    doc.tables(1).range.copy
    doc.close
    $document.paragraphs.last.range.sections.add
    $document.paragraphs.add
    $document.paragraphs.last.range.paste
end

def word_saveas(filename)
    word_PD_footer
    temp = Dir.tmpdir()
    file = "#{temp}/#{remove_acentos(filename)}_#{Time.now.strftime("%Y%m%d_%H%M%S")}.docx"
    $document.saveas(file)
    $document.close
    return file
end
