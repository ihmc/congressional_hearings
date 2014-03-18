require_relative 'participant_extractor'

module PoliInformatics
  class Transcript
    attr_reader :current_participant, :current_text
    include ParticipantExtractor

    def initialize
      @records = []
      @current_text = ""
      @current_participant = ""
    end

    def ingest(line)
      s = split(line)
      p = s[:participant]
      v = s[:value]
      return if @current_participant.empty? && p.empty?
      if !p.empty?
        handle_participant(p, v)
      else
        if !@current_participant.empty?
          return if v.empty?
          if v == v.upcase && @current_participant == @current_participant.upcase
            @current_participant << " #{v}"
          else
            @current_text << " #{v}"
          end
        end
      end
    end

    def records
      [participant: "Speaker", text: "Speech"] +
          @records << {participant: @current_participant, text: @current_text}
    end

    def handle_participant(participant, text)
      if participant.upcase == participant
        return if @current_participant.empty?
        if @current_text.empty?
          @current_participant << " #{participant}"
        else
          @records << {participant: @current_participant, text: @current_text}
          @current_participant = participant
          @current_text = ''
        end
      else
        @records << {participant: @current_participant, text: @current_text} unless @current_participant.empty?
        @current_participant = participant
        @current_text = text
      end
      @current_participant.strip!
    end

  end
end