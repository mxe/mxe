Cygwin Platform Specific Overrides
----------------------------------

#### [cygwinports](https://github.com/cygwinports)

Patches (e.g. gettext) can be fetched with:

```sh
wget -O- -q https://github.com/cygwinports/gettext | \
grep patch | \
sed -n 's,.*href=.*/blob/master/\([^"]*.patch\).*,\1,p' | \
xargs -I % wget https://raw.githubusercontent.com/cygwinports/gettext/master/% -O gettext-%
```

and tidy up patch level with (requires GNU Sed for `-i` option):

```sh
sed -i 's,src/gettext-[0-9.]*/,src/,g' *.patch
```
