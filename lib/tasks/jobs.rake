desc "Fetch jobs"
task :fetch_jobs => :environment do

# Task scrapes the front page jobs from https://jobonline.thecareersgroup.co.uk/careersgroup/student
# Enter 'rake fetch_jobs <your search term>' to search for a keyword

  require 'career_group_jobs'

  #Request a search perameter in terminal
  puts "\n Enter search keyword(s): "
  search = STDIN.gets.chomp

  #Notify the start of the page scrape including the search criteria entered
  if search == ''
    puts "Scraping Most Recent Jobs..."
  else
    puts "Scraping Jobs with keyword #{search}..."
  end

  ####MAIN####
  career_group = CareerGroupJobs.new
  #Scrape each job on the first page
  puts career_group.call(search).to_json
  puts "...end of Scrape."

end
