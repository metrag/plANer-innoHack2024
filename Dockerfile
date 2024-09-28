FROM jenkins/jenkins:lts

# Установка Docker внутри контейнера (если нужно)
USER root
RUN apt-get update && \
    apt-get install -y apt-transport-https ca-certificates curl software-properties-common && \
    curl -fsSL https://download.docker.com/linux/debian/gpg | apt-key add - && \
    add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/debian $(lsb_release -cs) stable" && \
    apt-get update && \
    apt-get install -y docker-ce-cli && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Вернуться к пользователю Jenkins
USER jenkins

# Скопировать проектные файлы в контейнер Jenkins
COPY planer/ /var/jenkins_home/planer/

# Установим необходимые Jenkins плагины с использованием plugin-installation-manager-tool
COPY plugins.txt /usr/share/jenkins/ref/plugins.txt
RUN jenkins-plugin-cli --plugins < /usr/share/jenkins/ref/plugins.txt
