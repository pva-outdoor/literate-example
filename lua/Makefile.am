luacdir = $(LUA_CMOD)
lualdir = $(LUA_LMOD)

# luac_LTLIBRARIES = libtest.la
lual_SCRIPTS = defvar.lua pprint.lua

# libtest_la_SOURCES = libtest.org
# libtest_la_CFLAGS = $(ADM_CFLAGS)
# libtest_la_LDFLAGS = $(ADM_LIBS)

info_TEXINFOS = test-lua.texi
EXTRA_DIST = defvar.org pprint.org test-lua.org

BUILT_SOURCES = $(info_TEXINFOS) $(lual_SCRIPTS)
CLEANFILES = $(BUILT_SOURCES)

.org.c:
	emacs --batch -l org --kill "--eval=(org-babel-tangle-file (car command-line-args-left))" $<
	touch $@

.org.lua:
	emacs --batch -l org --kill "--eval=(let ((org-confirm-babel-evaluate nil)) (require 'ob-tangle) (org-babel-tangle-file (car command-line-args-left)))" $<
	touch $@

.org.texi:
	emacs --batch -l org -l ox-texinfo --kill $< "--eval=(org-texinfo-export-to-texinfo)"
	touch $@
