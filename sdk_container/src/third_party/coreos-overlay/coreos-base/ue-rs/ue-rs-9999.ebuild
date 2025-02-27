# Copyright (c) 2023 Flatcar Maintainers
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CROS_WORKON_PROJECT="flatcar/ue-rs"
CROS_WORKON_LOCALNAME="ue-rs"
CROS_WORKON_REPO="https://github.com"

if [[ ${PV} == 9999 ]]; then
	KEYWORDS="~amd64 ~arm64"
else
	CROS_WORKON_COMMIT="2d82b700b90ca8d664e0915b26c306f94c4d3483" # trunk
	KEYWORDS="amd64 arm64"
fi

# https://github.com/gentoo/cargo-ebuild
CRATES="
	addr2line-0.21.0
	adler-1.0.2
	aho-corasick-1.0.5
	argh-0.1.12
	argh_derive-0.1.12
	argh_shared-0.1.12
	atty-0.2.14
	autocfg-1.1.0
	backtrace-0.3.69
	base64-0.21.3
	base64ct-1.6.0
	bitflags-1.3.2
	bitflags-2.4.0
	block-buffer-0.10.4
	bstr-1.6.2
	bumpalo-3.13.0
	byteorder-1.4.3
	bytes-1.4.0
	cc-1.0.83
	cfg-if-1.0.0
	const-oid-0.9.5
	core-foundation-0.9.3
	core-foundation-sys-0.8.4
	cpufeatures-0.2.9
	crypto-common-0.1.6
	ct-codecs-1.1.1
	der-0.7.8
	digest-0.10.7
	encoding_rs-0.8.33
	env_logger-0.8.4
	env_logger-0.10.0
	errno-0.3.3
	errno-dragonfly-0.1.2
	fastrand-2.0.0
	fnv-1.0.7
	foreign-types-0.3.2
	foreign-types-shared-0.1.1
	form_urlencoded-1.2.0
	futures-channel-0.3.28
	futures-core-0.3.28
	futures-sink-0.3.28
	futures-task-0.3.28
	futures-util-0.3.28
	generic-array-0.14.7
	getrandom-0.2.10
	gimli-0.28.0
	globset-0.4.13
	h2-0.3.21
	hashbrown-0.12.3
	hermit-abi-0.1.19
	hermit-abi-0.3.2
	http-0.2.9
	http-body-0.4.5
	httparse-1.8.0
	httpdate-1.0.3
	humantime-2.1.0
	hyper-0.14.27
	hyper-tls-0.5.0
	idna-0.4.0
	indexmap-1.9.3
	ipnet-2.8.0
	is-terminal-0.4.9
	itoa-1.0.9
	jetscii-0.5.3
	js-sys-0.3.64
	lazy_static-1.4.0
	libc-0.2.147
	libm-0.2.7
	linux-raw-sys-0.4.5
	lock_api-0.4.10
	log-0.4.20
	memchr-2.6.3
	mime-0.3.17
	miniz_oxide-0.7.1
	mio-0.8.8
	native-tls-0.2.11
	num-bigint-dig-0.8.4
	num-integer-0.1.45
	num-iter-0.1.43
	num-traits-0.2.16
	num_cpus-1.16.0
	object-0.32.1
	once_cell-1.18.0
	openssl-0.10.57
	openssl-macros-0.1.1
	openssl-probe-0.1.5
	openssl-sys-0.9.93
	parking_lot-0.12.1
	parking_lot_core-0.9.8
	pem-rfc7468-0.7.0
	percent-encoding-2.3.0
	pin-project-lite-0.2.13
	pin-utils-0.1.0
	pkcs1-0.7.5
	pkcs8-0.10.2
	pkg-config-0.3.27
	ppv-lite86-0.2.17
	proc-macro2-1.0.66
	protobuf-3.2.0
	protobuf-support-3.2.0
	quote-1.0.33
	rand-0.8.5
	rand_chacha-0.3.1
	rand_core-0.6.4
	redox_syscall-0.3.5
	regex-1.9.5
	regex-automata-0.3.8
	regex-syntax-0.7.5
	reqwest-0.11.20
	rsa-0.9.2
	rustc-demangle-0.1.23
	rustix-0.38.11
	ryu-1.0.15
	schannel-0.1.22
	scopeguard-1.2.0
	security-framework-2.9.2
	security-framework-sys-2.9.1
	serde-1.0.188
	serde_derive-1.0.188
	serde_json-1.0.105
	serde_urlencoded-0.7.1
	sha2-0.10.7
	signal-hook-registry-1.4.1
	signature-2.1.0
	slab-0.4.9
	smallvec-1.11.0
	socket2-0.4.9
	socket2-0.5.3
	spin-0.5.2
	spki-0.7.2
	subtle-2.5.0
	syn-1.0.109
	syn-2.0.31
	tempfile-3.8.0
	termcolor-1.2.0
	thiserror-1.0.48
	thiserror-impl-1.0.48
	tinyvec-1.6.0
	tinyvec_macros-0.1.1
	tokio-1.32.0
	tokio-macros-2.1.0
	tokio-native-tls-0.3.1
	tokio-util-0.7.8
	tower-service-0.3.2
	tracing-0.1.37
	tracing-core-0.1.31
	try-lock-0.2.4
	typenum-1.16.0
	unicode-bidi-0.3.13
	unicode-ident-1.0.11
	unicode-normalization-0.1.22
	url-2.4.1
	uuid-1.4.1
	vcpkg-0.2.15
	version_check-0.9.4
	want-0.3.1
	wasi-0.11.0+wasi-snapshot-preview1
	wasm-bindgen-0.2.87
	wasm-bindgen-backend-0.2.87
	wasm-bindgen-futures-0.4.37
	wasm-bindgen-macro-0.2.87
	wasm-bindgen-macro-support-0.2.87
	wasm-bindgen-shared-0.2.87
	web-sys-0.3.64
	winapi-0.3.9
	winapi-i686-pc-windows-gnu-0.4.0
	winapi-util-0.1.5
	winapi-x86_64-pc-windows-gnu-0.4.0
	windows-sys-0.48.0
	windows-targets-0.48.5
	windows_aarch64_gnullvm-0.48.5
	windows_aarch64_msvc-0.48.5
	windows_i686_gnu-0.48.5
	windows_i686_msvc-0.48.5
	windows_x86_64_gnu-0.48.5
	windows_x86_64_gnullvm-0.48.5
	windows_x86_64_msvc-0.48.5
	winreg-0.50.0
	xmlparser-0.13.5
	zeroize-1.6.0
"

inherit coreos-cargo cros-workon systemd

DESCRIPTION="Prototype Omaha Rust implementation"
HOMEPAGE="https://github.com/flatcar/ue-rs"
SRC_URI="$(cargo_crate_uris)"

LICENSE="Apache-2.0"
SLOT="0"
IUSE="test"

DEPEND="dev-libs/openssl:0="
RDEPEND="
	${DEPEND}
"
BDEPEND=""

src_unpack() {
	cros-workon_src_unpack "$@"
	coreos-cargo_src_unpack "$@"
}

src_compile() {
	cargo_src_compile $(usex test '' '--bin download_sysext') "$@"
}

src_install() {
	cargo_src_install $(usex test '' '--bin download_sysext') "$@"
}
