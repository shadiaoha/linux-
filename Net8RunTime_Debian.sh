#!/bin/bash

# 一键安装net8.0运行时脚本,支持Debian/Ubuntu 和 CentOS

# 检查是否是root用户
if [ "$EUID" -ne 0 ]; then
    echo -e "\033[31m请以root用户身份运行此脚本.\033[0m"
    exit 1
fi

# 检查是否已经安装了ASP.NET Core运行时
if dotnet --list-runtimes | grep -q "Microsoft.AspNetCore.App 8.0"; then
    echo -e "\033[32mASP.NET Core runtime 8.0 已经安装过了,不需再安装.\033[0m"
    exit 0
fi

# 检查系统类型并设置包管理工具
if [ -f /etc/debian_version ]; then
    PACKAGE_MANAGER="apt-get"
    PACKAGE_UPDATE="apt-get update"
    PACKAGE_INSTALL="apt-get install -y"
    PACKAGE_URL="https://packages.microsoft.com/config/debian/12/packages-microsoft-prod.deb"
    PACKAGE_FILE="packages-microsoft-prod.deb"
    INSTALL_CMD="dpkg -i"
elif [ -f /etc/redhat-release ]; then
    PACKAGE_MANAGER="yum"
    PACKAGE_UPDATE="yum update -y"
    PACKAGE_INSTALL="yum install -y"
    PACKAGE_URL="https://packages.microsoft.com/config/rhel/7/packages-microsoft-prod.rpm"
    PACKAGE_FILE="packages-microsoft-prod.rpm"
    INSTALL_CMD="rpm -Uvh"
else
    echo -e "\033[31m不支持的操作系统.\033[0m"
    exit 1
fi

# 1. 添加Microsoft包存储库
echo "Adding Microsoft package repository..."
wget $PACKAGE_URL -O $PACKAGE_FILE
sudo $INSTALL_CMD $PACKAGE_FILE

# 2. 更新包索引
echo "Updating package index..."
sudo $PACKAGE_UPDATE

# 3. 安装ASP.NET Core运行时
echo "Installing ASP.NET Core runtime..."
sudo $PACKAGE_INSTALL aspnetcore-runtime-8.0

# 4. 验证安装
echo "Verifying installation..."
if dotnet --list-runtimes | grep -q "Microsoft.AspNetCore.App 8.0"; then
    echo -e "\033[32mASP.NET Core runtime 8.0 安装成功.\033[0m"
else
    echo -e "\033[31mASP.NET Core runtime 8.0 安装失败.\033[0m"
    exit 1
fi
