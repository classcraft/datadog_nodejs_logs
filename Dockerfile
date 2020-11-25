FROM meteor/ubuntu:20160830T182201Z_0f378f5

RUN apt-get update && \
    apt-get install -y jq xz-utils apt-transport-https daemontools nodejs && \
    sh -c "echo 'deb https://apt.datadoghq.com/ stable 7' > /etc/apt/sources.list.d/datadog.list" && \
    apt-key adv --recv-keys --keyserver hkp://keyserver.ubuntu.com:80 A2923DFF56EDA6E76E55E492D3A80E30382E94DE && \
    apt-get update && \
    apt-get install datadog-agent && \
    sh -c "sed 's/# site:.*/site: datadoghq.com/' /etc/datadog-agent/datadog.yaml.example > /etc/datadog-agent/datadog.yaml" && \
    sh -c "sed -i 's/# logs_enabled:.*/logs_enabled: true/' /etc/datadog-agent/datadog.yaml" && \
    sh -c "sed -i 's/# log_level:.*/log_level: DEBUG/' /etc/datadog-agent/datadog.yaml" && \
    rm -rf /var/lib/apt/lists/*

ADD ./app /app
RUN mkdir /etc/datadog-agent/conf.d/nodejs.d && \
    mv /app/nodejs_conf.yaml /etc/datadog-agent/conf.d/nodejs.d/conf.yaml

CMD ["/app/run.sh"]
