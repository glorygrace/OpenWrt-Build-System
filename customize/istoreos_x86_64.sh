#!/bin/bash
#=================================================
# 自定义
#=================================================
##########################################添加额外包##########################################
mkdir -p package/linpc

# Git稀疏克隆，只克隆指定目录到本地
function git_sparse_clone() {
 branch="$1" repourl="$2" && shift 2
 git clone --depth=1 -b $branch --single-branch --filter=blob:none --sparse $repourl
 repodir=$(echo $repourl | awk -F '/' '{print $(NF)}')
 cd $repodir && git sparse-checkout set $@
 mv -f $@ ../package/linpc
 cd .. && rm -rf $repodir
}


# 移除冲突包
#rm -rf feeds/packages/net/mosdns
#rm -rf feeds/packages/net/msd_lite
#rm -rf feeds/packages/net/smartdns
#rm -rf feeds/luci/themes/luci-theme-argon
#rm -rf feeds/luci/applications/luci-app-mosdns
#rm -rf feeds/luci/applications/luci-app-netdata
#rm -rf feeds/small8/shadowsocks-rust

#添加 ddns-go
#rm -rf feeds/small8/ddns-go feeds/small8/luci-app-ddns-go
# git clone --depth=1 https://github.com/sirpdboy/luci-app-ddns-go package/ddnsgo

#adguardhome
git_sparse_clone master https://github.com/kenzok8/openwrt-packages luci-app-adguardhome
#git_sparse_clone master https://github.com/kenzok8/openwrt-packages adguardhome

#科学上网
git_sparse_clone master https://github.com/kenzok8/openwrt-packages luci-app-openclash
git_sparse_clone master https://github.com/kenzok8/small luci-app-passwall
#git_sparse_clone master https://github.com/kenzok8/small luci-app-ssr-plus
# 更换插件名称
# sed -i 's/ShadowSocksR Plus+/科学上网/g' feeds/small8/luci-app-ssr-plus/luasrc/controller/shadowsocksr.lua

#ddns-go
git_sparse_clone master https://github.com/kenzok8/openwrt-packages ddns-go
git_sparse_clone master https://github.com/kenzok8/openwrt-packages luci-app-ddns-go

#Netdata
#git_sparse_clone master https://github.com/kenzok8/openwrt-packages netdata
git_sparse_clone master https://github.com/kenzok8/openwrt-packages luci-app-netdata
sed -i 's/"status"/"system"/g' package/linpc/luci-app-netdata/luasrc/controller/*.lua
sed -i 's/"status"/"system"/g' package/linpc/luci-app-netdata/luasrc/model/cgi/*.lua
sed -i 's/admin\/status/admin\/system/g' package/linpc/luci-app-netdata/luasrc/view/netdata/*.htm

#zerotier
#git_sparse_clone master https://github.com/kenzok8/openwrt-packages luci-app-zerotier
#git_sparse_clone master https://github.com/kenzok8/openwrt-packages zerotier

########依赖包########
git_sparse_clone master https://github.com/kenzok8/small brook
git_sparse_clone master https://github.com/kenzok8/small chinadns-ng
git_sparse_clone master https://github.com/kenzok8/small dns2socks
git_sparse_clone master https://github.com/kenzok8/small dns2tcp
git_sparse_clone master https://github.com/kenzok8/small gn
git_sparse_clone master https://github.com/kenzok8/small hysteria
git_sparse_clone master https://github.com/kenzok8/small ipt2socks
git_sparse_clone master https://github.com/kenzok8/small microsocks
git_sparse_clone master https://github.com/kenzok8/small naiveproxy
git_sparse_clone master https://github.com/kenzok8/small pdnsd-alt
git_sparse_clone master https://github.com/kenzok8/small shadowsocksr-libev
git_sparse_clone master https://github.com/kenzok8/small shadowsocks-rust
git_sparse_clone master https://github.com/kenzok8/small simple-obfs
git_sparse_clone master https://github.com/kenzok8/small sing-box
git_sparse_clone master https://github.com/kenzok8/small ssocks
git_sparse_clone master https://github.com/kenzok8/small tcping
git_sparse_clone master https://github.com/kenzok8/small trojan
#git_sparse_clone master https://github.com/kenzok8/small trojan-go
git_sparse_clone master https://github.com/kenzok8/small trojan-plus
git_sparse_clone master https://github.com/kenzok8/small tuic-client
#git_sparse_clone master https://github.com/kenzok8/small v2ray-core
#git_sparse_clone master https://github.com/kenzok8/small v2ray-geodata
#git_sparse_clone master https://github.com/kenzok8/small v2ray-plugin
#git_sparse_clone master https://github.com/kenzok8/small xray-core
#git_sparse_clone master https://github.com/kenzok8/small xray-plugin
git_sparse_clone master https://github.com/kenzok8/small lua-neturl
#git_sparse_clone master https://github.com/kenzok8/small mosdns
git_sparse_clone master https://github.com/kenzok8/small redsocks2
git_sparse_clone master https://github.com/kenzok8/small shadow-tls
#git_sparse_clone master https://github.com/kenzok8/openwrt-packages lua-maxminddb

##########################################其他设置##########################################
# 修改默认登录地址
sed -i 's/192.168.1.1/192.168.137.11/g' ./package/base-files/files/bin/config_generate

# 修改默认登录密码
sed -i 's/$1$5mjCdAB1$Uk1sNbwoqfHxUmzRIeuZK1//g' ./package/base-files/files/etc/shadow

# 更换插件名称
#sed -i 's/("iStore"),/("应用中心"),/g' feeds/store/luci/luci-app-store/luasrc/controller/store.lua

# 修改内核版本
# sed -i 's/KERNEL_PATCHVER:=6.1/KERNEL_PATCHVER:=5.15/g' ./target/linux/x86/Makefile
# sed -i 's/KERNEL_TESTING_PATCHVER:=5.15/KERNEL_TESTING_PATCHVER:=5.10/g' ./target/linux/x86/Makefile

# TTYD 免登录
sed -i 's|/bin/login|/bin/login -f root|g' feeds/packages/utils/ttyd/files/ttyd.config

# 添加项目地址
# cp -f ../customize/diy/istoreos_10_system.js feeds/luci/modules/luci-mod-status/htdocs/luci-static/resources/view/status/include/10_system.js

#修改默认设置
mkdir -p files/etc/uci-defaults
cp  ../customize/diy/default-settings files/etc/uci-defaults/zzz-init-settings


#修改镜像源
#sed -i 's#mirror.iscas.ac.cn/kernel.org#mirrors.edge.kernel.org/pub#' scripts/download.pl



# 修改 Makefile
find package/*/ -maxdepth 2 -path "*/Makefile" | xargs -i sed -i 's/..\/..\/luci.mk/$(TOPDIR)\/feeds\/luci\/luci.mk/g' {}
find package/*/ -maxdepth 2 -path "*/Makefile" | xargs -i sed -i 's/..\/..\/lang\/golang\/golang-package.mk/$(TOPDIR)\/feeds\/packages\/lang\/golang\/golang-package.mk/g' {}
find package/*/ -maxdepth 2 -path "*/Makefile" | xargs -i sed -i 's/PKG_SOURCE_URL:=@GHREPO/PKG_SOURCE_URL:=https:\/\/github.com/g' {}
find package/*/ -maxdepth 2 -path "*/Makefile" | xargs -i sed -i 's/PKG_SOURCE_URL:=@GHCODELOAD/PKG_SOURCE_URL:=https:\/\/codeload.github.com/g' {}

