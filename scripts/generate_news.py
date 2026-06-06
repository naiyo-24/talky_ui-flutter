import urllib.request
import xml.etree.ElementTree as ET
import json
import re
import datetime
import random
import gzip

FEEDS = [
    "https://bengali.abplive.com/home/feed",
    "https://bengali.abplive.com/kolkata/feed",
    "https://bengali.abplive.com/states/feed",
    "https://www.thehindu.com/news/cities/kolkata/feeder/default.rss",
    "https://timesofindia.indiatimes.com/rssfeeds/3908999.cms",
    "https://timesofindia.indiatimes.com/rssfeeds/-2128936835.cms", # TOI India
    "https://www.thehindu.com/business/feeder/default.rss",
    "https://www.thehindu.com/sport/cricket/feeder/default.rss",
    "https://www.oneindia.com/rss/feeds/education-jobs-fb.xml",
    "https://bengali.abplive.com/elections/feed",
    "https://bengali.abplive.com/technology/feed",
    "https://bengali.abplive.com/business/feed",
    "https://bengali.abplive.com/sports/feed",
    "https://bengali.abplive.com/astro/feed",
    "https://bengali.abplive.com/health/feed",
    "https://bengali.abplive.com/banking-and-service/feed",
    "https://rss.app/feeds/v1.1/U5ynR77YrTcPldAX.json",
    "https://rss.app/feeds/v1.1/UNIwrNsTQoqyUfrW.json",
    "https://rss.app/feeds/v1.1/2XGaHxBZPzfbv0Kc.json",
    "https://rss.app/feeds/v1.1/TvK9zHUEN5gIzUAB.json",
    "https://rss.app/feeds/v1.1/TXm53ZRRUbYE1rN8.json",
    "https://rss.sciencedaily.com/top.xml",
    "https://timesofindia.indiatimes.com/rssfeedstopstories.cms",
    "https://news.un.org/feed/subscribe/en/news/all/rss.xml",
    "https://phys.org/rss-feed/"
]

LOCAL_FEEDS = [
    "assets/json/pib_news.xml",
    "assets/json/pib_photos.xml",
    "assets/json/weather.xml"
]

DISTRICTS = [
    'Kolkata', 'Howrah', 'Darjeeling', 'Jalpaiguri', 'Cooch Behar', 
    'Alipurduar', 'Kalimpong', 'Hooghly', 'Purba Medinipur', 
    'Paschim Medinipur', 'Purba Bardhaman', 'Paschim Bardhaman',
    'Bankura', 'Purulia', 'Birbhum', 'Murshidabad', 'Nadia',
    'North 24 Parganas', 'South 24 Parganas', 'Malda', 
    'Uttar Dinajpur', 'Dakshin Dinajpur', 'Jhargram'
]

import html

def clean_html(raw_html):
    if not raw_html:
        return ""
    # Decode HTML entities like &lt; to <
    decoded_html = html.unescape(raw_html)
    # Decode twice just in case it's double encoded
    decoded_html = html.unescape(decoded_html)
    
    # Strip HTML tags
    cleanr = re.compile('<.*?>')
    cleantext = re.sub(cleanr, '', decoded_html)
    
    # Also remove youtube embedding tags if they exist
    cleantext = re.sub(r'\[yt\].*?\[/yt\]', '', cleantext)
    
    return cleantext.strip()

def fetch_and_parse():
    articles = []
    
    # We will use this to prevent duplicates across feeds based on URL
    seen_urls = set()

    for file_path in LOCAL_FEEDS:
        print(f"Reading local feed {file_path}...")
        try:
            with open(file_path, 'r', encoding='utf-8') as f:
                xml_data = f.read()
            # Fix unescaped ampersands in the raw XML before parsing
            xml_data = re.sub(r'&(?![A-Za-z0-9#]+;)', '&amp;', xml_data)
            root = ET.fromstring(xml_data)
            _parse_xml(root, articles, seen_urls, file_path)
        except Exception as e:
            print(f"Error parsing local feed {file_path}: {e}")

    for url in FEEDS:
        print(f"Fetching {url}...")
        try:
            headers = {
                'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36',
                'Accept': 'text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,*/*;q=0.8',
                'Accept-Language': 'en-US,en;q=0.5',
            }
            req = urllib.request.Request(url, headers=headers)
            with urllib.request.urlopen(req) as response:
                feed_data = response.read()
                if response.info().get('Content-Encoding') == 'gzip' or feed_data[:2] == b'\x1f\x8b':
                    feed_data = gzip.decompress(feed_data)
                
            if url.endswith('.json'):
                data = json.loads(feed_data)
                _parse_json(data, articles, seen_urls, url)
            else:
                root = ET.fromstring(feed_data)
                _parse_xml(root, articles, seen_urls, url)
            
        except Exception as e:
            print(f"Error fetching {url}: {e}")

    print(f"Total articles fetched: {len(articles)}")
    
    def is_bengali(text):
        return any('\u0980' <= c <= '\u09FF' for c in text)
        
    articles.sort(key=lambda x: (is_bengali(x['titleBn']), x['publishedAt']), reverse=True)
    
    # Cap to 400
    articles = articles[:400]
    
    # Save to news.json
    output_path = 'assets/json/news.json'
    with open(output_path, 'w', encoding='utf-8') as f:
        json.dump(articles, f, ensure_ascii=False, indent=2)
    print(f"Saved to {output_path}")

def _parse_xml(root, articles, seen_urls, feed_url=""):
    count = 0
    for item in root.findall('.//item'):
        if count >= 10:  # Get up to 10 from each feed to ensure diversity
            break
            
        link = item.findtext('link')
        if not link or link in seen_urls:
            continue
        seen_urls.add(link)
        count += 1
        
        title = item.findtext('title', '')
        description = clean_html(item.findtext('description', ''))
        pubDate = item.findtext('pubDate', '')
        
        # Convert pubDate to ISO 8601
        try:
            dt = datetime.datetime.strptime(pubDate.strip(), '%a, %d %b %Y %H:%M:%S %z')
            iso_date = dt.isoformat()
        except Exception as e:
            iso_date = datetime.datetime.now().isoformat()
        
        raw_category = item.findtext('category', '').strip()
        
        # Override category for specific feeds where we want everything under one umbrella
        if "phys.org" in feed_url or "sciencedaily" in feed_url:
            raw_category = "Science"
        elif "news.un.org" in feed_url:
            raw_category = "INTERNATIONAL"
            
        # Determine fallback category based on feed URL if no category tag
        if not raw_category:
            if "business" in feed_url:
                raw_category = "Business"
            elif "sport" in feed_url:
                raw_category = "Sports"
            elif "india" in feed_url and "timesofindia" in feed_url:
                raw_category = "India"
            elif "weather" in feed_url:
                raw_category = "Weather"
            else:
                raw_category = "West Bengal News"
        
        thumbnail_url = ""
        media_thumbnail = item.find('{http://search.yahoo.com/mrss/}thumbnail')
        if media_thumbnail is not None:
            thumbnail_url = media_thumbnail.get('url', '')
            
        if not thumbnail_url:
            enclosure = item.find('enclosure')
            if enclosure is not None and 'image' in enclosure.get('type', ''):
                thumbnail_url = enclosure.get('url', '')
        
        if not thumbnail_url:
            thumbnail_url = f"https://picsum.photos/400/200?random={len(articles)}"
        
        district = random.choice(DISTRICTS)
        

        cat_mapping = {
            "জেলার": "WEST BENGAL",
            "খবর": "WEST BENGAL",
            "ইন্ডিয়া": "INDIA",
            "খেলার": "SPORTS",
            "বিনোদনের": "ENTERTAINMENT",
            "ব্যবসা-বাণিজ্যের": "BUSINESS",
            "জ্যোতিষ": "ASTRO",
            "খুঁটিনাটি": "SHARE MARKET",
            "West Bengal News": "WEST BENGAL",
            "Kolkata": "WEST BENGAL",
            "India News": "INDIA",
            "India": "INDIA",
            "INTERNATIONAL": "INTERNATIONAL",
            "Business": "BUSINESS",
            "Economy": "BUSINESS",
            "Markets": "BUSINESS",
            "Sports": "SPORTS",
            "Cricket": "SPORTS",
            "Entertainment": "ENTERTAINMENT",
            "Science": "SCIENCE",
            "Weather": "WEATHER",
            "news-updates": "BUSINESS",
            "education-jobs": "EDUCATION",
            "নির্বাচন ২০২৬": "POLITICS",
            "প্রযুক্তি": "TECHNOLOGY",
            "ক্রিকেট": "SPORTS",
            "খেলা": "SPORTS",
            "লাইফস্টাইল-এর": "HEALTH & FITNESS",
            "স্বাস্থ্য": "HEALTH & FITNESS"
        }
        category = cat_mapping.get(raw_category, "MISCELLANEOUS")
        
        article_data = {
            "id": link.strip(),
            "titleBn": title.strip(),
            "titleEn": title.strip(),
            "contentBn": description,
            "contentEn": description,
            "imageUrl": thumbnail_url,
            "category": category,
            "district": district,
            "publishedAt": iso_date
        }
        
        articles.append(article_data)

def _parse_json(data, articles, seen_urls, feed_url=""):
    count = 0
    items = data.get('items', [])
    for item in items:
        if count >= 10:
            break
            
        link = item.get('url', '')
        if not link or link in seen_urls:
            continue
        seen_urls.add(link)
        count += 1
        
        title = item.get('title', '')
        description = clean_html(item.get('content_text', ''))
        pubDate = item.get('date_published', '')
        
        iso_date = pubDate
        if not iso_date:
            iso_date = datetime.datetime.now().isoformat()
            
        if "U5ynR77YrTcPldAX" in feed_url:
            category = "STARTUPS"
        elif "UNIwrNsTQoqyUfrW" in feed_url:
            category = "SHARE MARKET"
        elif "2XGaHxBZPzfbv0Kc" in feed_url:
            category = "TRAVEL"
        elif "TvK9zHUEN5gIzUAB" in feed_url:
            category = "ENTERTAINMENT"
        elif "TXm53ZRRUbYE1rN8" in feed_url:
            category = "FASHION"
        else:
            category = "MISCELLANEOUS"
        
        thumbnail_url = item.get('image', '')
        if not thumbnail_url:
            thumbnail_url = f"https://picsum.photos/400/200?random={len(articles)}"
            
        district = random.choice(DISTRICTS)
        
        article_data = {
            "id": link.strip(),
            "titleBn": title.strip(),
            "titleEn": title.strip(),
            "contentBn": description,
            "contentEn": description,
            "imageUrl": thumbnail_url,
            "category": category,
            "district": district,
            "publishedAt": iso_date
        }
        
        articles.append(article_data)

if __name__ == "__main__":
    fetch_and_parse()
