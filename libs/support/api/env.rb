#Project gems
require 'cucumber'
require 'watir'
require 'watir/wait'
require 'magic_encoding'
require 'spreadsheet'
require 'csv'

#LAN Connection Info
require 'socket'

#ALM Rest Api gems
require 'rest-client'
require 'base64'
require 'nokogiri'

#Download and zip/extract files
require 'win32ole'
require 'zip'
require 'date'
require 'tmpdir'

#File dependencies
require 'support/PD/DOS/lib/configuration'                               # config file
require 'support/PD/DOS/hooks'                                           # Common libs

require 'utils/Utils'                                                    # Common libs
require 'utils/EditFile'                                                 # Common libs
require 'utils/Evidencia'                                                # Common libs

require 'utils/ALM/ALMRest'                                              # ALM RESTApi libs
require 'utils/ALM/RestCall'                                             # ALM RESTApi libs

require_relative '../../../../Generic/robots/support/DB'                 # DB libs (MySQL)

# yaml files with containing variable data
$URL = Configuration["url"]

# Browser Download Configs
# alterar_valor_registro('HKEY_CURRENT_USER\Software\Microsoft\Internet Explorer\Main', 'Default Download Directory', 'C:\Downloads')
# $autoit = WIN32OLE.new('AutoItX3.Control')

# start browser
client = Selenium::WebDriver::Remote::Http::Default.new
client.read_timeout = 90
client.open_timeout = 90

case ENV['BROWSER']
  when 'ie'
    browser = Watir::Browser.new :ie, :http_client => client
  when 'firefox'
    profile = Selenium::WebDriver::Firefox::Profile.new
    profile['browser.download.dir'] = 'c:\Downloads'
    profile['browser.download.folderList'] = 2
    profile['browser.helperApps.neverAsk.saveToDisk'] = 'application/zip'
    profile['pdfjs.disabled'] = true
    browser = Watir::Browser.new :firefox, :profile => profile
  when 'chrome'
    browser = Watir::Browser.new :chrome
  else
    browser = Watir::Browser.new :ie, :http_client => client
end
browser.goto $URL
# browser.window.maximize
browser.driver.manage.window.maximize
$browser = browser