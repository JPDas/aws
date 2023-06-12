FROM ubuntu:20.04

RUN apt-get update && \
    apt-get install -y python3.8 sudo nano vim python3-pip

RUN python3 -m pip install --upgrade pip && \
    pip3 install pandas==1.3.5 extract_msg requests==2.27.1 flask==2.0.2 Werkzeug==2.0.2 rasa==2.8.21 protobuf==3.20.1 scikit-learn

ENV PATH = "/opt/program:${PATH}"

COPY Rasa_app /opt/code
WORKDIR /opt/code
EXPOSE 8080
ENTRYPOINT ["python3", "inference.py"]