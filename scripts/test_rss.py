import urllib.request
import xml.etree.ElementTree as ET
import re
import html

urls = [
    'https://news.abplive.com/home/feed',
    'https://www.abplive.com/home/feed',
    'https://timesofindia.indiatimes.com/rssfeeds/3908999.cms',
    'https://timesofindia.indiatimes.com/rssfeeds/-2128936835.cms',
    'https://bengali.abplive.com/sports/feed',
    'https://bengali.abplive.com/entertainment/feed',
    'https://bengali.abplive.com/elections/feed',
    'https://www.hindustantimes.com/feeds/rss/india-news/rssfeed.xml'
]

yt_pattern = re.compile(r'\[yt\](.*?)\[/yt\]')
yt_iframe = re.compile(r'iframe.*?src=[\'"](.*?)[\'"]')
yt_link = re.compile(r'href=[\'"](https?://(?:www\.)?youtube\.com/watch\?v=[a-zA-Z0-9_-]+|https?://youtu\.be/[a-zA-Z0-9_-]+)[\'"]')

for url in urls:
    try:
        req = urllib.request.Request(url, headers={'User-Agent': 'Mozilla/5.0'})
        data = urllib.request.urlopen(req).read().decode('utf-8')
        
        yts = len(yt_pattern.findall(data))
        
        # for iframes check if youtube
        iframes = len([x for x in yt_iframe.findall(data) if 'youtube' in x])
        links = len(yt_link.findall(data))
        
        print(f"{url} yt: {yts}, iframes: {iframes}, links: {links}")
    except Exception as e:
        print(url, e)
