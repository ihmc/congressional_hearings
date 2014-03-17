require_relative 'transcript'
module PoliInformatics
  module CongressionalHearing
    def utterances(source)
      transcript = Transcript.new
      source.gsub!(/\[.*?\]/m,'')
      source.gsub!(/<.*?>/m,'')
      source.lines.each do |line|
        break if line.strip == 'A P P E N D I X'
        transcript.ingest line
      end
      transcript.records
    end
  end
end