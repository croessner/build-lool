#!/bin/bash
#
# Get the required sources.
#
# Copyright (C) 2017-2018 Rainer Emrich, <rainer@emrich-ebersheim.de>
#
# This file is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; see the file LICENSE.  If not see
# <http://www.gnu.org/licenses/>.
#

get_sources () {

	echo
	echo "#######################################################################################"
	echo "#"
	echo "# Get the required source packages."
	echo "#"
	echo "#######################################################################################"
	echo

	cd ${SRC_DIR}/poco
	POCO_RELEASE=$(echo ${POCO_VERSION} | sed 's/p.//')
	if [ ! -f "poco-${POCO_VERSION}-all.tar.gz" ] ; then wget https://pocoproject.org/releases/poco-${POCO_RELEASE}/poco-${POCO_VERSION}-all.tar.gz ; fi

	cd ${SRC_DIR}/core
	if [ ! -f "${LOC_VERSION}.tar.gz" ] ; then wget https://github.com/LibreOffice/core/archive/${LOC_VERSION}.tar.gz ; fi

	cd ${SRC_DIR}/online
	if [ ! -f "${LOOL_VERSION}.tar.gz" ] ; then wget https://github.com/LibreOffice/online/archive/${LOOL_VERSION}.tar.gz ; fi

	case ${DIST_ID} in
	Ubuntu)
		case ${DIST_RELEASE} in
		18.04)
			case ${LOC_VERSION} in
			libreoffice-6.0.*)
				cd ${SRC_DIR}/${DIST_ID}/${DIST_RELEASE}
				if [ ! -d "libreoffice-6.0" ] ; then
					git clone -b ubuntu-bionic-6.0 https://git.launchpad.net/~libreoffice/ubuntu/+source/libreoffice libreoffice-6.0
				else
					cd libreoffice-6.0
					git pull --all
				fi
				;;
			*)
				;;
			esac
			;;
		*)
			;;
		esac
		;;
	*)
		;;
	esac

	cd ${START_DIR}

	echo
	echo "#######################################################################################"
	echo "#"
	echo "# Getting the required source packages finished."
	echo "#"
	echo "#######################################################################################"
	echo

}
