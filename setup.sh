#!/bin/bash
minikube addons enable ingress
minikube addons enable metrics-server
helm dep update .
helm upgrade --install aui . -f values.yaml --set ingress.hosts[0].host=git.$(minikube ip).nip.io
