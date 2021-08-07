#!/usr/bin/env bash

##判断 JDC类型
if [ $JDC = cdle ]; then
    mkdir -p /ql/docker/xdd
    echo "下载最新XDD压缩包"
    curl -o /ql/docker/xdd/xdd.tar.gz https://raw.githubusercontent.com/vay1314/qinglong-v/master/docker/cdle-jdc/xdd.tar.gz
    echo "解压XDD压缩包"
    tar -zxf /ql/docker/xdd/xdd.tar.gz JDC -C /ql/docker
    echo "停止正在运行的XDD"
    pm2 stop JDC
    echo "替换XDD"
    mv -f /ql/docker/JDC /ql
    chmod 777 /ql/JDC
    rm -rf /ql/docker/xdd
    echo "重新启动XDD"
    pm2 restart JDC
fi

if [ $JDC = huayu ]; then
    mkdir -p /ql/docker/jdc
    echo "下载最新JDC压缩包"
    curl -o /ql/docker/jdc/jdc.tar.gz https://raw.githubusercontent.com/vay1314/qinglong-v/master/docker/huayu-jdc/jdc.tar.gz
    echo "解压JDC压缩包"
    tar -zxf /ql/docker/jdc/jdc.tar.gz JDC -C /ql/docker
    echo "停止正在运行的JDC"
    pm2 stop JDC
    echo "替换JDC"
    mv -f /ql/docker/JDC /ql
    echo "重新启动JDC"
    pm2 restart JDC
fi

exit 0
