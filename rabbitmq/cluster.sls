{% set master = salt["pillar.get"]("rabbitmq:cluster:master", "localhost")  %}
{% set hostname = salt["network.get_hostname"]() %}

# Add all nodes into /etc/hosts
{% for name, ip in salt["pillar.get"]("rabbitmq:cluster:nodes", {}).items() %}
host_{{name}}:
  host.present:
    - name: {{name}}
    - ip: {{ip}}
{% endfor %}

# join to master

rabbitmq@{{hostname}}:
  rabbitmq_cluster.join:
    - name: {{ hostname }}
    - host: {{master}}