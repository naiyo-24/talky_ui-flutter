import urllib.request
import xml.etree.ElementTree as ET

url = 'https://www.youtube.com/feeds/videos.xml?user=aajtak'
req = urllib.request.Request(url, headers={'User-Agent': 'Mozilla/5.0'})
xml_data = urllib.request.urlopen(req).read()

# Remove xml namespace to make parsing easier
xml_data_str = xml_data.decode('utf-8')
# Try using ET with namespaces
root = ET.fromstring(xml_data)

ns = {'atom': 'http://www.w3.org/2005/Atom', 'media': 'http://search.yahoo.com/mrss/'}

entries = root.findall('atom:entry', ns)
for entry in entries[:2]:
    title = entry.find('atom:title', ns).text
    link = entry.find('atom:link', ns).get('href')
    media_group = entry.find('media:group', ns)
    thumb = ''
    if media_group is not None:
        thumb_elem = media_group.find('media:thumbnail', ns)
        if thumb_elem is not None:
            thumb = thumb_elem.get('url')
    print("Title:", title)
    print("Link:", link)
    print("Thumb:", thumb)
