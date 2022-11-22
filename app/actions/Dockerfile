FROM rasa/rasa-sdk

WORKDIR /app
COPY ./app/actions/. .
USER root
RUN pip install --verbose -r requirements.txt

EXPOSE 5055
USER 1001