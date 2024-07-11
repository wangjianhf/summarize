#!/bin/bash

# 应用名称
APP_NAME=demo-business-gen

# JAR包名称
JAR_NAME=$APP_NAME.jar

# JAR包全路径
JAR_PATH="/app/demo-cloud/jar/"
cd "$JAR_PATH"

# JAVA启动参数-选择Spring配置文件
OPTS_PROFILE="-Dspring.profiles.active=dev"
# JAVA启动参数-内存参数
OPTS_MEM="-Xms256m -Xmx1024m -XX:+HeapDumpOnOutOfMemoryError -XX:HeapDumpPath=/home/devlop/demo-cloud/dump/${APP_NAME}_heapdump.hprof"
# JAVA启动参数-支持远程Debug
OPTS_DEBUG="-Xdebug -Xrunjdwp:transport=dt_socket,address=*:19202,server=y,suspend=n"

# 确保 JAVA_HOME 已定义
if [ -z "${JAVA_HOME}" ]; then
    echo "ERROR: JAVA_HOME未定义，请检查Java环境变量配置"
	exit 1
fi

# JAVA命令
JAVA_BIN=$JAVA_HOME/bin/java

# 检查JAVA_BIN目录是否存在Java二进制文件
if [ ! -x $JAVA_BIN ]; then
    echo "ERROR: java命令不存在，请检查"
    exit 1
fi

start(){
    pid=$(ps -ef|grep ${JAR_NAME} | grep -v grep | awk '{print $2}')

    if [ -n "${pid}" ]; then
        echo "ERROR: ${APP_NAME} 已经正在运行 ! PID: ${pid}"
    else
        echo " INFO: ${APP_NAME} 正在启动中 ... "
		
		set -x # 开启调试模式，显示所有执行的命令
#		nohup $JAVA_BIN $OPTS_MEM $OPTS_DEBUG -jar $JAR_NAME $OPTS_PROFILE> /dev/null 2>&1 & #选择Spring配置文件启动
		nohup $JAVA_BIN $OPTS_MEM $OPTS_DEBUG -jar $JAR_NAME > /dev/null 2>&1 &
		set +x # 关闭调试模式
		
        sleep 2 #防止错误的进程状态监听（启动成功，又马上停止的情况）

        pid=$(ps -ef|grep ${JAR_NAME} | grep -v grep | awk '{print $2}')

        if [ -n "${pid}" ]; then
            echo " INFO: ${APP_NAME} 启动成功! PID: ${pid}"
        else
            echo "ERROR: ${APP_NAME} 启动失败!"
        fi

    fi
}

stop() {
    pid=$(ps -ef|grep ${JAR_NAME} | grep -v grep | awk '{print $2}')
    if [ -n "${pid}" ]; then
        kill -15 "${pid}"  # 尝试发送 SIGTERM
        echo " INFO: ${APP_NAME} 正在停止运行... 进程[PID:${pid}] 优雅下线中..."
        sleep 3  # 给进程一些时间来优雅地停止
        if ps -p "${pid}" > /dev/null; then
            kill -9 "${pid}"  # 如果进程仍然存在，则强制杀死
            echo " INFO: ${APP_NAME} 已经停止运行 ! 进程[PID:${pid}] 优雅下线失败, 已强制停止"
        else
            echo " INFO: ${APP_NAME} 已经停止运行 ! 进程[PID:${pid}] 优雅下线成功"
        fi
    else
        echo " WARN: ${APP_NAME} 未运行!"
    fi
}

restart(){
    stop

    start
}

status(){
    pid=$(ps -ef|grep ${JAR_NAME} | grep -v grep | awk '{print $2}')

    if [ -n "${pid}" ]; then
        echo " INFO: ${APP_NAME} 正在运行! PID: ${pid}"
    else
        echo " WARN: ${APP_NAME} 未运行!"
    fi
}

case "$1" in
    'start')
        start
        ;;
    'stop')
        stop
        ;;
    'restart')
        restart
        ;;
    'status')
        status
        ;;
    *)
        echo "请输入: $0 {start|stop|restart|status} 其中一个参数"
        exit 1
        ;;
esac

exit 0
