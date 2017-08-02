class CareerGroupJobs
  # Use nokogiri parsing
  require 'nokogiri'
  require 'open-uri'

  def initialize; end

  def call(search)
    jobs = page_scrape(search)
    scrape = jobs.map { |job| job_scrape(job) }
    scrape
  end

  # Scrape the url's of each job on the front page
  def page_scrape(search)
    # Open first page of search
    page = Nokogiri::HTML(open("https://jobonline.thecareersgroup.co.uk/careersgroup/student/Vacancies.aspx?st=#{search}"))
    job_urls = []
    # Loop through each job div on the page
    job_listings = 10
    job_listings.times do |i|
      job = page.css("#ctl00_ContentPlaceHolder1_SearchVacancies1_VacancySummaryUC1_lvVacancies_ctrl#{i}_pnlVacancy")
      link = job.at_css('a')
      job_url = 'https://jobonline.thecareersgroup.co.uk/careersgroup/student/' + link['href']
      job_urls << job_url
    end
    job_urls
  end

  # Scrape the details of each job from an array of URL's
  def job_scrape(url)
    job = {}

    page = Nokogiri::HTML(open(url))

    job_title = page.at_css('.v2_title').text.strip

    details = page.xpath("/html/body/div[@id='gradsIntoCareersWrapper']/div[@id='gradsIntoCareersContent']/div[@id='gradsIntoCareersCenter']/div[@id='centerContent']/form[@id='aspnetForm']/div[@id='v2_centreCol']/div[@id='ctl00_ContentPlaceHolder1_DisplayVacancyUC1_UpdatePanel1']/div[@id='ctl00_ContentPlaceHolder1_DisplayVacancyUC1_pnlRounded']").text.strip.split("\n")

    # Set the variables for each job detail
    company = ''
    wage = ''
    location = ''
    sector = ''
    hours = ''
    date_posted = ''
    degree_level = ''
    description = ''

    # Parse the exact text for each detail
    details.each_with_index do |line, i|
      stripped = line.strip
      case stripped
      when 'Recruiter:'
        company = details[i + 1].strip
      when 'Salary:'
        wage = details[i + 1].strip
      when 'Location:'
        location = details[i + 1].strip
      when 'Hours:'
        hours = details[i + 1].strip
      when 'Date posted:'
        date_posted = details[i + 1].strip
      when 'Job description'
        description = details[i + 2].strip
      end

      # Create a hash for the job
      job = {
        job_title: job_title,
        company: company,
        wage: wage,
        location: location,
        sector: sector,
        hours: hours,
        date_posted: date_posted,
        degree_level: degree_level,
        description: description
      }
    end

    # Return job
    job
  end
end
