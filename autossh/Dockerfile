ARG BASE_IMAGE

FROM ${BASE_IMAGE}

ENV \
	USER=autossh \
	GROUP=autossh \
	UID=1000 \
	GID=1000

RUN apk add --no-cache autossh dumb-init

RUN set -eux \
	&& addgroup -g ${GID} ${GROUP} \
	&& adduser -h /home/${USER} -s /bin/bash -G ${GROUP} -D -u ${UID} ${USER} \
	\
	&& mkdir /home/${USER}/.ssh \
	&& chown autossh:autossh /home/${USER}/.ssh \
	&& chmod 0700 /home/${USER}/.ssh

COPY entrypoint.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/entrypoint.sh

USER autossh
CMD ["/usr/local/bin/entrypoint.sh"]