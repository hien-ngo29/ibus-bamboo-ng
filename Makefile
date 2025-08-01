#
# Bamboo - A Vietnamese Input method editor
# Copyright (C) 2018 Luong Thanh Lam <ltlam93@gmail.com>
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.
#

CC=cc
SHELL=sh

engine_name=bamboo
engine_gui_name=ibus-setup-Bamboo.desktop
ibus_e_name=ibus-engine-$(engine_name)
pkg_name=ibus-$(engine_name)
version=1.0.0

engine_dir=$(PREFIX)/share/$(pkg_name)
ibus_dir=$(PREFIX)/share/ibus

GOLDFLAGS=-ldflags "-w -s -X main.Version=$(version)

rpm_src_dir=~/rpmbuild/SOURCES
tar_file=$(pkg_name)-$(version).tar.gz
rpm_src_tar=$(rpm_src_dir)/$(tar_file)
tar_options_src=--transform "s/^\./$(pkg_name)-$(version)/" --exclude=.git --exclude="*.tar.gz" .

all: build

build:
	$(SHELL) scripts/build

test:
	$(SHELL) scripts/test

clean:
	rm -f ibus-engine-bamboo
	rm -f *_linux *_cover.html go_test_* go_build_* test *.gz test
	rm -f debian/files
	rm -rf debian/debhelper*
	rm -rf debian/.debhelper
	rm -rf debian/ibus-bamboo*


install: build
	$(SHELL) scripts/install ${PREFIX} ${DESTDIR}

uninstall:
	rm -rf $(DESTDIR)$(engine_dir)
	rm -rf $(DESTDIR)$(PREFIX)/lib/ibus-$(engine_name)/
	rm -f $(DESTDIR)$(ibus_dir)/component/$(engine_name).xml
	rm -rf $(DESTDIR)$(PREFIX)/share/applications/$(engine_gui_name)


src: clean
	tar -zcf $(DESTDIR)/$(tar_file) $(tar_options_src)
	cp -f data/$(pkg_name).spec $(DESTDIR)/
	cp -f data/$(pkg_name).dsc $(DESTDIR)/
	cp -f debian/changelog $(DESTDIR)/debian.changelog
	cp -f debian/control $(DESTDIR)/debian.control
	cp -f debian/compat $(DESTDIR)/debian.compat
	cp -f debian/rules $(DESTDIR)/debian.rules
	cp -f archlinux/PKGBUILD-obs $(DESTDIR)/PKGBUILD


rpm: clean
	tar -zcf $(rpm_src_tar) $(tar_options_src)
	rpmbuild $(pkg_name).spec -ba

deb: clean
	dpkg-buildpackage


.PHONY: build clean build install uninstall src rpm deb
