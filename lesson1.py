import requests
import urllib.parse
import bs4
import re


class UrlManager():
    def __init__(self):
        self.new_urls = set()
        self.old_urls = set()

    def add_new_url(self, url):
        if url is None:
            return

        if url not in self.new_urls or url not in self.old_urls:
            self.new_urls.add(url)

    def add_new_urls(self, urls):
        if urls is None or len(urls) == 0:
            return

        for url in urls:
            self.new_urls.add(url)

    def has_new_url(self):
        return len(self.new_urls) != 0

    def get_new_url(self):
        url = self.new_urls.pop()
        self.old_urls.add(url)
        return url


class HtmlDownloader():

    def download(self, url):
        if url is None:
            return None
        # headers = {'user-agent': 'Mozilla/5.0'}
        while True:
            try:
                request = requests.get(url, timeout=100)
                if request.status_code != 200:
                    return None
                break

            except:
                continue
        return request.content.decode('utf-8')


class HtmlParser():
    def _get_new_urls(self, page_url, soup):
        res_urls = set()

        link = soup.find('li', class_='next').find('a')
        if link is None:
            return
        url = urllib.parse.urljoin(page_url, link['href'])

        res_urls.add(url)
        return res_urls

    def _get_new_data(self, page_url, soup):
        data = []
        links = soup.findAll('img', src=re.compile(r'\d{2,}.jpg'))
        for i, link in enumerate(links):
            data.append(link['src'])

        return data

    def parse(self, page_url, html_doc):
        if page_url is None or html_doc is None:
            return

        soup = bs4.BeautifulSoup(html_doc, 'html.parser')
        new_urls = self._get_new_urls(page_url, soup)
        new_data = self._get_new_data(page_url, soup)
        return new_urls, new_data


class OutPuter():
    def __init__(self):
        self.datas = []

    def collect_data(self, data):
        if data is None:
            return
        for dt in data:
            self.datas.append(dt)

    def outputer(self):
        with open('img_html.txt', 'a') as f:
            for data in self.datas:
                f.write(data)
                f.write('\n')
        self.datas = []

    def output_pic(self, path_dir):
        for i, data in enumerate(self.datas):
            urllib.request.urlretrieve(data, path_dir+str(i)+'.jpg')


class SpaiderMain():
    def __init__(self):
        self.url_manager = UrlManager()
        self.html_downloader = HtmlDownloader()
        self.html_parser = HtmlParser()
        self.out_puter = OutPuter()

    def craw(self, url):
        self.url_manager.add_new_url(url)
        count = 0
        while self.url_manager.has_new_url():
            new_url = self.url_manager.get_new_url()
            html_doc = self.html_downloader.download(new_url)

            new_urls, new_data = self.html_parser.parse(new_url, html_doc)

            self.url_manager.add_new_urls(new_urls)
            self.out_puter.collect_data(new_data)

            if count % 3 == 0:
                print('\n', count)
                print(self.out_puter.outputer())
            count += 1

            if count == 100000:
                print('\n ok ...')
                # self.out_puter.output_pic('./storage/downloads/pictures/')
                break


if __name__ == "__main__":
    root_url = 'http://54fv.com/htm/2018/7/5/p05/412060.html'

    root_url = 'http://54fv.com/htm/2018/7/9/p02/412624.html'
    obj_main = SpaiderMain()
    obj_main.craw(root_url)
