import threading
import urllib.request

path = './storage/downloads/pictures/'


def download_file(url, path, new_name):
    urllib.request.urlretrieve(url, path+str(new_name)+'.jpg')


def main():
    count = 0

    streads = []
    with open('tes.txt', 'r') as f:
        for url in f.readlines():

            print('The {}'.format(count))
            t = threading.Thread(target=download_file,
                                 args=(url.strip(), path, count))
            streads.append(t)
            count += 1
            if count % 20 == 0:
                for i in range(20):
                    streads[i].start()

                for i in range(20):
                    streads[i].join()

                streads = []


if __name__ == '__main__':
    main()
