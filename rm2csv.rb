# Usage 
# ruby rm2csv.rb file_containing_email >> roommate_output.csv
# This program parses file_containing_email and finds all of the answers the person gave.
# The output is one row of a csv file hence appending output to the csv file
# Note there is a bug if the person has line breaks in their multi line answers.

template = File.new('roomiematch.template', 'r')
roomie_file = File.new(ARGV[0])
roomie = []
until roomie_file.eof?
    line = roomie_file.readline.strip
    roomie << line if roomie[-1] != line
end

output = {}
until template.eof?
    line = template.readline.strip
    rline = roomie.shift
    unless line.match(/\${(.+)}/)
        next
    end
    property = $1
    multiline = property.gsub!('ml_', '') != nil
    line.gsub!(/\${(.+)}/, '(.+)')
    rline.match(line)
    data = $1
    if multiline
        next_line = roomie.shift.strip
        until next_line.empty?
            data += " " + next_line
            next_line = roomie.shift.strip
        end
        template.readline
    end
    output[property] = data
end

list = %w(date roommate_fullname roommate_age roommate_email roommate_number whoroommateis sexualorientation location locationpref neararea lookingfor rentpref lengthpref genderpref orientationpref agepref petpref smokerpref doesdishes takeout recycling leftoutitems cleaning social noisepref sopref onspref overnightguestspref familymembervists moneyusage shareconsumables security treatsthings borrowing clothingprefs alcoholcomsumption dietary grooming tvpref education criminalactivity religion dress politics house company finance yourself busy overall whyroomate freetime living sensitive other conflict ideally)

list.each do |key| 
    data = output[key]
    if data.nil?
        print 'Not given'
    elsif data.include?(',')
        print "\"#{output[key]}\""
    else
        print output[key]
    end
    print ','
end
print "\n"
