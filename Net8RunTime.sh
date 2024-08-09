#!/bin/bash

#一键安装net8.0运行时脚本

# 检查是否是root用户
if [ "$EUID" -ne 0 ]; then
    echo "请以root用户身份运行此脚本."
    exit 1
fi

# 检查是否已经安装了ASP.NET Core运行时
if dotnet --list-runtimes | grep -q "Microsoft.AspNetCore.App 8.0"; then
    echo "ASP.NET Core runtime 8.0 已经安装过了,不需再安装."
    exit 0
fi

# 1. 添加Microsoft包存储库
echo "Adding Microsoft package repository..."
wget https://packages.microsoft.com/config/debian/12/packages-microsoft-prod.deb -O packages-microsoft-prod.deb
sudo dpkg -i packages-microsoft-prod.deb

# 2. 更新包索引
echo "Updating package index..."
sudo apt-get update

# 3. 安装ASP.NET Core运行时
echo "Installing ASP.NET Core runtime..."
sudo apt-get install -y aspnetcore-runtime-8.0

# 4. 验证安装
echo "Verifying installation..."
dotnet --info
