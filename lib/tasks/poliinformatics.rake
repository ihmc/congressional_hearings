require_relative '../poli_informatics/corpus'
require_relative '../poli_informatics/congressional_hearing'
include PoliInformatics::Corpus
include PoliInformatics::CongressionalHearing
require 'yaml'

namespace :poliinformatics do
  task :convert do

    poli_informatics_config = YAML.load_file(File.join('config/poli_informatics.yml'))
    CONGRESSIONAL_HEARINGS_DIR = poli_informatics_config["congressional_hearings"]
    [dodd_frank_files('htm'), monetary_policy_files('htm'), other_files('htm'), tarp_files('htm')].flatten.each do |hearing|
      u = utterances(File.read(hearing))
      File.open("#{hearing}.csv", 'w') { |f|
        u.each { |x|
          f.write("\"#{x[:participant]}\",\"#{x[:text]}\"\n")
        }
      }
    end
  end
end