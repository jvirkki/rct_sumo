#
#  Copyright 2015 Jyri J. Virkki <jyri@virkki.com>
#
#  This file is part of rct_sumo.
#
#  rct_sumo is free software: you can redistribute it and/or modify it
#  under the terms of the GNU General Public License as published by
#  the Free Software Foundation, either version 3 of the License, or
#  (at your option) any later version.
#
#  rct_sumo is distributed in the hope that it will be useful, but
#  WITHOUT ANY WARRANTY; without even the implied warranty of
#  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
#  General Public License for more details.
#
#  You should have received a copy of the GNU General Public License
#  along with rct_sumo.  If not, see <http://www.gnu.org/licenses/>.
#

GEM=gem

build:
	$(GEM) build rct_sumo.gemspec

install: clean build
	$(GEM) install ./rct_sumo-*.gem

publish: clean build
	$(GEM) push ./rct_sumo-*.gem

clean:
	rm -f rct_sumo-*.gem
