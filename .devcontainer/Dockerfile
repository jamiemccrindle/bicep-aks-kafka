# Note: You can use any Debian/Ubuntu based image you want. 
FROM mcr.microsoft.com/vscode/devcontainers/base:0-buster

# Options
ARG INSTALL_ZSH="true"
ARG UPGRADE_PACKAGES="false"
ARG USE_MOBY="true"
ARG USERNAME=vscode
ARG USER_UID=1000
ARG USER_GID=$USER_UID
# Install needed packages and setup non-root user. Use a separate RUN statement to add your own dependencies.
COPY library-scripts/*.sh /tmp/library-scripts/
RUN apt-get update \
    # common debian
    && /bin/bash /tmp/library-scripts/common-debian.sh "${INSTALL_ZSH}" "${USERNAME}" "${USER_UID}" "${USER_GID}" "${UPGRADE_PACKAGES}" "true" "true" \
    # az cli
    && /bin/bash /tmp/library-scripts/azcli-debian.sh \
    # bicep
    && curl -Lo /usr/local/bin/bicep https://github.com/Azure/bicep/releases/latest/download/bicep-linux-x64 \
    && chmod +x /usr/local/bin/bicep \
    # docker in docker
    && /bin/bash /tmp/library-scripts/docker-in-docker-debian.sh "true" "${USERNAME}" "${USE_MOBY}" \ 
    # kubectl / helm
    && /bin/bash /tmp/library-scripts/kubectl-helm-debian.sh "latest" "latest" "latest" \
    && mkdir -p /home/${USERNAME}/.minikube \
    && chown ${USERNAME} /home/${USERNAME}/.minikube \
    # install java
    && apt-get install -y default-jdk \
    # cleanup
    && apt-get autoremove -y && apt-get clean -y && rm -rf /var/lib/apt/lists/* /tmp/library-scripts/

RUN cd /tmp && wget https://github.com/derailed/k9s/releases/download/v0.24.14/k9s_Linux_x86_64.tar.gz \
    && tar -xvf k9s_Linux_x86_64.tar.gz \
    && mv k9s /usr/local/bin/ \
    && chmod a+x /usr/local/bin/k9s \
    && rm k9s_Linux_x86_64.tar.gz

VOLUME [ "/var/lib/docker" ]

# Setting the ENTRYPOINT to docker-init.sh will start up the Docker Engine 
# inside the container "overrideCommand": false is set in devcontainer.json. 
# The script will also execute CMD if you need to alter startup behaviors.
ENTRYPOINT [ "/usr/local/share/docker-init.sh" ]
CMD [ "sleep", "infinity" ]

# [Optional] Uncomment this section to install additional OS packages.
# RUN apt-get update && export DEBIAN_FRONTEND=noninteractive \
#     && apt-get -y install --no-install-recommends <your-package-list-here>

USER vscode

RUN az bicep install