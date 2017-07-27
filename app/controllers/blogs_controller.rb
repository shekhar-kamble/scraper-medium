class BlogsController < ApplicationController
	respond_to :html, :xml, :json
	def crawl(n,blogURL)
    	require 'responders'
    	for i in n..n+9
            doc = Nokogiri::HTML.parse(open(blogURL[i], :ssl_verify_mode => OpenSSL::SSL::VERIFY_NONE))
    		blogObj = doc.css('.postMetaLockup--authorWithBio')
            creator = blogObj.css('div a').text
			details = blogObj.css('div div time').text + " , " 
            blogObj = blogObj.css('div .js-testPostMetaInlineSupplemental .readingTime')
            details = details + blogObj.xpath('//@title').first.value
            blogBody = doc.css('.postArticle-content').css('.section--body').css('.section-content')
            title = blogBody.css('.section-inner').css('h1').text
            blogHTML = blogBody.to_s

            #for tags
            blogObj = doc.css('.tags--postTags').css('li')
            tags = []
            for i in 0..blogObj.size-1
                tags.push(blogObj[i].css('a').text)
            end
            
            #for response
            blogObj = doc.css('.responsesStreamWrapper')
            response = blogObj
            
            #respond with the blog as object
            if Blog.exists?(title)
    			respond_with Blog.find(title)
    		else
    			respond_with Blog.create(:creator => creator,:title => title,:details => details, :bloghtml => blogHTML, :response =>response, :tags => tags)	
    		end
    	end
    end
	
    def scrapByTag
    	require 'openssl'
    	doc = Nokogiri::HTML(open('https://medium.com/search?q='+params[:tag], :ssl_verify_mode => OpenSSL::SSL::VERIFY_NONE))
		blogURL = doc.css('.postArticle--short').css('.postArticle-content a').map { |link| link['href'] }
    	crawl(0,blogURL)
    end

    def scrapMore
        require 'openssl'
        url = 'https://medium.com/search/posts?q='+params[:tag]+'&count=20'
        doc = Nokogiri::HTML.parse(url)
        blogURL = doc.css('.postArticle--short').css('.postArticle-content').css('a')
        crawl(10,blogURL)    
    end

    def home
    end
end
