#!/bin/bash

/usr/bin/ssh-keygen -A
/usr/sbin/sshd -D &
. /etc/profile.d/pbench-agent.sh
mkdir -p /var/lib/pbench-agent/tools-default
cp /root/.ssh/id_rsa /opt/pbench-agent/id_rsa
. /opt/pbench-agent/profile

# Set pbench-server and port in the config
sed -i "/^pbench_results_redirector/c pbench_results_redirector = ${PBENCH_SERVER}" /opt/pbench-agent/config/pbench-agent.cfg
sed -i "/^pbench_web_server/c pbench_web_server = ${PBENCH_SERVER}"  /opt/pbench-agent/config/pbench-agent.cfg
#sed -i "/^ssh_opts/c ssh_opts = -o StrictHostKeyChecking=no -p 2022" /opt/pbench-agent/config/pbench-agent.cfg
#sed -i "/^scp_opts/c scp_opts = -o StrictHostKeyChecking=no -P 2022" /opt/pbench-agent/config/pbench-agent.cfg

# Set ansible ssh port
sed -i "/^#remote_port/c remote_port = 2022" /etc/ansible/ansible.cfg

set -x 
# Setup tooling
if [[ $JOB == "tooling" ]]; then
	# Set pbench-server in the config
	#sed -i "/^pbench_results_redirector/c pbench_results_redirector = ${PBENCH_SERVER}" /opt/pbench-agent/config/pbench-agent.cfg
	#sed -i "/^pbench_web_server/c pbench_web_server = ${PBENCH_SERVER}"  /opt/pbench-agent/config/pbench-agent.cfg
	cd /root/scale-cd-jobs/build-scripts
	source /opt/pbench-agent/profile; ./setup_tooling.sh ${TOOLING_INVENTORY} "${OPENSHIFT_INVENTORY}" ${CONTAINERIZED} ${REGISTER_ALL_NODES}
elif [[ $JOB == "nodevertical" ]]; then
	cd /root/scale-cd-jobs/build-scripts
	source /opt/pbench-agent/profile; ./nodevertical.sh $SETUP_PBENCH $CONTAINERIZED $CLEAR_RESULTS $MOVE_RESULTS $TOOLING_INVENTORY $ENVIRONMENT
elif [[ $JOB == "mastervertical" ]]; then
	cd /root/scale-cd-jobs/build-scripts
	source /opt/pbench-agent/profile; ./mastervert.sh.python $SETUP_PBENCH $CONTAINERIZED $CLEAR_RESULTS $MOVE_RESULTS $TOOLING_INVENTORY $FIRST_RUN_PROJECTS $SECOND_RUN_PROJECTS $THIRD_RUN_PROJECTS
elif [[ $JOB == "podvertical" ]]; then
	cd /root/scale-cd-jobs/build-scripts
	source /opt/pbench-agent/profile; ./podvertical.sh $SETUP_PBENCH $CONTAINERIZED $CLEAR_RESULTS $MOVE_RESULTS $TOOLING_INVENTORY $PODS $ITERATIONS
elif [[ $JOB == "ns_per_cluster" ]]; then
	source /opt/pbench-agent/profile; ./cluster_limits_ns.sh.python $SETUP_PBENCH $CONTAINERIZED $CLEAR_RESULTS $MOVE_RESULTS $TOOLING_INVENTORY $FIRST_RUN_PROJECTS $SECOND_RUN_PROJECTS $THIRD_RUN_PROJECTS
elif [[ $JOB == "deployments_per_cluster" ]]; then
	source /opt/pbench-agent/profile; ./cluster_limits_deployments_per_ns.sh $SETUP_PBENCH $CONTAINERIZED $CLEAR_RESULTS $MOVE_RESULTS $TOOLING_INVENTORY $DEPLOYMENTS
elif [[ $JOB == "test" ]]; then
	sleep 10000
fi
