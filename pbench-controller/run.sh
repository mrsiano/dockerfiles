#!/bin/bash
. /etc/profile.d/pbench-agent.sh
mkdir -p /var/lib/pbench-agent/tools-default
cp /root/.ssh/id_rsa /opt/pbench-agent/id_rsa
sed -i "/^pbench_results_redirector/c pbench_results_redirector = ${pbench_server}" /opt/pbench-agent/config/pbench-agent.cfg
sed -i "/^pbench_web_server/c pbench_web_server = ${pbench_server}"  /opt/pbench-agent/config/pbench-agent.cfg
pbench-clear-tools
ansible-playbook -i /root/inventory /root/pbench/contrib/ansible/openshift/pbench_register.yml
if [[ "$?" == 0 ]]; then
        echo "-----------------------------------------------------------"
        echo "PBENCH TOOLS REGISTERED SUCCESSFULLY"
        echo "-----------------------------------------------------------"
else
        echo "-----------------------------------------------------------"
        echo "PBENCH REGISTRATION FAILED"
        echo "-----------------------------------------------------------"
fi
if [[ "${clear_results}" == "true" ]] || [[ "${clear_results}" == "True" ]]; then
       pbench-clear-results
fi       
${benchmark}
benchmark_status=$?
if [[ "${move_results}" == "true" ]] || [[ "${move_results}" == "True" ]]; then
        pbench-move-results
fi
if [[ "$benchmark_status" == 0 ]]; then
	echo "-----------------------------------------------------------"
	echo "OCP SCALE TEST COMPLETED"
	echo "-----------------------------------------------------------"
else
	echo "-----------------------------------------------------------"
	echo "OCP SCALE TEST FAILED"
	echo "-----------------------------------------------------------"
fi
