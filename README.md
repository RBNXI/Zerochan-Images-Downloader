# Zerochan Images Downloader
Download images of multiple tags from zerochan using tags provided in a .txt file.
Since Zerochan doesn't have an API, this will use curl and some string management to get the images for you.
It manages the Zerochan rate limit and all the stuff so you just run it and get all your images in a folder after a while.

# How it works?

- Put your tags in tagszerochan.txt like in the example file. Tags separated by space, and last character of the file must be a space.
- Run in the scripts folder: ./zerochandownloader.sh
- The first time it runs, it will download all the images of all the tags you set from a week ago. The next time, it will download them from the last time you ran the script until today. Due to Zerochan limits, it's impossible to download all the images of a tag without time restriction.
- The images will be downloaded to a folder in your Home folder called "zerochandownloaderimages".

# What do I need?
It's a very simple script, so you probably have all the dependencies already, but in case you don't:

- curl
- date
- wget
- md5sum
- sed
