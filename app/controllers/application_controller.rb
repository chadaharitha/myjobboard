

require "httparty"
class ApplicationController < ActionController::Base
  protect_from_forgery
    include HTTParty


 @domain_url = "http://api.careerbuilder.com"  

  def default_key
    {:DeveloperKey => "WDHQ4VK5ZGXFY0PDH094"}
  end

  def hostsite
    {:HostSite => "UK"}
  end

# ruturns response through object
  def mashup(response)
    puts response.inspect
    case response.code
      when 200
        if response.is_a?(Hash)
          Hashie::Mash.new(response)
        else
          if response.first.is_a?(Hash)
            response.map{|item| Hashie::Mash.new(item)}
          else
            response
          end
        end
    end
  end

  def jobsearchresult(options={})
    mashup(self.class.get("http://api.careerbuilder.com/v1/jobsearch?", :query => options.merge(self.default_key).merge(self.hostsite)))
  end

  def jobdetail(options={})
    mashup(self.class.get("http://api.careerbuilder.com/v1/job?",:query => options.merge(self.default_key)))
  end

 def LoadApplicationFormForJob(options={})
    mashup(self.class.get("http://api.careerbuilder.com/v1/application/blank?",:query => options.merge(self.default_key)))   
  end

   def ApplyForInternalJob(options)
    mashup(self.class.post('http://api.careerbuilder.com/v1/application/submit?', :body => options, :headers => {'Content-type' => 'text/xml'}))
  end
end

