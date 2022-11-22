FROM rasa/rasa-sdk

WORKDIR /app
ADD chatbot/app/actions
USER root
RUN pip install --verbose -r requirements.txt

EXPOSE 5055
USER 1001