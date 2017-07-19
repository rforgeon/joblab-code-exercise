# README

# Joblab Coding Exercise

Please write a Rake task that scrapes job information from the pages on CareersGroup (link below) and outputs the data in a machine readable format of your choice (e.g. JSON, XML, CSV etc.). You should be able to pass a search term to it on the command line (e.g. “marketing”).
https://jobonline.thecareersgroup.co.uk/careersgroup/student/Vacancies.aspx?st=marketing

Each job also has its own page linked from the search list with further informations. Your script may attempt to extract:
* the company
* the job title
* the wage
* the summary/description
* more details

You may choose to include additional information which you think might be useful.
Some data will be harder to get than other and it is next to impossible to get perfect data when scraping. This is a particularly tricky site so don’t spend hours on it! What’s more important is making sure you are pleased with your code quality and have something that works at least minimally.

If you do this inside a git repo and commit as you go along, that would be great to see your process.

## Run the Rake

`cd joblab-test`

`bundle install`

`rake fetch_jobs`
