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
        f.write("Speaker,Speech,Type,Comments\n")
        type = 'Speech'
        comments = ''
        u.each { |x|
          if x[:participant] == x[:participant].upcase
            type = 'Statement'
            comments = x[:participant]
            next
          else
            f.write("\"#{x[:participant]}\",\"#{x[:text]}\",#{type},#{comments} \n")
          end
          type = 'Speech'
          comments = ''
        }
      }
    end
  end
end