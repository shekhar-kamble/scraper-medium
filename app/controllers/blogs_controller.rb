class BlogsController < ApplicationController
	def crawl(n,blogURL)
    	for i in n..n+9
            browser = Watir::Browser.start blogURL[i]
            doc = Nokogiri::HTML.parse(browser.html)
    		blogObj = doc.css('.postMetaLockup--authorWithBio')
            creator = blogObj.css('div')[1].css('a').text
			details = blogObj.css('div')[1].css('div')[1].css('time').text + " , " + blogObj.css('div')[1].css('div')[1].css('span')[1].attributes["title"]
            blogBody = doc.css('.postArticle-content').css('.section--body').css('.section-content')
            title = blogBody.css('.section-inner').css('h1').text
            blogHTML = blogBody.to_html

            #for tags
            blogObj = doc.css('.tags--postTags').css('li')
            tags = []
            for i in 0..blogObj.size-1
                tags.push(blogObj[i].css('a').text)
            end
            
            #for response
            response = []
            #loading all the responses
            browser.button(class: 'responsesStream-showOtherResponses').click 
            blogObj = doc.css('.responsesStreamWrapper').css('.streamItem')
            for i in 0..blogObj.size-1
                response.push(blogObj[i].to_html)
            end
            
            #respond with the blog as object
            if Blogs.exists?(title)
    			respond_with Blogs.find(title)
    		else
    			respond_with Blogs.create(:creator => creator,:title => title,:details => details :blogHTML => blogHTML,:tags => tags, :response =>response)	
    		end
    	end
    end
	
    def scrapByTag
    	require 'openssl'
    	require 'watir-webdriver'
        doc = Nokogiri::HTML(open('https://medium.com/search?q='+params[:tag], :ssl_verify_mode => OpenSSL::SSL::VERIFY_NONE))
		blogURL = doc.css('.postArticle--short').css('.postArticle-content').css('a')
    	crawl(0,blogURL)
    end

    def scrapMore
        require 'openssl'
        require 'watir-webdriver'
        url = 'https://medium.com/search/posts?q='+params[:tag]+'&count=20'
        browser = Watir::Browser.start url
        doc = Nokogiri::HTML.parse(browser.html)
        blogURL = doc.css('.postArticle--short').css('.postArticle-content').css('a')
        crawl(10,blogURL)    
    end

    def home
    end
end
