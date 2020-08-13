task scrape: :environment do
  require 'open-uri'

  URL_BASIC = 'https://www.topcv.vn/viec-lam-tot-nhat'

  doc_basic = Nokogiri::HTML(open(URL_BASIC))

  pages = doc_basic.search('ul.pagination > li').count - 2

  (1..pages).each do |i|
    URL = "https://www.topcv.vn/viec-lam-tot-nhat?page=#{i}"
    doc = Nokogiri::HTML(open(URL))
    postings = doc.search('div.result-job-hover')

    postings.each do |p|
      job_title = remove_n_string(p.search('div > div > h4.job-title > a > span.bold.transform-job-title').text)
      url = remove_n_string(p.search('div > div > h4.job-title > a')[0]['href'])
      company = remove_n_string(p.search('div > div > div.row-company').text)
      location = remove_n_string(p.search('div > div > div#row-result-info-job > div.address')[0].text)

      # skip persisting job if it already exists in db
      if Job.where(title: job_title, location: location, company: company).count <= 0
        Job.create(
          title: job_title,
          location: location,
          company: company,
          url: url
        )
        puts 'Added: ' + (job_title ? job_title : '')
      else
        puts 'Skipped: ' + (job_title ? job_title : '')
      end
    end
  end
end

def remove_n_string string
  string.gsub("\n","")
end
