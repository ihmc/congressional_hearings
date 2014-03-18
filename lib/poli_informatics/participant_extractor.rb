require_relative 'poli_informatics'
module PoliInformatics
  module ParticipantExtractor
    def split(line)
      line.strip!
      return empty unless line =~ /[a-zA-Z]/
      return speaker(line) if line == line.upcase && !line.end_with?('.')
      parts = "#{line} ".split('.')
      return continuation(line) unless line.start_with?(*TITLES) && line.include?('.')
      return continuation(line) if parts.size > 15
      return continuation(line) if line =~ /^[.*]$/
      if line.start_with?(*ABBREVIATED)
        if [1].include?(parts[1].split.size)
          abbreviated_splits(parts)
        else
          continuation(line)
        end
      else
        if [2].include?(parts[0].split.size)
          {participant: parts[0], value: parts[1..-1].join(".").strip}
        else
          continuation(line)
        end
      end
    end

    def detect_participant(line)
      split(line)[:participant]
    end

    private

    def empty
      {participant: '', value: ''}
    end

    def continuation(line)
      {participant: '', value: line.strip}
    end

    def speaker(line)
      {participant: line.strip, value: ''}
    end

    def abbreviated_splits(parts)
      if parts.size > 2
        {participant: parts[0..1].join("."), value: parts[2..-1].join(".").strip}
      else
        {participant: parts[0..1].join("."), value: ""}
      end
    end
  end
end