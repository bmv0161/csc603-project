#!/bin/bash

kubectl exec -it $1 chatbot-rasa -n jenkins -- python cmdline_chat.py
