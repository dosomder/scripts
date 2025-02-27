# Distributed under the terms of the GNU General Public License v2

EAPI=7

COREOS_GO_PACKAGE="${GITHUB_URI}"
COREOS_GO_VERSION="go1.19"

inherit coreos-go-depend golang-vcs-snapshot systemd

EGO_PN="github.com/aws/${PN}"
DESCRIPTION="AWS Systems Manager Agent"
HOMEPAGE="https://github.com/aws/amazon-ssm-agent"
LICENSE="Apache-2.0"
SRC_URI="https://${EGO_PN}/archive/${PV}.tar.gz -> ${P}.tar.gz ${EGO_VENDOR_URI}"
SLOT="0"
KEYWORDS="amd64 arm64"

S="${WORKDIR}/${PN}-${PV}/src/${EGO_PN}"

PATCHES=(
)

src_prepare() {
	default
	ln -s ${PWD}/vendor/src/* ${PWD}/vendor/
}

src_compile() {
	go_export

	# this is replication of commands from the vendor makefile
	# but without network activity during build phase
	local GO_LDFLAGS="-s -w -extldflags=-Wl,-z,now,-z,relro,-z,defs"
	export GOPATH="${WORKDIR}/${PN}-${PV}"
	# set agent release version
	BRAZIL_PACKAGE_VERSION=${PV} ${EGO} run ./agent/version/versiongenerator/version-gen.go
	# build all the tools
	${EGO} build -v -ldflags "${GO_LDFLAGS}" -buildmode=pie \
		-o bin/amazon-ssm-agent ./agent || die
	${EGO} build -v -ldflags "${GO_LDFLAGS}" -buildmode=pie \
		-o bin/ssm-cli ./agent/cli-main || die
	${EGO} build -v -ldflags "${GO_LDFLAGS}" -buildmode=pie \
		-o bin/ssm-document-worker ./agent/framework/processor/executer/outofproc/worker || die
	${EGO} build -v -ldflags "${GO_LDFLAGS}" -buildmode=pie \
		-o bin/ssm-session-logger ./agent/session/logging || die
	${EGO} build -v -ldflags "${GO_LDFLAGS}" -buildmode=pie \
		-o bin/ssm-session-worker ./agent/framework/processor/executer/outofproc/sessionworker || die
}

src_install() {
	dobin bin/amazon-ssm-agent bin/ssm-cli bin/ssm-document-worker bin/ssm-session-logger bin/ssm-session-worker
	insinto "/usr/share/amazon/ssm"
	newins seelog_unix.xml seelog.xml.template
	doins amazon-ssm-agent.json.template

	systemd_dounit packaging/linux/amazon-ssm-agent.service
}
