### @RandyMcMillan Deliverables:

--

# git setup

<details>
<summary>git config</summary>
<p>

```shell
git config core.ignorecase false
git config --global pull.rebase true
git config --global fetch.prune true
git config --global diff.colorMoved zebra
```
</p>
</details>

<details>
<summary>fork the bitcoin repository</summary>
<p>
### github.com [fork-a-repo](https://docs.github.com/en/get-started/quickstart/fork-a-repo)
### [https://github.com/bitcoin/bitcoin.git](https://github.com/bitcoin/bitcoin.git)
#### to
### [https://github.com/randymcmillan/bitcoin.git](https://github.com/bitcoin/bitcoin.git)
</p>
</details>

<details>
<summary>git setup and clone</summary>
<p>

```

git checkout -b randymcmillan-deliverables # checkout a branch called randymcmillan-deliverables
git remote add upstream https://github.com/bitcoin/bitcoin.git


```
</p>
</details>




<details>
<summary>install libs via [https://brew.sh](https://brew.sh) for macOS</summary>
<p>

```shell
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)" && \
brew install make curl && \
 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/RandyMcMillan/bitcoin/randymcmillan-deliverables/install-qt5.sh)" && \
 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/RandyMcMillan/bitcoin/randymcmillan-deliverables/install-bitcoin-libs.sh)"


```

</p>
</details>

---

<details>
<summary>$ git clone https://github.com/bitcoin/bitcoin</summary>
<p>

```shell

$ git at ₿ in ~
cd ~
git clone https://github.com/bitcoin/bitcoin
cd ~/bitcoin


```

</p>
</details>

---

<details>
<summary>$ git setup and clone</summary>
<p>

```shell

cd bitcoin
git config core.ignorecase false
git config --global pull.rebase true
git config --global fetch.prune true
git config --global diff.colorMoved zebra

git checkout -b randymcmillan-deliverables
git remote add upstream https://github.com/bitcoin/bitcoin.git
git fetch upstream
git rebase upstream/master

git checkout 194b9b8792d9b0798fdb570b79fa51f1d1f5ebaf <— latest release


```
</p>
</details>

---

<details>
<summary>$ ./autogen.sh</summary>
<p>

```shell

$ git at ₿ in ~/bitcoin on tags/v0.21.1 [?]
$ ./autogen.sh
glibtoolize: putting auxiliary files in AC_CONFIG_AUX_DIR, 'build-aux'.
glibtoolize: copying file 'build-aux/ltmain.sh'
glibtoolize: putting macros in AC_CONFIG_MACRO_DIRS, 'build-aux/m4'.
glibtoolize: copying file 'build-aux/m4/libtool.m4'
glibtoolize: copying file 'build-aux/m4/ltoptions.m4'
glibtoolize: copying file 'build-aux/m4/ltsugar.m4'
glibtoolize: copying file 'build-aux/m4/ltversion.m4'
glibtoolize: copying file 'build-aux/m4/lt~obsolete.m4'
configure.ac:45: installing 'build-aux/compile'
configure.ac:28: installing 'build-aux/missing'
Makefile.am: installing 'build-aux/depcomp'
glibtoolize: putting auxiliary files in AC_CONFIG_AUX_DIR, 'build-aux'.
glibtoolize: copying file 'build-aux/ltmain.sh'
glibtoolize: putting macros in AC_CONFIG_MACRO_DIRS, 'build-aux/m4'.
glibtoolize: copying file 'build-aux/m4/libtool.m4'
glibtoolize: copying file 'build-aux/m4/ltoptions.m4'
glibtoolize: copying file 'build-aux/m4/ltsugar.m4'
glibtoolize: copying file 'build-aux/m4/ltversion.m4'
glibtoolize: copying file 'build-aux/m4/lt~obsolete.m4'
configure.ac:29: warning: The macro `AC_PROG_CC_C89' is obsolete.
configure.ac:29: You should run autoupdate.
./lib/autoconf/c.m4:1652: AC_PROG_CC_C89 is expanded from...
configure.ac:29: the top level
configure.ac:15: installing 'build-aux/compile'
configure.ac:9: installing 'build-aux/missing'
Makefile.am: installing 'build-aux/depcomp'
glibtoolize: putting auxiliary files in AC_CONFIG_AUX_DIR, 'build-aux'.
glibtoolize: copying file 'build-aux/ltmain.sh'
glibtoolize: putting macros in AC_CONFIG_MACRO_DIRS, 'build-aux/m4'.
glibtoolize: copying file 'build-aux/m4/libtool.m4'
glibtoolize: copying file 'build-aux/m4/ltoptions.m4'
glibtoolize: copying file 'build-aux/m4/ltsugar.m4'
glibtoolize: copying file 'build-aux/m4/ltversion.m4'
glibtoolize: copying file 'build-aux/m4/lt~obsolete.m4'
configure.ac:754: warning: $as_echo is obsolete; use AS_ECHO(["message"]) instead
lib/m4sugar/m4sh.m4:692: _AS_IF_ELSE is expanded from...
lib/m4sugar/m4sh.m4:699: AS_IF is expanded from...
./lib/autoconf/general.m4:2249: AC_CACHE_VAL is expanded from...
./lib/autoconf/general.m4:2270: AC_CACHE_CHECK is expanded from...
build-aux/m4/ax_pthread.m4:89: AX_PTHREAD is expanded from...
configure.ac:754: the top level
configure.ac:101: installing 'build-aux/compile'
configure.ac:45: installing 'build-aux/missing'
src/Makefile.am: installing 'build-aux/depcomp'


```
</p>
</details>

---

<details>
<summary>$ ./configure</summary>
<p>

```

git at ₿ in ~/bitcoin on tags/v0.21.1 [?]
$ ./configure
checking for pkg-config... /usr/local/bin/pkg-config
checking pkg-config is at least version 0.9.0... yes
checking build system type... x86_64-apple-darwin18.7.0
checking host system type... x86_64-apple-darwin18.7.0
checking for a BSD-compatible install... /usr/local/bin/ginstall -c
checking whether build environment is sane... yes
checking for a race-free mkdir -p... /usr/local/bin/gmkdir -p
checking for gawk... no
checking for mawk... no
checking for nawk... no
checking for awk... awk
checking whether make sets $(MAKE)... yes
checking whether make supports nested variables... yes
checking whether to enable maintainer-specific portions of Makefiles... yes
checking whether make supports nested variables... (cached) yes
checking for g++... g++
checking whether the C++ compiler works... yes
checking for C++ compiler default output file name... a.out
checking for suffix of executables...
checking whether we are cross compiling... no
checking for suffix of object files... o
checking whether the compiler supports GNU C++... yes
checking whether g++ accepts -g... yes
checking for g++ option to enable C++11 features... none needed
checking whether make supports the include directive... yes (GNU style)
checking dependency style of g++... gcc3
checking whether g++ supports C++11 features with -std=c++11... yes
checking whether std::atomic can be used without link library... yes
checking whether the compiler supports GNU Objective C++... yes
checking whether g++ -std=c++11 accepts -g... yes
checking dependency style of g++ -std=c++11... gcc3
checking how to print strings... printf
checking for gcc... gcc
checking whether the compiler supports GNU C... yes
checking whether gcc accepts -g... yes
checking for gcc option to enable C11 features... none needed
checking whether gcc understands -c and -o together... yes
checking dependency style of gcc... gcc3
checking for a sed that does not truncate output... /usr/bin/sed
checking for grep that handles long lines and -e... /usr/bin/grep
checking for egrep... /usr/bin/grep -E
checking for fgrep... /usr/bin/grep -F
checking for ld used by gcc... /Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/ld
checking if the linker (/Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/ld) is GNU ld... no
checking for BSD- or MS-compatible name lister (nm)... /usr/bin/nm -B
checking the name lister (/usr/bin/nm -B) interface... BSD nm
checking whether ln -s works... yes
checking the maximum length of command line arguments... 196608
checking how to convert x86_64-apple-darwin18.7.0 file names to x86_64-apple-darwin18.7.0 format... func_convert_file_noop
checking how to convert x86_64-apple-darwin18.7.0 file names to toolchain format... func_convert_file_noop
checking for /Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/ld option to reload object files... -r
checking for objdump... objdump
checking how to recognize dependent libraries... pass_all
checking for dlltool... no
checking how to associate runtime and link libraries... printf %s\n
checking for ar... ar
checking for archiver @FILE support... no
checking for strip... strip
checking for ranlib... ranlib
checking command to parse /usr/bin/nm -B output from gcc object... ok
checking for sysroot... no
checking for a working dd... /bin/dd
checking how to truncate binary pipes... /bin/dd bs=4096 count=1
checking for mt... no
checking if : is a manifest tool... no
checking for dsymutil... dsymutil
checking for nmedit... nmedit
checking for lipo... lipo
checking for otool... otool
checking for otool64... no
checking for -single_module linker flag... yes
checking for -exported_symbols_list linker flag... yes
checking for -force_load linker flag... yes
checking for stdio.h... yes
checking for stdlib.h... yes
checking for string.h... yes
checking for inttypes.h... yes
checking for stdint.h... yes
checking for strings.h... yes
checking for sys/stat.h... yes
checking for sys/types.h... yes
checking for unistd.h... yes
checking for dlfcn.h... yes
checking for objdir... .libs
checking if gcc supports -fno-rtti -fno-exceptions... yes
checking for gcc option to produce PIC... -fno-common -DPIC
checking if gcc PIC flag -fno-common -DPIC works... yes
checking if gcc static flag -static works... no
checking if gcc supports -c -o file.o... yes
checking if gcc supports -c -o file.o... (cached) yes
checking whether the gcc linker (/Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/ld) supports shared libraries... yes
checking dynamic linker characteristics... darwin18.7.0 dyld
checking how to hardcode library paths into programs... immediate
checking whether stripping libraries is possible... yes
checking if libtool supports shared libraries... yes
checking whether to build shared libraries... yes
checking whether to build static libraries... yes
checking how to run the C++ preprocessor... g++ -std=c++11 -E
checking for ld used by g++ -std=c++11... /Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/ld
checking if the linker (/Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/ld) is GNU ld... no
checking whether the g++ -std=c++11 linker (/Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/ld) supports shared libraries... yes
checking for g++ -std=c++11 option to produce PIC... -fno-common -DPIC
checking if g++ -std=c++11 PIC flag -fno-common -DPIC works... yes
checking if g++ -std=c++11 static flag -static works... no
checking if g++ -std=c++11 supports -c -o file.o... yes
checking if g++ -std=c++11 supports -c -o file.o... (cached) yes
checking whether the g++ -std=c++11 linker (/Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/ld) supports shared libraries... yes
checking dynamic linker characteristics... darwin18.7.0 dyld
checking how to hardcode library paths into programs... immediate
checking for ar... /usr/bin/ar
checking for ranlib... /usr/bin/ranlib
checking for strip... /usr/bin/strip
checking for gcov... /usr/bin/gcov
checking for llvm-cov... no
checking for lcov... no
checking for python3.5... no
checking for python3.6... no
checking for python3.7... no
checking for python3.8... no
checking for python3... /usr/local/bin/python3
checking for genhtml... no
checking for git... /usr/local/bin/git
checking for ccache... no
checking for xgettext... /usr/local/bin/xgettext
checking for hexdump... /usr/bin/hexdump
checking for readelf... no
checking for c++filt... /usr/bin/c++filt
checking for objcopy... no
checking for doxygen... /usr/local/bin/doxygen
checking whether C++ compiler accepts -Werror... yes
checking whether the linker accepts -Wl,-fatal_warnings... yes
checking whether C++ compiler accepts -Wall... yes
checking whether C++ compiler accepts -Wextra... yes
checking whether C++ compiler accepts -Wgnu... yes
checking whether C++ compiler accepts -Wformat -Wformat-security... yes
checking whether C++ compiler accepts -Wvla... yes
checking whether C++ compiler accepts -Wshadow-field... yes
checking whether C++ compiler accepts -Wswitch... yes
checking whether C++ compiler accepts -Wthread-safety... yes
checking whether C++ compiler accepts -Wrange-loop-analysis... yes
checking whether C++ compiler accepts -Wredundant-decls... yes
checking whether C++ compiler accepts -Wunused-variable... yes
checking whether C++ compiler accepts -Wdate-time... yes
checking whether C++ compiler accepts -Wconditional-uninitialized... yes
checking whether C++ compiler accepts -Wsign-compare... yes
checking whether C++ compiler accepts -Wduplicated-branches... no
checking whether C++ compiler accepts -Wduplicated-cond... no
checking whether C++ compiler accepts -Wlogical-op... no
checking whether C++ compiler accepts -Woverloaded-virtual... yes
checking whether C++ compiler accepts -Wsuggest-override... no
checking whether C++ compiler accepts -Wunreachable-code-loop-increment... yes
checking whether C++ compiler accepts -Wunused-parameter... yes
checking whether C++ compiler accepts -Wself-assign... yes
checking whether C++ compiler accepts -Wunused-local-typedef... yes
checking whether C++ compiler accepts -Wdeprecated-register... yes
checking whether C++ compiler accepts -Wimplicit-fallthrough... yes
checking whether C++ compiler accepts -Wdeprecated-copy... no
checking whether C++ compiler accepts -fno-extended-identifiers... no
checking whether C++ compiler accepts -msse4.2... yes
checking whether C++ compiler accepts -msse4.1... yes
checking whether C++ compiler accepts -mavx -mavx2... yes
checking whether C++ compiler accepts -msse4 -msha... yes
checking for SSE4.2 intrinsics... yes
checking for SSE4.1 intrinsics... yes
checking for AVX2 intrinsics... yes
checking for SHA-NI intrinsics... yes
checking whether C++ compiler accepts -march=armv8-a+crc+crypto... no
checking for ARM CRC32 intrinsics... no
checking for rsvg-convert... /usr/local/bin/rsvg-convert
checking for brew... brew
checking whether the linker accepts -Wl,-headerpad_max_install_names... yes
checking whether byte ordering is bigendian... no
checking how to run the C preprocessor... gcc -E
checking whether gcc is Clang... yes
checking whether pthreads work with "-pthread" and "-lpthread"... yes
checking whether Clang needs flag to prevent "argument unused" warning when linking with -pthread... no
checking for joinable pthread attribute... PTHREAD_CREATE_JOINABLE
checking whether more special flags are required for pthreads... no
checking for PTHREAD_PRIO_INHERIT... yes
checking for special C compiler options needed for large files... no
checking for _FILE_OFFSET_BITS value needed for large files... no
checking for g++ -std=c++11 options needed to detect all undeclared functions... none needed
checking whether strerror_r is declared... yes
checking whether strerror_r returns char *... no
checking for __attribute__((visibility))... no
checking for __attribute__((dllexport))... no
checking for __attribute__((dllimport))... no
checking for library containing clock_gettime... none required
checking whether C++ compiler accepts -fPIC... yes
checking whether C++ compiler accepts -fstack-reuse=none... no
checking whether C++ compiler accepts -Wstack-protector... yes
checking whether C++ compiler accepts -fstack-protector-all... yes
checking whether C++ compiler accepts -fcf-protection=full... yes
checking whether C++ compiler accepts -fstack-clash-protection... no
checking whether C++ preprocessor accepts -D_FORTIFY_SOURCE=2... yes
checking whether C++ preprocessor accepts -U_FORTIFY_SOURCE... yes
checking whether the linker accepts -Wl,--dynamicbase... no
checking whether the linker accepts -Wl,--nxcompat... no
checking whether the linker accepts -Wl,--high-entropy-va... no
checking whether the linker accepts -Wl,-z,relro... no
checking whether the linker accepts -Wl,-z,now... no
checking whether the linker accepts -Wl,-z,separate-code... no
checking whether the linker accepts -fPIE -pie... no
checking whether the linker accepts -Wl,-dead_strip... yes
checking whether the linker accepts -Wl,-dead_strip_dylibs... yes
checking whether the linker accepts -Wl,-bind_at_load... yes
checking for endian.h... no
checking for sys/endian.h... no
checking for byteswap.h... no
checking for stdio.h... (cached) yes
checking for stdlib.h... (cached) yes
checking for unistd.h... (cached) yes
checking for strings.h... (cached) yes
checking for sys/types.h... (cached) yes
checking for sys/stat.h... (cached) yes
checking for sys/select.h... yes
checking for sys/prctl.h... no
checking for sys/sysctl.h... yes
checking for vm/vm_param.h... no
checking for sys/vmmeter.h... yes
checking for sys/resources.h... no
checking whether getifaddrs is declared... yes
checking whether ifaddrs funcs can be used without link library... yes
checking whether freeifaddrs is declared... yes
checking whether ifaddrs funcs can be used without link library... yes
checking whether strnlen is declared... yes
checking whether daemon is declared... yes
checking whether le16toh is declared... no
checking whether le32toh is declared... no
checking whether le64toh is declared... no
checking whether htole16 is declared... no
checking whether htole32 is declared... no
checking whether htole64 is declared... no
checking whether be16toh is declared... no
checking whether be32toh is declared... no
checking whether be64toh is declared... no
checking whether htobe16 is declared... no
checking whether htobe32 is declared... no
checking whether htobe64 is declared... no
checking whether bswap_16 is declared... no
checking whether bswap_32 is declared... no
checking whether bswap_64 is declared... no
checking for __builtin_clzl... yes
checking for __builtin_clzll... yes
checking for getmemoryinfo... no
checking for mallopt M_ARENA_MAX... no
checking for posix_fallocate... no
checking for visibility attribute... yes
checking for thread_local support... yes
checking for gmtime_r... yes
checking for Linux getrandom syscall... no
checking for getentropy... no
checking for getentropy via random.h... yes
checking for sysctl... yes
checking for sysctl KERN_ARND... no
checking for if type char equals int8_t... no
checking for fdatasync... no
checking for F_FULLFSYNC... yes
checking for O_CLOEXEC... yes
checking for __builtin_prefetch... yes
checking for _mm_prefetch... yes
checking for strong getauxval support in the system headers... no
checking for weak getauxval support in the compiler... yes
checking for std::system... yes
checking for ::_wsystem... no
checking for Qt5Core >= 5.5.1... yes
checking for Qt5Gui >= 5.5.1... yes
checking for Qt5Widgets >= 5.5.1... yes
checking for Qt5Network >= 5.5.1... yes
checking for Qt5Test >= 5.5.1... yes
checking for Qt5DBus >= 5.5.1... yes
checking for static Qt... no
checking whether -fPIE can be used with this Qt config... yes
checking for moc-qt5... no
checking for moc5... no
checking for moc... /usr/local/Cellar/qt@5/5.15.2/bin/moc
checking for uic-qt5... no
checking for uic5... no
checking for uic... /usr/local/Cellar/qt@5/5.15.2/bin/uic
checking for rcc-qt5... no
checking for rcc5... no
checking for rcc... /usr/local/Cellar/qt@5/5.15.2/bin/rcc
checking for lrelease-qt5... no
checking for lrelease5... no
checking for lrelease... /usr/local/Cellar/qt@5/5.15.2/bin/lrelease
checking for lupdate-qt5... no
checking for lupdate5... no
checking for lupdate... /usr/local/Cellar/qt@5/5.15.2/bin/lupdate
checking whether the linker accepts -framework Foundation -framework ApplicationServices -framework AppKit... yes
checking whether to build Bitcoin Core GUI... yes (Qt5)
checking for sqlite3 >= 3.7.17... yes
checking whether to build wallet with support for sqlite... yes
checking for miniupnpc/miniwget.h... yes
checking for upnpDiscover in -lminiupnpc... yes
checking for miniupnpc/miniupnpc.h... yes
checking for upnpDiscover in -lminiupnpc... (cached) yes
checking for miniupnpc/upnpcommands.h... yes
checking for upnpDiscover in -lminiupnpc... (cached) yes
checking for miniupnpc/upnperrors.h... yes
checking for upnpDiscover in -lminiupnpc... (cached) yes
checking whether miniUPnPc API version is supported... yes
checking for boostlib >= 1.58.0 (105800)... yes
checking whether the Boost::System library is available... yes
checking for exit in -lboost_system... yes
checking whether the Boost::Filesystem library is available... yes
checking for exit in -lboost_filesystem... yes
checking whether the Boost::Thread library is available... yes
checking for exit in -lboost_thread-mt... yes
checking whether the Boost::Unit_Test_Framework library is available... yes
checking for dynamic linked boost test... yes
checking for libevent >= 2.0.21... yes
checking for libevent_pthreads >= 2.0.21... yes
checking for libqrencode... yes
checking for libzmq >= 4... yes
checking for libmultiprocess... no
checking whether to build bitcoind... yes
checking whether to build bitcoin-cli... yes
checking whether to build bitcoin-tx... yes
checking whether to build bitcoin-wallet... yes
checking whether to build libraries... yes
checking if ccache should be used... no
checking if wallet should be enabled... yes
checking whether to build with support for UPnP... yes
checking whether to build with UPnP enabled by default... no
checking whether to build GUI with support for D-Bus... yes
checking whether to build GUI with support for QR codes... yes
checking whether to build test_bitcoin-qt... yes
checking whether to build test_bitcoin... yes
checking whether to reduce exports... no
checking that generated files are newer than configure... done
configure: creating ./config.status
config.status: creating libbitcoinconsensus.pc
config.status: creating Makefile
config.status: creating src/Makefile
config.status: creating doc/man/Makefile
config.status: creating share/setup.nsi
config.status: creating share/qt/Info.plist
config.status: creating test/config.ini
config.status: creating contrib/devtools/split-debug.sh
config.status: creating doc/Doxyfile
config.status: creating src/config/bitcoin-config.h
config.status: executing depfiles commands
config.status: executing libtool commands
=== configuring in src/univalue (/Users/git/bitcoin/src/univalue)
configure: running /bin/sh ./configure --disable-option-checking '--prefix=/usr/local'  '--disable-shared' '--with-pic' '--enable-benchmark=no' '--with-bignum=no' '--enable-module-recovery' '--enable-module-schnorrsig' '--enable-experimental' --cache-file=/dev/null --srcdir=.
checking whether make supports nested variables... yes
checking for a BSD-compatible install... /usr/local/bin/ginstall -c
checking whether build environment is sane... yes
checking for a race-free mkdir -p... /usr/local/bin/gmkdir -p
checking for gawk... no
checking for mawk... no
checking for nawk... no
checking for awk... awk
checking whether make sets $(MAKE)... yes
checking build system type... x86_64-apple-darwin18.7.0
checking host system type... x86_64-apple-darwin18.7.0
checking how to print strings... printf
checking whether make supports the include directive... yes (GNU style)
checking for gcc... gcc
checking whether the C compiler works... yes
checking for C compiler default output file name... a.out
checking for suffix of executables...
checking whether we are cross compiling... no
checking for suffix of object files... o
checking whether the compiler supports GNU C... yes
checking whether gcc accepts -g... yes
checking for gcc option to enable C11 features... none needed
checking whether gcc understands -c and -o together... yes
checking dependency style of gcc... gcc3
checking for a sed that does not truncate output... /usr/bin/sed
checking for grep that handles long lines and -e... /usr/bin/grep
checking for egrep... /usr/bin/grep -E
checking for fgrep... /usr/bin/grep -F
checking for ld used by gcc... /Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/ld
checking if the linker (/Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/ld) is GNU ld... no
checking for BSD- or MS-compatible name lister (nm)... /usr/bin/nm -B
checking the name lister (/usr/bin/nm -B) interface... BSD nm
checking whether ln -s works... yes
checking the maximum length of command line arguments... 196608
checking how to convert x86_64-apple-darwin18.7.0 file names to x86_64-apple-darwin18.7.0 format... func_convert_file_noop
checking how to convert x86_64-apple-darwin18.7.0 file names to toolchain format... func_convert_file_noop
checking for /Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/ld option to reload object files... -r
checking for objdump... objdump
checking how to recognize dependent libraries... pass_all
checking for dlltool... no
checking how to associate runtime and link libraries... printf %s\n
checking for ar... ar
checking for archiver @FILE support... no
checking for strip... strip
checking for ranlib... ranlib
checking command to parse /usr/bin/nm -B output from gcc object... ok
checking for sysroot... no
checking for a working dd... /bin/dd
checking how to truncate binary pipes... /bin/dd bs=4096 count=1
checking for mt... no
checking if : is a manifest tool... no
checking for dsymutil... dsymutil
checking for nmedit... nmedit
checking for lipo... lipo
checking for otool... otool
checking for otool64... no
checking for -single_module linker flag... yes
checking for -exported_symbols_list linker flag... yes
checking for -force_load linker flag... yes
checking for stdio.h... yes
checking for stdlib.h... yes
checking for string.h... yes
checking for inttypes.h... yes
checking for stdint.h... yes
checking for strings.h... yes
checking for sys/stat.h... yes
checking for sys/types.h... yes
checking for unistd.h... yes
checking for dlfcn.h... yes
checking for objdir... .libs
checking if gcc supports -fno-rtti -fno-exceptions... yes
checking for gcc option to produce PIC... -fno-common -DPIC
checking if gcc PIC flag -fno-common -DPIC works... yes
checking if gcc static flag -static works... no
checking if gcc supports -c -o file.o... yes
checking if gcc supports -c -o file.o... (cached) yes
checking whether the gcc linker (/Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/ld) supports shared libraries... yes
checking dynamic linker characteristics... darwin18.7.0 dyld
checking how to hardcode library paths into programs... immediate
checking whether stripping libraries is possible... yes
checking if libtool supports shared libraries... yes
checking whether to build shared libraries... no
checking whether to build static libraries... yes
checking for g++... g++
checking whether the compiler supports GNU C++... yes
checking whether g++ accepts -g... yes
checking for g++ option to enable C++11 features... none needed
checking dependency style of g++... gcc3
checking how to run the C++ preprocessor... g++ -E
checking for ld used by g++... /Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/ld
checking if the linker (/Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/ld) is GNU ld... no
checking whether the g++ linker (/Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/ld) supports shared libraries... yes
checking for g++ option to produce PIC... -fno-common -DPIC
checking if g++ PIC flag -fno-common -DPIC works... yes
checking if g++ static flag -static works... no
checking if g++ supports -c -o file.o... yes
checking if g++ supports -c -o file.o... (cached) yes
checking whether the g++ linker (/Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/ld) supports shared libraries... yes
checking dynamic linker characteristics... darwin18.7.0 dyld
checking how to hardcode library paths into programs... immediate
checking that generated files are newer than configure... done
configure: creating ./config.status
config.status: creating Makefile
config.status: creating pc/libunivalue.pc
config.status: creating pc/libunivalue-uninstalled.pc
config.status: creating univalue-config.h
config.status: univalue-config.h is unchanged
config.status: executing depfiles commands
config.status: executing libtool commands
=== configuring in src/secp256k1 (/Users/git/bitcoin/src/secp256k1)
configure: running /bin/sh ./configure --disable-option-checking '--prefix=/usr/local'  '--disable-shared' '--with-pic' '--enable-benchmark=no' '--with-bignum=no' '--enable-module-recovery' '--enable-module-schnorrsig' '--enable-experimental' --cache-file=/dev/null --srcdir=.
checking build system type... x86_64-apple-darwin18.7.0
checking host system type... x86_64-apple-darwin18.7.0
checking for a BSD-compatible install... /usr/local/bin/ginstall -c
checking whether build environment is sane... yes
checking for a race-free mkdir -p... /usr/local/bin/gmkdir -p
checking for gawk... no
checking for mawk... no
checking for nawk... no
checking for awk... awk
checking whether make sets $(MAKE)... yes
checking whether make supports nested variables... yes
checking how to print strings... printf
checking whether make supports the include directive... yes (GNU style)
checking for gcc... gcc
checking whether the C compiler works... yes
checking for C compiler default output file name... a.out
checking for suffix of executables...
checking whether we are cross compiling... no
checking for suffix of object files... o
checking whether the compiler supports GNU C... yes
checking whether gcc accepts -g... yes
checking for gcc option to enable C11 features... none needed
checking whether gcc understands -c and -o together... rm: conftest.dSYM: is a directory
yes
checking dependency style of gcc... gcc3
checking for a sed that does not truncate output... /usr/bin/sed
checking for grep that handles long lines and -e... /usr/bin/grep
checking for egrep... /usr/bin/grep -E
checking for fgrep... /usr/bin/grep -F
checking for ld used by gcc... /Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/ld
checking if the linker (/Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/ld) is GNU ld... no
checking for BSD- or MS-compatible name lister (nm)... /usr/bin/nm -B
checking the name lister (/usr/bin/nm -B) interface... rm: conftest.dSYM: is a directory
BSD nm
checking whether ln -s works... yes
checking the maximum length of command line arguments... 196608
checking how to convert x86_64-apple-darwin18.7.0 file names to x86_64-apple-darwin18.7.0 format... func_convert_file_noop
checking how to convert x86_64-apple-darwin18.7.0 file names to toolchain format... func_convert_file_noop
checking for /Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/ld option to reload object files... -r
checking for objdump... objdump
checking how to recognize dependent libraries... pass_all
checking for dlltool... no
checking how to associate runtime and link libraries... printf %s\n
checking for ar... ar
checking for archiver @FILE support... rm: conftest.dSYM: is a directory
no
checking for strip... strip
checking for ranlib... ranlib
checking command to parse /usr/bin/nm -B output from gcc object... rm: conftest.dSYM: is a directory
ok
checking for sysroot... no
checking for a working dd... /bin/dd
checking how to truncate binary pipes... /bin/dd bs=4096 count=1
checking for mt... no
checking if : is a manifest tool... no
checking for dsymutil... dsymutil
checking for nmedit... nmedit
checking for lipo... lipo
checking for otool... otool
checking for otool64... no
checking for -single_module linker flag... yes
checking for -exported_symbols_list linker flag... yes
checking for -force_load linker flag... yes
checking for stdio.h... yes
checking for stdlib.h... yes
checking for string.h... yes
checking for inttypes.h... yes
checking for stdint.h... yes
checking for strings.h... yes
checking for sys/stat.h... yes
checking for sys/types.h... yes
checking for unistd.h... yes
checking for dlfcn.h... yes
checking for objdir... .libs
checking if gcc supports -fno-rtti -fno-exceptions... yes
checking for gcc option to produce PIC... -fno-common -DPIC
checking if gcc PIC flag -fno-common -DPIC works... yes
checking if gcc static flag -static works... no
checking if gcc supports -c -o file.o... yes
checking if gcc supports -c -o file.o... (cached) yes
checking whether the gcc linker (/Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/ld) supports shared libraries... yes
checking dynamic linker characteristics... darwin18.7.0 dyld
checking how to hardcode library paths into programs... immediate
checking whether stripping libraries is possible... yes
checking if libtool supports shared libraries... yes
checking whether to build shared libraries... no
checking whether to build static libraries... yes
checking whether make supports nested variables... (cached) yes
checking for pkg-config... /usr/local/bin/pkg-config
checking pkg-config is at least version 0.9.0... yes
checking for ar... /usr/bin/ar
checking for ranlib... /usr/bin/ranlib
checking for strip... /usr/bin/strip
checking how to run the C preprocessor... gcc -E
checking for gcc... gcc
checking whether the compiler supports GNU C... (cached) yes
checking whether gcc accepts -g... yes
checking for gcc option to enable C11 features... (cached) none needed
checking whether gcc understands -c and -o together... (cached) yes
checking dependency style of gcc... (cached) gcc3
checking how to run the C preprocessor... gcc -E
checking dependency style of gcc... gcc3
checking for brew... /usr/local/bin/brew
checking if gcc supports -std=c89 -pedantic -Wall -Wextra -Wcast-align -Wnested-externs -Wshadow -Wstrict-prototypes -Wundef -Wno-unused-function -Wno-long-long -Wno-overlength-strings... yes
checking if gcc supports -fvisibility=hidden... yes
checking for valgrind/memcheck.h... no
checking if native gcc supports -Wall -Wextra -Wno-unused-function... yes
checking for working native compiler: gcc... yes
checking for x86_64 assembly availability... yes
checking for libcrypto... yes
checking for main in -lcrypto... yes
checking for EC functions in libcrypto... yes
configure: ******
configure: WARNING: experimental build
configure: Experimental features do not have stable APIs or properties, and may not be safe for production use.
configure: Building extrakeys module: yes
configure: Building schnorrsig module: yes
configure: ******
checking that generated files are newer than configure... done
configure: creating ./config.status
config.status: creating Makefile
config.status: creating libsecp256k1.pc
config.status: creating src/libsecp256k1-config.h
config.status: executing depfiles commands
config.status: executing libtool commands

Build Options:
  with ecmult precomp     = yes
  with external callbacks = no
  with benchmarks         = no
  with tests              = yes
  with openssl tests      = yes
  with coverage           = no
  module ecdh             = no
  module recovery         = yes
  module extrakeys        = yes
  module schnorrsig       = yes

  asm                     = x86_64
  bignum                  = no
  ecmult window size      = 15
  ecmult gen prec. bits   = 4

  valgrind                = no
  CC                      = gcc
  CFLAGS                  = -O2 -fvisibility=hidden -std=c89 -pedantic -Wall -Wextra -Wcast-align -Wnested-externs -Wshadow -Wstrict-prototypes -Wundef -Wno-unused-function -Wno-long-long -Wno-overlength-strings -W -g
  CPPFLAGS                =
  LDFLAGS                 =


Options used to compile and link:
  boost process = no
  multiprocess  = no
  with wallet   = yes
    with sqlite = yes
  with gui / qt = yes
    with qr     = yes
  with zmq      = yes
  with test     = yes
    with fuzz   = no
  with bench    = yes
  with upnp     = yes
  use asm       = yes
  sanitizers    =
  debug enabled = no
  gprof enabled = no
  werror        = no

  target os     = darwin
  build os      = darwin18.7.0

  CC            = gcc
  CFLAGS        = -pthread -g -O2
  CPPFLAGS      =   -U_FORTIFY_SOURCE -D_FORTIFY_SOURCE=2  -DHAVE_BUILD_INFO -D__STDC_FORMAT_MACROS -DMAC_OSX -DOBJC_OLD_DISPATCH_PROTOTYPES=0
  CXX           = g++ -std=c++11
  CXXFLAGS      =   -Wstack-protector -fstack-protector-all -fcf-protection=full  -Wall -Wextra -Wgnu -Wformat -Wformat-security -Wvla -Wshadow-field -Wswitch -Wthread-safety -Wrange-loop-analysis -Wredundant-decls -Wunused-variable -Wdate-time -Wconditional-uninitialized -Wsign-compare -Woverloaded-virtual -Wunreachable-code-loop-increment  -Wno-unused-parameter -Wno-self-assign -Wno-unused-local-typedef -Wno-deprecated-register -Wno-implicit-fallthrough   -g -O2
  LDFLAGS       = -lpthread  -Wl,-bind_at_load   -Wl,-headerpad_max_install_names -Wl,-dead_strip -Wl,-dead_strip_dylibs
  ARFLAGS       = cr


```
</p>
</details>

---

<details>
<summary>install libs via [https://brew.sh](https://brew.sh) for macOS</summary>
<p>

```

git at ₿ in ~/dotfiles on master [!?]
cd ~/bitcoin && \
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)" && \
brew install make curl && \
 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/RandyMcMillan/bitcoin/randymcmillan-deliverables/install-qt5.sh)" && \
 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/RandyMcMillan/bitcoin/randymcmillan-deliverables/install-bitcoin-libs.sh)"



```

</p>
</details>

---

<details>
<summary>insert more code</summary>
<p>

```

insert code

```

</p>
</details>


---

<details>
<summary>make</summary>
<p>

```

git at ₿ in ~/dotfiles on master [!?]
cd ~/bitcoin && \
make -C depends && \
make appbundle


```

</p>
</details>

---

<details>
<summary>next step</summary>
<p>

```

insert code sample


```

</p>
</details>
