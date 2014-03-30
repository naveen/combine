#!/usr/bin/ruby

require 'rss/1.0'
require 'rss/2.0'
require 'open-uri'
require 'rss/maker'

sources = {
	#'STREAM'		=> 'http://naveenium.com/stream/feed',
	#'del.icio.us'	=> 'http://del.icio.us/rss/naveen',
	'flickr'		=> 'http://api.flickr.com/services/feeds/photos_public.gne?id=42157920@N00&lang=en-us&format=rss_200',
	'last.fm'		=> 'http://ws.audioscrobbler.com/1.0/user/naveenium/recenttracks.rss',
	'hypem'			=> 'http://hypem.com/feed/loved/naveen/1/feed.xml',
	'twitter'		=> 'http://twitter.com/statuses/user_timeline/5215.rss'
}

output = RSS::Maker.make("2.0") do |m|
	m.channel.title = "naveen's combined feed"
	m.channel.link = "http://naveenium.com"
	m.channel.description = "A combined feed of all (well, most) of my activity online"
	m.items.do_sort = true 

	sources.each do |sourcename, sourcelink|
		content = ""
		open(sourcelink) do |s| content = s.read end
		rss = RSS::Parser.parse(content, false)

		rss.items.each do |item|
			i = m.items.new_item
			i.title = "[" + sourcename + "] " + item.title.strip
			i.link = item.link.strip
			i.description = item.description.strip
			i.date = item.date
		end
	end
end

puts "Content-Type: application/rss+xml;charset=UTF-8\n\n"
puts output

