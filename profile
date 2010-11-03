# /Users/tianyi/Gentoo/etc/profile: login shell setup
#
# That this file is used by any Bourne-shell derivative to setup the
# environment for login shells.
#

# Load environment settings from profile.env, which is created by
# env-update from the files in /etc/env.d
if [ -e "/Users/tianyi/Gentoo"/etc/profile.env ] ; then
	. "/Users/tianyi/Gentoo"/etc/profile.env
fi

# 077 would be more secure, but 022 is generally quite realistic
umask 022

# Set up PATH depending on whether we're root or a normal user.
# There's no real reason to exclude sbin paths from the normal user,
# but it can make tab-completion easier when they aren't in the
# user's PATH to pollute the executable namespace.
#
# It is intentional in the following line to use || instead of -o.
# This way the evaluation can be short-circuited and calling whoami is
# avoided.
if [ "$EUID" = "0" ] || [ "$USER" = "root" ] ; then
	PATH="/Users/tianyi/Gentoo/usr/sbin:/Users/tianyi/Gentoo/usr/bin:/Users/tianyi/Gentoo/sbin:/Users/tianyi/Gentoo/bin:${ROOTPATH}:/usr/sbin:/usr/bin:/sbin:/bin"
else
	PATH="/Users/tianyi/Gentoo/usr/bin:/Users/tianyi/Gentoo/bin:${PATH}:/usr/bin:/bin"
fi
export PATH
unset ROOTPATH

# Extract the value of EDITOR
[ -z "$EDITOR" ] && EDITOR="`. /Users/tianyi/Gentoo/etc/rc.conf 2>/dev/null; echo $EDITOR`"
[ -z "$EDITOR" ] && EDITOR="/Users/tianyi/Gentoo/bin/nano"
export EDITOR

if [ -n "${BASH_VERSION}" ] ; then
	# Newer bash ebuilds include /etc/bash/bashrc which will setup PS1
	# including color.  We leave out color here because not all
	# terminals support it.
	if [ -f "/Users/tianyi/Gentoo"/etc/bash/bashrc ] ; then
		# Bash login shells run only /etc/profile
		# Bash non-login shells run only /etc/bash/bashrc
		# Since we want to run /etc/bash/bashrc regardless, we source it 
		# from here.  It is unfortunate that there is no way to do 
		# this *after* the user's .bash_profile runs (without putting 
		# it in the user's dot-files), but it shouldn't make any 
		# difference.
		. "/Users/tianyi/Gentoo"/etc/bash/bashrc
	else
		PS1='\u@\h \w \$ '
	fi
else
	# Setup a bland default prompt.  Since this prompt should be useable
	# on color and non-color terminals, as well as shells that don't
	# understand sequences such as \h, don't put anything special in it.
	PS1="`whoami`@`uname -n | cut -f1 -d.` \$ "
fi

for sh in "/Users/tianyi/Gentoo"/etc/profile.d/*.sh ; do
	if [ -r "$sh" ] ; then
		. "$sh"
	fi
done
unset sh
