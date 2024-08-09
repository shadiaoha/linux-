#!/bin/bash

# 一键安装net8.0运行时脚本

# 检查是否是root用户
if [ "$EUID" -ne 0 ]; then
    echo -e "\033[31m请以root用户身份运行此脚本.\033[0m"
    exit 1
fi

# 检查系统是否是CentOS
if ! grep -q "CentOS" /etc/os-release; then
    echo -e "\033[31m此脚本仅支持CentOS系统.\033[0m"
    exit 1
fi

# 检查是否已经安装了ASP.NET Core运行时
if command -v dotnet &> /dev/null && dotnet --list-runtimes | grep -q "Microsoft.AspNetCore.App 8.0"; then
    echo -e "\033[32mASP.NET Core runtime 8.0 已经安装过了,不需再安装.\033[0m"
    exit 0
fi

# 1. 启用 EPEL 存储库
echo "Enabling EPEL repository..."
sudo yum install epel-release -y

# 2. 安装 devtoolset
echo "Installing devtoolset-9..."
sudo yum install centos-release-scl -y
sudo yum install devtoolset-9 -y

# 3. 启用 devtoolset
echo "Enabling devtoolset-9..."
scl enable devtoolset-9 bash

# 4. 下载并安装 .NET 8.0 运行时
echo "Downloading and installing .NET 8.0 runtime..."
wget https://dot.net/v1/dotnet-install.sh -O dotnet-install.sh
sudo bash dotnet-install.sh --channel 8.0 --runtime aspnetcore

# 5. 验证安装
echo "Verifying installation..."
if ~/.dotnet/dotnet --list-runtimes | grep -q "Microsoft.AspNetCore.App 8.0"; then
    echo -e "\033[32mASP.NET Core runtime 8.0 安装成功.\033[0m"
else
    echo -e "\033[31mASP.NET Core runtime 8.0 安装失败.\033[0m"
    echo "尝试手动安装或检查包存储库配置。"
    exit 1
fi
