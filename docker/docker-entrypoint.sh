#!/bin/bash
set -e

dir_shell=/ql/shell
. $dir_shell/share.sh
link_shell

if [ ! -d "/ql/scripts/node_modules/canvas/" ]; then
echo -e "==========Canvas依赖未安装，首次编译安装可能稍慢，请耐心等待==========\n"
echo -e "==============具体安装时间与机器配置以及网速有关==============\n"
apk add --no-cache build-base g++ cairo-dev pango-dev giflib-dev && cd /ql/scripts && npm install canvas --build-from-source
fi

echo -e "======================1. 检测配置文件========================\n"
fix_config
cp -fv $dir_root/docker/front.conf /etc/nginx/conf.d/front.conf
cp -f $dir_sample/package.json $dir_scripts/package.json
npm_install_2 $dir_scripts
pm2 l >/dev/null 2>&1
echo

echo -e "======================2. 启动nginx========================\n"
nginx -s reload 2>/dev/null || nginx -c /etc/nginx/nginx.conf
echo -e "nginx启动成功...\n"

echo -e "======================3. 启动控制面板========================\n"
if [[ $(pm2 info panel 2>/dev/null) ]]; then
  pm2 reload panel --source-map-support --time
else
  pm2 start $dir_root/build/app.js -n panel --source-map-support --time
fi
echo -e "控制面板启动成功...\n"

echo -e "======================4. 启动定时任务========================\n"
if [[ $(pm2 info schedule 2>/dev/null) ]]; then
  pm2 reload schedule --source-map-support --time
else
  pm2 start $dir_root/build/schedule.js -n schedule --source-map-support --time
fi
echo -e "定时任务启动成功...\n"

if [[ $AutoStartBot == true ]]; then
  echo -e "======================5. 启动bot========================\n"
  ql bot
fi

if [[ $EnableExtraShell == true ]]; then
  echo -e "======================6. 执行自定义脚本========================\n"
  ql extra
fi

echo -e "======================7. 启动JDC========================\n"
if [[ $ENABLE_WEB_JDC == true ]]; then
        pm2 start JDC
        echo -e "JDC面板启动成功...\n"
elif [[ $ENABLE_WEB_JDC == false ]]; then
    echo -e "已设置为不自动启动JDC面板，跳过...\n"
fi

echo -e "############################################################\n"
echo -e "容器启动成功..."
echo -e "\n请先访问5700端口，登录成功面板之后再执行添加定时任务..."
echo -e "\n请先访问5701端口，登录成功面板之后再执行添加扫码任务..."
echo -e "############################################################\n"

crond -f >/dev/null

exec "$@"