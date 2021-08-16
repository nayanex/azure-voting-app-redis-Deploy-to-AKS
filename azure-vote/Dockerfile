FROM tiangolo/uwsgi-nginx-flask:python3.6
RUN pip install redis
RUN pip install opencensus
RUN pip install opencensus-ext-azure
RUN pip install opencensus-ext-flask
RUN pip install flask
ADD /azure-vote /app
