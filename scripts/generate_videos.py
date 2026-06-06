import urllib.request
import xml.etree.ElementTree as ET
import json
import re
import html
import random

FEEDS = [
    # Bengali Feeds (ABP)
    "https://bengali.abplive.com/home/feed",
    "https://bengali.abplive.com/kolkata/feed",
    "https://bengali.abplive.com/states/feed",
    # YouTube Bengali
    "https://www.youtube.com/feeds/videos.xml?user=abpanandatv",
    # YouTube Hindi
    "https://www.youtube.com/feeds/videos.xml?user=aajtak",
    "https://www.youtube.com/feeds/videos.xml?user=abpnewstv",
    # YouTube English
    "https://www.youtube.com/feeds/videos.xml?user=indiatoday",
    "https://www.youtube.com/feeds/videos.xml?user=ndtv"
]

def fetch_and_parse_videos():
    videos = []
    seen_urls = set()
    
    # Regex to find [yt]https://youtu.be/...[/yt]
    yt_pattern = re.compile(r'\[yt\](.*?)\[/yt\]')

    ns = {'atom': 'http://www.w3.org/2005/Atom', 'media': 'http://search.yahoo.com/mrss/'}

    for url in FEEDS:
        print(f"Fetching {url} for videos...")
        try:
            req = urllib.request.Request(url, headers={'User-Agent': 'Mozilla/5.0'})
            with urllib.request.urlopen(req) as response:
                xml_data = response.read()
                
            root = ET.fromstring(xml_data)
            
            if 'youtube.com' in url:
                entries = root.findall('atom:entry', ns)
                for entry in entries[:15]: # Get up to 15 from each channel
                    title = entry.find('atom:title', ns).text
                    link = entry.find('atom:link', ns).get('href')
                    youtube_url = link
                    
                    if youtube_url in seen_urls:
                        continue
                        
                    media_group = entry.find('media:group', ns)
                    thumbnail_url = ''
                    if media_group is not None:
                        thumb_elem = media_group.find('media:thumbnail', ns)
                        if thumb_elem is not None:
                            thumbnail_url = thumb_elem.get('url')
                            
                    if not thumbnail_url:
                        video_id = youtube_url.split('v=')[-1]
                        thumbnail_url = f"https://img.youtube.com/vi/{video_id}/hqdefault.jpg"
                        
                    seen_urls.add(youtube_url)
                    videos.append({
                        "title": html.unescape(title),
                        "thumbnail": thumbnail_url,
                        "youtubeUrl": youtube_url
                    })
            else:
                # Find all item elements
                for item in root.findall('.//item'):
                    title = html.unescape(item.findtext('title', '').strip())
                    description = html.unescape(item.findtext('description', ''))
                    
                    # Check for YouTube links in description
                    yt_matches = yt_pattern.findall(description)
                    
                    if not yt_matches:
                        continue
                        
                    youtube_url = yt_matches[0].strip()
                    # Clean up query parameters like ?si= from the youtube url
                    if '?' in youtube_url:
                        youtube_url = youtube_url.split('?')[0]
                    
                    if youtube_url in seen_urls:
                        continue
                    seen_urls.add(youtube_url)
                    
                    # Extract thumbnail if available
                    thumbnail_url = ""
                    media_thumbnail = item.find('{http://search.yahoo.com/mrss/}thumbnail')
                    if media_thumbnail is not None:
                        thumbnail_url = media_thumbnail.get('url', '')
                    
                    # If no thumbnail from RSS, try to get the YouTube default thumbnail
                    if not thumbnail_url:
                        # YouTube URLs can be https://youtu.be/ID or https://www.youtube.com/watch?v=ID
                        video_id = None
                        if 'youtu.be/' in youtube_url:
                            video_id = youtube_url.split('youtu.be/')[1].split('?')[0]
                        elif 'v=' in youtube_url:
                            video_id = youtube_url.split('v=')[1].split('&')[0]
                            
                        if video_id:
                            thumbnail_url = f"https://img.youtube.com/vi/{video_id}/hqdefault.jpg"
                        else:
                            thumbnail_url = f"https://picsum.photos/400/200?random={len(videos)}"
                    
                    videos.append({
                        "title": title,
                        "thumbnail": thumbnail_url,
                        "youtubeUrl": youtube_url
                    })
                
        except Exception as e:
            print(f"Error fetching {url}: {e}")
            
    # Shuffle videos to mix languages
    random.shuffle(videos)
            
    print(f"Total videos extracted: {len(videos)}")
    
    # Save to videos.json
    output_path = 'assets/json/videos.json'
    with open(output_path, 'w', encoding='utf-8') as f:
        json.dump(videos, f, ensure_ascii=False, indent=2)
    print(f"Saved to {output_path}")

if __name__ == "__main__":
    fetch_and_parse_videos()
