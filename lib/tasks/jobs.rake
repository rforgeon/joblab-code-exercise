desc "Fetch jobs"
task :fetch_jobs => :environment do

# Task scrapes the front page jobs from https://jobonline.thecareersgroup.co.uk/careersgroup/student
# Enter 'rake fetch_jobs <your search term>' to search for a keyword

  #Use nokogiri parsing
  require 'nokogiri'
  require 'open-uri'

  #Scrape the url's of each job on the front page
  def page_scrape

    #Request a search perameter in terminal
    puts "\n Enter search keyword(s): "
    search = STDIN.gets.chomp

    #Notify the start of the page scrape including the search criteria entered
    if search != ''
      puts "Scraping Jobs with keyword #{search}..."
    else
      puts "Scraping Most Recent Jobs..."
    end

    #Open first page of search
    page = Nokogiri::HTML(open("https://jobonline.thecareersgroup.co.uk/careersgroup/student/Vacancies.aspx?st=#{search}"))
    job_array = []
    #Loop through each job div on the page
    10.times do |i|
      job_array << page.css("#ctl00_ContentPlaceHolder1_SearchVacancies1_VacancySummaryUC1_lvVacancies_ctrl#{i}_pnlVacancy")
    end
    #Return all job urls for the page
    job_url_array =[]
    job_array.each do |item|
      link = item.at_css("a")
      job_url = "https://jobonline.thecareersgroup.co.uk/careersgroup/student/"+link["href"]
      job_url_array << job_url
    end
    return job_url_array
  end

  #Scrape the details of each job from an array of URL's
  def job_scrape(url_array)
    jobs_hash = []

    #Iterate through each job url
    url_array.each do |job_url|
      page = Nokogiri::HTML(open(job_url))

      job_title = page.at_css(".v2_title").text.strip

      details = page.xpath("/html/body/div[@id='gradsIntoCareersWrapper']/div[@id='gradsIntoCareersContent']/div[@id='gradsIntoCareersCenter']/div[@id='centerContent']/form[@id='aspnetForm']/div[@id='v2_centreCol']/div[@id='ctl00_ContentPlaceHolder1_DisplayVacancyUC1_UpdatePanel1']/div[@id='ctl00_ContentPlaceHolder1_DisplayVacancyUC1_pnlRounded']").text.strip.split("\n")

      #Set the variables for each job detail
      company = ''
      wage = ''
      location = ''
      sector = ''
      hours = ''
      date_posted = ''
      degree_level = ''
      description = ''

      #Parse the exact text for each detail
      details.each_with_index do |line,i|
        stripped = line.strip
        case stripped
        when "Recruiter:"
          company = details[i+1].strip
        when "Salary:"
          wage = details[i+1].strip
        when "Location:"
          location = details[i+1].strip
        when "Hours:"
          hours = details[i+1].strip
        when "Date posted:"
          date_posted = details[i+1].strip
        when "Job description"
          description = details[i+2].strip
        else

        end

      end

      #Create a hash for the job
      job = Hash[
        job_title: job_title,
        company: company,
        wage: wage,
        location: location,
        sector: sector,
        hours: hours,
        date_posted: date_posted,
        degree_level: degree_level,
        description: description,
      ]

      #Add the job hash to our jobs_hash array
      jobs_hash << job


    end

    #Return jobs in json format
    return jobs_hash.to_json

  end

  ####MAIN####
  
  #Scrape each job on the first page
  puts job_scrape(page_scrape)
  puts "...end of Scrape."

end
