require_relative '../../lib/poli_informatics/corpus'
require 'yaml'

poli_informatics_config = YAML.load_file(File.join('config/poli_informatics.yml'))
CONGRESSIONAL_HEARINGS_DIR = poli_informatics_config["congressional_hearings"]

include PoliInformatics::Corpus
describe PoliInformatics::Corpus do
  it "should find all dodd-frank files" do
    dodd_frank_files.should include("#{CONGRESSIONAL_HEARINGS_DIR}/Dodd-Frank/CHRG-111shrg57923/CHRG-111shrg57923.csv")
    dodd_frank_files.size.should == 122
  end

  it "should get the title from the hearing" do
    hearing_title("#{CONGRESSIONAL_HEARINGS_DIR}/Dodd-Frank/CHRG-111shrg57923/CHRG-111shrg57923.csv").should == "CHRG-111shrg57923"
  end
end