#!/bin/bash

. /etc/profile.d/pbench-agent.sh
mkdir -p /var/lib/pbench-agent/tools-default
cp /root/.ssh/id_rsa /opt/pbench-agent/id_rsa

# Set pbench-server in the config
sed -i "/^pbench_results_redirector/c pbench_results_redirector = ${pbench_server}" /opt/pbench-agent/config/pbench-agent.cfg
sed -i "/^pbench_web_server/c pbench_web_server = ${pbench_server}"  /opt/pbench-agent/config/pbench-agent.cfg

# Setup tooling
if [[ $JOB == "TOOLING" ]]; then
	# Set pbench-server in the config
	sed -i "/^pbench_results_redirector/c pbench_results_redirector = ${PBENCH_SERVER}" /opt/pbench-agent/config/pbench-agent.cfg
	sed -i "/^pbench_web_server/c pbench_web_server = ${PBENCH_SERVER}"  /opt/pbench-agent/config/pbench-agent.cfg

	cd /root/scale-cd-jobs/build-scripts
	./setup_tooling.sh ${TOOLING_INVENTORY} "${OPENSHIFT_INVENTORY}" ${CONTAINERIZED} ${REGISTER_ALL_NODES}
	cd /root/pbench/contrib/ansible/openshift
fi
