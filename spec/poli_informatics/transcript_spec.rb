require_relative '../../lib/poli_informatics/transcript'
require 'active_support/core_ext/string/filters'
require 'yaml'

poli_informatics_config = YAML.load_file(File.join('config/poli_informatics.yml'))
CONGRESSIONAL_HEARINGS_DIR = poli_informatics_config["congressional_hearings"]

include PoliInformatics
describe PoliInformatics::Transcript do
  describe 'a new Trancript' do
    transcript = Transcript.new
    it 'should not have any records' do
      expect(transcript).to have(2).records
    end

    its 'current record should be empty' do
      expect(transcript.current_text).to be_empty
    end

    its 'current participant should be empty' do
      expect(transcript.current_participant).to be_empty
    end
  end

  describe '#ingest' do
    transcript = Transcript.new
    it 'should not ingest the preamble' do
      transcript.ingest('<html>      ')
      transcript.ingest('<title> - OVER-THE-COUNTER DERIVATIVES:</title>')
      transcript.ingest('<body><pre>')
      transcript.ingest('[Senate Hearing 111-248]')
      transcript.ingest('    Senator Crapo................................................     3')
      transcript.ingest('    The Subcommittee met at 3:03 p.m., in room SD-538, Dirksen')
      transcript.ingest('Senate Office Building, Senator Jack Reed (Chairman of the')
      expect(transcript).to have(2).records
      expect(transcript.current_text).to be_empty
    end

    it 'should create a new utterance if a line has a speaker' do
      transcript.ingest('    Chairman Reed. Let me call the hearing to order. I want to')
      expect(transcript.current_participant).to eq('Chairman Reed')
      expect(transcript.current_text).to eq('Let me call the hearing to order. I want to')
    end

    it 'should create a new utterance if a line is all caps' do
      transcript.ingest('                PREPARED STATEMENT OF SENATOR MIKE CRAPO')
      expect(transcript.current_participant).to eq('PREPARED STATEMENT OF SENATOR MIKE CRAPO')
      expect(transcript.current_text).to eq('')
    end

    it 'should handle multiple all caps lines as a single new participant' do
      transcript.ingest('    Chairman Reed. Let me call the hearing to order. I want to')
      transcript.ingest('STATEMENT OF THE HONORABLE T. TIMOTHY RYAN, JR., PRESIDENT AND ')
      transcript.ingest('  CHIEF EXECUTIVE OFFICER, SECURITIES INDUSTRY AND FINANCIAL ')
      transcript.ingest('                  MARKETS ASSOCIATION (SIFMA)')
      transcript.ingest('')
      expect(transcript.current_participant).to eq('STATEMENT OF THE HONORABLE T. TIMOTHY RYAN, JR., PRESIDENT AND CHIEF EXECUTIVE OFFICER, SECURITIES INDUSTRY AND FINANCIAL MARKETS ASSOCIATION (SIFMA)')
      transcript.ingest('    Mr. Ryan. Thank you, Chairman Frank, Ranking Member Bachus, ')
      transcript.ingest('and members of the committee. My testimony will detail the ')
      expect(transcript.current_text).to eq('Thank you, Chairman Frank, Ranking Member Bachus, and members of the committee. My testimony will detail the')
    end

    it 'should handle multiple all caps lines as a single new participant' do
      transcript.ingest('    Senator Bunning. Thank you, Mr. Chairman. I appreciate all')
      transcript.ingest('Thank you, Mr. Chairman.')
      expect(transcript.current_participant).to eq('Senator Bunning')
      expect(transcript.current_text).to eq('Thank you, Mr. Chairman. I appreciate all Thank you, Mr. Chairman.')
      transcript.ingest('    Chairman Reed. Thank you, Senator Bunning.')
      transcript.ingest('    Senator Crapo, do you have an opening statement?')
      expect(transcript.current_participant).to eq('Chairman Reed')
      expect(transcript.current_text).to eq('Thank you, Senator Bunning. Senator Crapo, do you have an opening statement?')
      transcript.ingest('    Senator Crapo. I do, if I could, Mr. Chairman.')
      expect(transcript.current_participant).to eq('Senator Crapo')
      expect(transcript.current_text).to eq('I do, if I could, Mr. Chairman.')
      transcript.ingest('    Chairman Reed. Please.')
      expect(transcript.current_participant).to eq('Chairman Reed')
      expect(transcript.current_text).to eq('Please.')
    end

    it 'should handle multiline statements that end in .' do
      transcript.ingest('')
      transcript.ingest('STATEMENT OF MARTIN S. FELDSTEIN, GEORGE F. BAKER PROFESSOR OF ')
      transcript.ingest('ECONOMICS, HARVARD UNIVERSITY, AND PRESIDENT EMERITUS, NATIONAL ')
      transcript.ingest('               BUREAU OF ECONOMIC RESEARCH, INC.')
      transcript.ingest('')
      expect(transcript.current_participant).
          to eq('STATEMENT OF MARTIN S. FELDSTEIN, GEORGE F. BAKER PROFESSOR OF ECONOMICS, HARVARD UNIVERSITY, AND PRESIDENT EMERITUS, NATIONAL BUREAU OF ECONOMIC RESEARCH, INC.')
      expect(transcript.current_text).to eq('')

    end
  end
end