#!/bin/bash
MARIADB_ROOT_PASSWORD=$(kubectl get secret --namespace default aui-mariadb -o jsonpath="{.data.mariadb-root-password}" | base64 --decode)
MARIADB_PASSWORD=$(kubectl get secret --namespace default aui-mariadb -o jsonpath="{.data.mariadb-password}" | base64 --decode)

helm upgrade --install aui . -f values.yaml --set ingress.hosts[0].host=git.$(minikube ip).nip.io --set ingress.hosts[1].host=wordpress.$(minikube ip).nip.io --set wordpress.mariadb.auth.rootPassword=$MARIADB_ROOT_PASSWORD --set wordpress.mariadb.auth.password=$MARIADB_PASSWORD