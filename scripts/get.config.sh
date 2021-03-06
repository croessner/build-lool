#!/bin/bash
#
# Get current configuration.
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

get_config () {

	MY_CONFIG_SCRIPTS="lool-config.sh"
	MISSING_SCRIPTS="#"
	for SCRIPT in ${MY_CONFIG_SCRIPTS} ; do
		if [ ! -f ${CONFIG_DIR}/${SCRIPT} ] ; then
			MISSING_SCRIPTS="${MISSING_SCRIPTS}\n#\t${CONFIG_DIR}/${SCRIPT}"
		fi
	done

	if [ "${MISSING_SCRIPTS}" != "#" ] ; then
		echo
		echo "#######################################################################################"
		echo "#"
		echo "# ERROR: The following configuration scripts are missing:"
		echo -e "${MISSING_SCRIPTS}"
		echo "#"
		echo "#        Please copy from the Example File(s) in the configuration directory"
		echo "#        ${CONFIG_DIR}"
		echo "#        and adjust to your needs."
		echo "#"
		echo "#######################################################################################"
		echo

		exit
	fi

	. ${CONFIG_DIR}/lool-config.sh

	if [[ "${POCO_PREFIX}" == "" ]] ; then export POCO_PREFIX="${LOOL_PREFIX}" ; fi

	export NUM_PROC=$(cat /proc/cpuinfo | grep processor | wc -l)

	export ENABLE_SOURCE_REPOSITORIES_DONE=$(test -f "${STAMP_DIR}/enable_source_repositories_done" && echo "1")
	export UPGRADE_DONE=$(test -f "${STAMP_DIR}/upgrade_done" && echo "1")

	export POCO_PKG=$(test -f "${PKG_DIR}/poco-${POCO_VERSION}.tar.xz" && echo "1")
	export POCO_LAST=$(test -f "${STAMP_DIR}/poco_build" && cat ${STAMP_DIR}/poco_build)
	export POCO_BUILD="0"
	if [[ "${POCO_PKG}" == "1"  &&  "${POCO_LAST}" == "${POCO_VERSION}" ]] ; then export POCO_BUILD="1" ; fi

	export LOC_PKG=$(test -d "${BUILD_DIR}/core-${LOC_VERSION}" && echo "1")
	export LOC_LAST=$(test -f "${STAMP_DIR}/libreoffice_build" && cat ${STAMP_DIR}/libreoffice_build)
	export LIBREOFFICE_BUILD="0"
	if [[ "${LOC_PKG}" == "1" && "${LOC_LAST}" == "${LOC_VERSION}" ]] ; then export LIBREOFFICE_BUILD="1" ; fi

	export LOOL_PKG=$(test -f "${PKG_DIR}/loolwsd-${LOOL_VERSION}.tar.xz" && test -f "${PKG_DIR}/loleaflet-${LOOL_VERSION}.tar.gz" && echo "1")
	export LOOL_LAST=$(test -f "${STAMP_DIR}/online_build" && cat ${STAMP_DIR}/online_build)
	export ONLINE_BUILD="0"
	if [[ "${POCO_BUILD}" == "1" && "${LIBREOFFICE_BUILD}" == "1" && "${LOOL_PKG}" == "1" && "${LOOL_LAST}" == "${LOOL_VERSION}" ]] ; then export ONLINE_BUILD="1" ; fi

	export PACKAGE_NAME="lool-poco-${POCO_VERSION}-core-${LOC_VERSION}-online-${LOOL_VERSION}"
	export PACKAGE_LAST=$(test -f "${STAMP_DIR}/package_build" && cat ${STAMP_DIR}/package_build)
	export PACKAGE_BUILD="0"
	if [[ "${PACKAGE_NAME}" == "${PACKAGE_LAST}" ]] ; then export PACKAGE_BUILD="1" ; fi

}
