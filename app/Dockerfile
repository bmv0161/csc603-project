FROM python:slim

ADD webscraper /
RUN pip install -r requirements.txt
CMD ["./wait-for-it.sh", "mydb:3306", "--timeout=300", "--", "python", "WebScraper.py"]
