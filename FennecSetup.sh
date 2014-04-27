#!/bin/bash

#################################

LOGFILE="/tmp/fennecinstaller.log"
KERNEL=`uname -a`
MACHINE=`uname -m`
INSTALL=0
ROOT='id -u'
WGET='/usr/bin/wget'
#Android Native Development Kit
NDK='http://dl.google.com/android/ndk/android-ndk-r9d-linux-x86.tar.bz2'
NDK64='http://dl.google.com/android/ndk/android-ndk-r9d-linux-x86_64.tar.bz2'
#Android Developement
ADT='http://dl.google.com/android/adt/22.6.2/adt-bundle-linux-x86-20140321.zip'
ADT64='http://dl.google.com/android/adt/22.6.2/adt-bundle-linux-x86_64-20140321.zip'

##################################

function downloadNDKandADT
{
	if [[ "$MACHINE" =~ x86_64 ]]; then
		echo "[+] getting ADT and NDK ( x64 )... "
		wget $NDK64 >> $LOGFILE 2>&1
		wget $ADT64 >> $LOGFILE 2>&1
	else
		echo "[+] getting ADT and NDK ( x86 )... "
		wget $NDK >> $LOGFILE 2>&1
		wget $ADT >> $LOGFILE 2>&1
	fi
	
}


##################################

function install_deps_deb
{
	echo "[+] Installing dependencies for Fennec Developement Environement"
	if [ ROOT != "0" ]; then
		sudo apt-get -y update >> $LOGFILE 2>&1
		sudo apt-get install oracle-java6-installer  mercurial ccache build-dep firefox ant >> $LOGFILE 2>&1
	else
		apt-get -y update >> $LOGFILE 2>&1
		apt-get install oracle-java6-installer  mercurial ccache build-dep firefox ant >> $LOGFILE 2>&1
	fi

	if [[ "$MACHINE" =~ x86_64 ]]; then
		echo "[+] Installing 32 bit libs for 64 machine..."
		if [ ROOT =! "0" ]; then
			sudo apt-get install libc6-i386 lib32stdc++6 lib32gcc1 lib32ncurses5 lib32z1 >> $LOGFILE 2>&1
		else
			apt-get install libc6-i386 lib32stdc++6 lib32gcc1 lib32ncurses5 lib32z1 >> $LOGFILE 2>&1
		fi
	fi

}
##################################

function install_deps_yum
{
	echo "[+] Installing dependencies for Fennec Developement Environement..."
	if [ ROOT != "0" ]; then
		sudo yum update >> $LOGFILE 2>&1
	else
		yum update >> $LOGFILE 2>&1
	fi

	if [[ "$MACHINE" =~ x86_64 ]]; then
		echo "[+] Installing 32 bit libs for 64 machine..."
		if [ ROOT != "0" ]; then
			sudo yum install glibc-devel.i686 ncurses-libs-devel.i686 libstdc++-devel.i686 zlib-devel.i686 >> $LOGFILE 2>&1
		else
			yum install glibc-devel.i686 ncurses-libs-devel.i686 libstdc++-devel.i686 zlib-devel.i686 >> $LOGFILE 2>&1
		fi	
	fi

}
##################################

function check_wget
{
	if [ -e $WGET ]; then
		echo "[+] wget was detected on the system "
	else
		echo "[+] Installing Wget..."

		if [[ "$KERNEL" =~ buntu ]]; then
			if [ ROOT != "0" ]; then
				sudo apt-get install wget >> $LOGFILE 2>&1
			else
				apt-get install wget >> $LOGFILE 2>&1
			fi
		
		elif [[ "$KERNEL" =~ Debian ]]; then
			if [ ROOT != "0" ]; then
				sudo apt-get install wget >> $LOGFILE 2>&1
			else
				apt-get install wget >> $LOGFILE 2>&1
			fi

		elif [[ "$KERNEL" =~ fedora ]]; then
			if [ ROOT != "0" ]; then
				sudo yum install wget
			else
				yum install wget
			fi
		fi
			
	fi
}

###################################

function usage
{
	echo "Script for installing Fennec Developement Environement"
	echo "By Taha Ibrahim DRAIDIA  @ibrahim_draidia"
	echo "version 1.0"
	echo " "
	echo "-i	:Install Fennec Developement Environement"
	echo "-r	:Remove Fennec Developement Environement"
	echo "-h	:This help message"	
}

###################################

function remove_fennec_env
{
	echo "removing Fennec Env working on it"
}


########### MAIN ##################

[[ ! $1 ]] && { usage; exit 0; }

while getopts "irp:h" options; do
	case $options in
		i ) INSTALL=1;;
		h ) usage;;
		r ) remove_fennec_env;;
		\?) usage
		exit 1;;
		* ) usage
		exit 1;;

	esac
done

if [ $INSTALL -eq 1 ]; then
	if [[ "$KERNEL" =~ ubuntu ]]; then
		install_deps_deb
	elif [[ "$KERNEL" =~ fedora ]]; then
		install_deps_yum
	fi
	check_wget
	downloadNDKandADT
fi
