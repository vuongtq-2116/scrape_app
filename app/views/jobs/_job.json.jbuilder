json.extract! job, :id, :title, :company, :salary, :location, :created_at, :updated_at
json.url job_url(job, format: :json)
