FROM tiangolo/uwsgi-nginx-flask:python3.6
RUN pip install redis
RUN pip install opencensus
RUN pip install opencensus-ext-azure
RUN pip install opencensus-ext-flask
RUN pip install flask
# The ADD instruction copies new files, directories or remote file URLs from <src> 
# and adds them to the filesystem of the image at the path <dest>
# Example: ADD [--chown=<user>:<group>] <src>... <dest>
ADD /azure-vote /app
