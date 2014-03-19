require_relative '../../lib/poli_informatics/participant_extractor'
require 'active_support/core_ext/string/filters'
require 'yaml'

poli_informatics_config = YAML.load_file(File.join('config/poli_informatics.yml'))
CONGRESSIONAL_HEARINGS_DIR = poli_informatics_config["congressional_hearings"]

include PoliInformatics::ParticipantExtractor
describe PoliInformatics::ParticipantExtractor do
  it "should detect chairs" do
    expect(detect_participant("    Chairman Reed. Let me call the hearing to order. I want to")).
        to eq("Chairman Reed")
  end
  it "should detect senators" do
    expect(detect_participant("    Senator Bunning. Thank you, Mr. Chairman. I appreciate all")).
        to eq("Senator Bunning")
    expect(detect_participant("    Senator Crapo. First of all, Mr. Chairman, let me thank you")).
        to eq("Senator Crapo")
  end

  it "should detect Ms." do
    expect(detect_participant("    Ms. Schapiro. Thank you very much, Chairman Reed.")).
        to eq("Ms. Schapiro")
  end


  it "should detect Mr." do
    expect(detect_participant("    Mr. Gensler. Chairman Reed, Ranking Member Bunning, other")).
        to eq("Mr. Gensler")
  end

  it "shouldn't extract participants if the name ends in punctuation" do
    expect(detect_participant("    Mr. Blinder?")).
        to eq("")
  end

  it "shouldn't extract participants if it's all caps and ends in a '.'" do
    expect(detect_participant("HOPE NOW.")).
        to eq("")
  end

  it 'should not detect participants in witness lists' do
    expect(detect_participant("        Chairman Reed............................................    88")).
        to be_empty
    expect(detect_participant("    Senator Akaka")).
        to be_empty
  end

  it 'should split a participant from the text' do
    expect(split("    Mr. Gensler. Chairman Reed, Ranking Member Bunning, other")).
        to eq({participant: 'Mr. Gensler', value: 'Chairman Reed, Ranking Member Bunning, other'})
  end

  it 'should not extract questions' do
    expect(detect_participant("OCC?")).
        to be_empty

  end
  it "should extract statements that end in '.'" do
    expect(detect_participant("RESPONSE TO WRITTEN QUESTIONS OF SENATOR MERKLEY FROM BEN S.")).
        to eq("RESPONSE TO WRITTEN QUESTIONS OF SENATOR MERKLEY FROM BEN S.")

  end
end