require_relative '../../lib/poli_informatics/congressional_hearing'
require 'active_support/core_ext/string/filters'
require 'yaml'

poli_informatics_config = YAML.load_file(File.join('config/poli_informatics.yml'))
CONGRESSIONAL_HEARINGS_DIR = poli_informatics_config["congressional_hearings"]

include PoliInformatics::CongressionalHearing
describe PoliInformatics::CongressionalHearing do
  #it "should generate utterances from transcripts" do
  #  u = utterances(File.read("#{CONGRESSIONAL_HEARINGS_DIR}/Dodd-Frank/CHRG-111shrg54589/CHRG-111shrg54589.htm"))
  #  u.each{|x| puts x}
  #end
end