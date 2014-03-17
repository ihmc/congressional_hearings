
module PoliInformatics
  module Corpus
    def dodd_frank_files(ext='csv')
      transcripts = File.join("#{CONGRESSIONAL_HEARINGS_DIR}/Dodd-Frank", "**", "*.#{ext}")
      Dir.glob(transcripts)
    end

    def monetary_policy_files(ext='csv')
      transcripts = File.join("#{CONGRESSIONAL_HEARINGS_DIR}/MonetaryPolicy", "**", "*.#{ext}")
      Dir.glob(transcripts)
    end

    def other_files(ext='csv')
      transcripts = File.join("#{CONGRESSIONAL_HEARINGS_DIR}/Other", "**", "*.#{ext}")
      Dir.glob(transcripts)
    end

    def tarp_files(ext='csv')
      transcripts = File.join("#{CONGRESSIONAL_HEARINGS_DIR}/TARP", "**", "*.#{ext}")
      Dir.glob(transcripts)
    end

    def hearing_title(file)
      begin
        File.basename(file, '.csv')
      rescue Exception => e
        Rails.logger.error "Something wrong with #{file}: #{e}"
      end
    end
  end
end