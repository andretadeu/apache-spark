#!/bin/bash

keepAlive() {
    while [[ true ]]; do
        sleep 1
    done
}

start() {
    service ssh start
    if [ -n "${MASTER}" ]
    then
        ${SPARK_HOME}/sbin/start-master.sh
    else
        ssh-keyscan -H master >> /root/.ssh/known_hosts

        # Busy waiting in order to be able to connect to Spark master
        SSH_STATUS=$(ssh root@master echo "I am waiting.")
        while [ "${SSH_STATUS}" = "ssh: connect to host master port 22: Connection refused" ]
        do
            sleep 20
            SSH_STATUS=$(ssh root@master echo "I am waiting.")
        done

        SPARK_MASTER_URI="spark://${MASTER_PORT_7077_TCP_ADDR}:${MASTER_PORT_7077_TCP_PORT}"
        ${SPARK_HOME}/sbin/start-slave.sh ${SPARK_MASTER_URI}
    fi
    keepAlive
}

stop() {
    if [ -n "${MASTER}" ]
    then
        ${SPARK_HOME}/sbin/stop-master.sh
    else
        ${SPARK_HOME}/sbin/stop-slave.sh
    fi
    keepAlive
}

case ${1} in
    start)
        start
        ;;
    stop)
        stop
        ;;
    bash)
        /bin/bash -l
        ;;
esac
