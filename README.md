# Kubernetes-scaling
Helm Chart with services auto-scaling

# Perform tests with Apache Jmeter

Remember to properly set or replace variables in following steps

0. Install and run Jmeter Operator: https://github.com/kubernauts/jmeter-operator

0. Ensure that proper data source is created in Grafana

    ```bash
    kubectl -n $namespace exec -it $grafana_pod -- curl 'http://admin:admin@127.0.0.1:3000/api/datasources' -X POST -H 'Content-Type: application/json;charset=UTF-8' --data-binary '{"name":"jmeterdb","type":"influxdb","url":"http://$influxdb_service:8086","access":"proxy","isDefault":true,"database":"jmeter","user":"admin","password":"admin"}'

    # namespace - namespace that Jmeter instances are run in
    # grafana_pod - name of grafana pod
    # influxdb_service - name of the influxdb service
    ```

0. Copy test plan to Jmeter master

    ```bash
    kubectl -n $namespace cp tests/test-homepages.jmx "$master_pod:/$test_name"

    # namespace - namespace that Jmeter instances are run in
    # master_pod - name of master pod
    # test_name - name of the test plan in pod filesystem
    ```
0. Execute test plan

    ```bash
    kubectl -n $namespace exec -it $master_pod -- /bin/bash /load_test $test_name
    ```

0. Inspect the logs from the test execution and check Grafana dashboard to see the results (Remember to import GrafanaJMeterTemplate.json from jmeter-operator repository).

    You can reach Grafana by checking ip of your cluster node, on minikube type:
    ```bash
    node_ip = minikube ip
    ```
    Check the node port in description of Grafana service:
    ```bash
    kubectl describe svc $grafana_service -n $namespace
    ```
    Enter Grafana dashboards: `http:$node_ip:$node_port`
