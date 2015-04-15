#!/usr/bin/perl

=pod

=head1 NAME 

imapsync - IMAP synchronisation, sync, copy or migration
tool. Synchronise mailboxes between two imap servers. Good
at IMAP migration. More than 32 different IMAP server softwares
supported with success.

$Revision: 1.286 $

=head1 INSTALL

 imapsync works fine under any Unix OS with perl.
 imapsync works fine under Windows (2000, XP) and ActiveState's 5.8 Perl

 imapsync is already available directly on the following distributions (at least):
 FreeBSD, Debian, Ubuntu, Gentoo, NetBSD, Darwin, Mandriva and OpenBSD (yeah!).

 Get imapsync at
 http://www.linux-france.org/prj/imapsync/dist/

 You'll find a compressed tarball called imapsync-x.xx.tgz
 where x.xx is the version number. Untar the tarball where
 you want (on Unix):

 tar xzvf  imapsync-x.xx.tgz

 Go into the directory imapsync-x.xx and read the INSTALL file.
 The INSTALL file is also at 
 http://www.linux-france.org/prj/imapsync/INSTALL (for windows users)
 
 The freshmeat record is at http://freshmeat.net/projects/imapsync/

=head1 SYNOPSIS

  imapsync [options]

To get a description of each option just run imapsync like this:

  imapsync --help
  imapsync

The option list:

  imapsync [--host1 server1]  [--port1 <num>]
           [--user1 <string>] [--passfile1 <string>]
           [--host2 server2]  [--port2 <num>]
           [--user2 <string>] [--passfile2 <string>]
           [--ssl1] [--ssl2]
           [--authmech1 <string>] [--authmech2 <string>] 
           [--noauthmd5]
           [--folder <string> --folder <string> ...]
           [--folderrec <string> --folderrec <string> ...]
           [--include <regex>] [--exclude <regex>]
           [--prefix2 <string>] [--prefix1 <string>] 
           [--regextrans2 <regex> --regextrans2 <regex> ...]
           [--sep1 <char>]
           [--sep2 <char>]
           [--justfolders] [--justfoldersizes] [--justconnect] [--justbanner]
           [--syncinternaldates]
           [--idatefromheader]
           [--buffersize  <int>]
           [--syncacls]
           [--regexmess <regex>] [--regexmess <regex>]
           [--maxsize <int>]
           [--maxage <int>]
           [--minage <int>]
           [--skipheader <regex>]
           [--useheader <string>] [--useheader <string>]
           [--skipsize] [--allowsizemismatch]
           [--delete] [--delete2]
           [--expunge] [--expunge1] [--expunge2] [--uidexpunge2]
           [--subscribed] [--subscribe]
           [--nofoldersizes]
           [--dry]
           [--debug] [--debugimap]
           [--timeout <int>] [--fast]
           [--split1] [--split2] 
           [--reconnectretry1 <int>] [--reconnectretry2 <int>]
           [--version] [--help]
  
=cut
# comment

=pod

=head1 DESCRIPTION

The command imapsync is a tool allowing incremental and
recursive imap transfer from one mailbox to another. 

By default all folders are transferred, recursively.

We sometimes need to transfer mailboxes from one imap server to
another. This is called migration.

imapsync is a good tool because it reduces the amount
of data transferred by not transferring a given message if it
is already on both sides. Same headers, same message size
and the transfer is done only once. All flags are
preserved, unread will stay unread, read will stay read,
deleted will stay deleted. You can stop the transfer at any
time and restart it later, imapsync works well with bad 
connections. imapsync is CPU hungry so nice and renice 
commands can be a good help. imapsync can be memory hungry too,
especially with large messages.

You can decide to delete the messages from the source mailbox
after a successful transfer (it is a good feature when migrating).
In that case, use the --delete --expunge1 options.

You can also just synchronize a mailbox A from another mailbox B
in case you just want to keep a "live" copy of B in A.

=head1 OPTIONS

To get a description of each option just invoke: 

imapsync --help

=head1 HISTORY

I wrote imapsync because an enterprise (basystemes) paid me to install
a new imap server without losing huge old mailboxes located on a far
away remote imap server accessible by a low bandwith link. The tool
imapcp (written in python) could not help me because I had to verify
every mailbox was well transferred and delete it after a good
transfer. imapsync started life as a copy_folder.pl patch.
The tool copy_folder.pl comes from the Mail-IMAPClient-2.1.3 perl
module tarball source (in the examples/ directory of the tarball).

=head1 EXAMPLE

While working on imapsync parameters please run imapsync in
dry mode (no modification induced) with the --dry
option. Nothing bad can be done this way.

To synchronize the imap account "buddy" on host
"imap.src.fr" to the imap account "max" on host
"imap.dest.fr" (the passwords are located in two files
"/etc/secret1" for "buddy", "/etc/secret2" for "max"):

 imapsync --host1 imap.src.fr  --user1 buddy --passfile1 /etc/secret1 \
          --host2 imap.dest.fr --user2 max   --passfile2 /etc/secret2

Then, you will have max's mailbox updated from buddy's
mailbox.

=head1 SECURITY

You can use --password1 instead of --passfile1 to give the
password but it is dangerous because any user on your host
can see the password by using the 'ps auxwwww'
command. Using a variable (like $PASSWORD1) is also
dangerous because of the 'ps auxwwwwe' command. So, saving
the password in a well protected file (600 or rw-------) is
the best solution.

imasync is not totally protected against sniffers on the
network since passwords may be transferred in plain text
if CRAM-MD5 is not supported by your imap servers.  Use
--ssl1 and --ssl2 to enable encryption on host1 and host2.

You may authenticate as one user (typically an admin user),
but be authorized as someone else, which means you don't
need to know every user's personal password.  Specify
--authuser1 "adminuser" to enable this on host1.  In this
case, --authmech1 PLAIN will be used by default since it
is the only way to go for now. So don't use --authmech1 SOMETHING
with --authuser1 "adminuser", it will not work.
Same behavior with the --authuser2 option.


=head1 EXIT STATUS

imapsync will exit with a 0 status (return code) if everything went good.
Otherwise, it exits with a non-zero status.

So if you have an unreliable internet connection, you can use this loop 
in a Bourne shell:

        while ! imapsync ...; do 
              echo imapsync not complete
        done

=head1 LICENSE

imapsync is free, gratis and open source software cover by
the GNU General Public License. See the GPL file included in
the distribution or the web site
http://www.gnu.org/licenses/licenses.html

=head1 MAILING-LIST

The public mailing-list may be the best way to get support.

To write on the mailing-list, the address is:
<imapsync@linux-france.org>

To subscribe, send a message to:
<imapsync-subscribe@listes.linux-france.org>

To unsubscribe, send a message to:
<imapsync-unsubscribe@listes.linux-france.org>

To contact the person in charge for the list:
<imapsync-request@listes.linux-france.org>

The list archives may be available at:
http://www.linux-france.org/prj/imapsync_list/
So consider that the list is public, anyone
can see your post. Use a pseudonym or do not
post to this list if you want to stay private.

Thank you for your participation.

=head1 AUTHOR

Gilles LAMIRAL <lamiral@linux-france.org>

Feedback good or bad is always welcome.

The newsgroup comp.mail.imap may be a good place to talk about
imapsync. I read it when imapsync is concerned.
A better place is the public imapsync mailing-list
(see below).

Gilles LAMIRAL earns his living writing, installing,
configuring and teaching free, open and gratis
softwares. Do not hesitate to pay him for that services.

=head1 BUGS and BUG REPORT

No known serious bug.  

Report any bugs or feature requests to the public mailing-list 
or to the author.

Help us to help you: follow the following guidelines.

Before reporting bugs, read the FAQ, the README and the
TODO files. http://www.linux-france.org/prj/imapsync/

Make a good title, not just "imapsync" or "problem",
a good title is made of keywords summary,  not too long (one visible line).

Don't write imapsync in uppercase in the email title, we'll
know you run windows(tm) and you haven't read the README yet.

Help us to help you: in your report, please include:

 - imapsync version.
 - output given with --debug --debugimap near the failure point.
   Isolate a message in a folder 'BUG' and use --folder 'BUG'
 - imap server software on both side and their version number.
 - imapsync with all the options you use,  the full command line
   you use (except the passwords of course). 
 - IMAPClient.pm version.
 - operating system running imapsync.
 - operating systems on both sides and the third side in case
   you run imapsync on a foreign host from the both.
 - virtual software context (vmware, xen etc.)

 Most of those values can be found as a copy/paste at the begining of the output.

=head1 IMAP SERVERS 

Failure stories reported with the following 4 imap servers:

 - MailEnable 1.54 (Proprietary) http://www.mailenable.com/
 - DBMail 0.9, 2.0.7 (GPL). But DBMail 1.2.1 works.
   Patient and confident testers are welcome.
 - dkimap4 2.39
 - Imail 7.04 (maybe).

Success stories reported with the following 35 imap servers 
(software names are in alphabetic order): 

 - Archiveopteryx 2.03, 2.04, 2.09, 2.10 [dest], 3.0.0 [dest]
   (OSL 3.0) http://www.archiveopteryx.org/
 - BincImap 1.2.3 (GPL) (http://www.bincimap.org/)
 - CommuniGatePro server (Redhat 8.0) (Solaris)
 - Courier IMAP 1.5.1, 2.2.0, 2.1.1, 2.2.1, 3.0.8, 3.0.3, 4.1.1 (GPL) 
   (http://www.courier-mta.org/)
 - Critical Path (7.0.020)
 - Cyrus IMAP 1.5, 1.6, 2.1, 2.1.15, 2.1.16, 2.1.18 
   2.2.1, 2.2.2-BETA, 2.2.10, 2.2.12, 
   v2.2.3-Invoca-RPM-2.2.3-8,
   2.3-alpha (OSI Approved),
   v2.2.12-Invoca-RPM-2.2.12-3.RHEL4.1,
   2.2.13,
   v2.3.1-Invoca-RPM-2.3.1-2.7.fc5,
   v2.3.7,
   (http://asg.web.cmu.edu/cyrus/)
 - David Tobit V8 (proprietary Message system).
 - DBMail 1.2.1, 2.0.4, 2.0.9, 2.2rc1 (GPL) (http://www.dbmail.org/).
   2.0.7 seems buggy.
 - Deerfield VisNetic MailServer 5.8.6 [from]
 - Dovecot 0.99.10.4, 0.99.14, 0.99.14-8.fc4, 1.0-0.beta2.7, 
   1.0.0 [dest/source] (LGPL) (http://www.dovecot.org/)
 - Domino (Notes) 4.61[from], 6.5, 5.0.6, 5.0.7, 7.0.2, 6.0.2CF1, 7.0.1 [from]
 - Eudora WorldMail v2
 - GMX IMAP4 StreamProxy.
 - Groupwise IMAP (Novell) 6.x and 7.0. Buggy so see the FAQ.
 - iPlanet Messaging server 4.15, 5.1, 5.2
 - IMail 7.15 (Ipswitch/Win2003), 8.12
 - MDaemon 7.0.1, 8.0.2, 8.1, 9.5.4 (Windows server 2003 R2 platform)
 - Mercury 4.1 (Windows server 2000 platform)
 - Microsoft Exchange Server 5.5, 6.0.6249.0[from], 6.0.6487.0[from], 6.5.7638.1 [dest]
 - Netscape Mail Server 3.6 (Wintel !)
 - Netscape Messaging Server 4.15 Patch 7
 - OpenMail IMAP server B.07.00.k0 (Samsung Contact ?)
 - OpenWave
 - Qualcomm Worldmail (NT)
 - Rockliffe Mailsite 5.3.11, 4.5.6
 - Samsung Contact IMAP server 8.5.0
 - Scalix v10.1, 10.0.1.3, 11.0.0.431
 - SmarterMail
 - SunONE Messaging server 5.2, 6.0 (SUN JES - Java Enterprise System)
 - Sun Java(tm) System Messaging Server 6.2-2.05,  6.2-7.05
 - Surgemail 3.6f5-5
 - UW-imap servers (imap-2000b) rijkkramer IMAP4rev1 2000.287
   (RedHat uses UW like 2003.338rh), v12.264 Solaris 5.7 (OSI Approved) 
   (http://www.washington.edu/imap/)
 - UW - QMail v2.1
 - Imap part of TCP/IP suite of VMS 7.3.2
 - Zimbra-IMAP 3.0.1 GA 160, 3.1.0 Build 279, 4.0.5, 4.5.2, 4.5.6, 5.5.

Please report to the author any success or bad story with
imapsync and do not forget to mention the IMAP server
software names and version on both sides. This will help
future users. To help the author maintaining this section
report the two lines at the begining of the output if they
are useful to know the softwares. Example:

 From software:* OK louloutte Cyrus IMAP4 v1.5.19 server ready
 To   software:* OK Courier-IMAP ready

You can use option --justconnect to get those lines.
Example:

  imapsync --host1 imap.troc.org --host2 imap.trac.org --justconnect

Please rate imapsync at http://freshmeat.net/projects/imapsync/
or better give the author a book, he likes books:
http://www.amazon.com/gp/registry/wishlist/1C9UNDIH3P7R7/
(or its paypal account gilles.lamiral@laposte.net)

=head1 HUGE MIGRATION

Pay special attention to options 
--subscribed
--subscribe
--delete
--delete2
--expunge
--expunge1
--expunge2
--uidexpunge2
--maxage
--minage
--maxsize
--useheader
--fast

If you have many mailboxes to migrate think about a little
shell program. Write a file called file.csv (for example)
containing users and passwords.
The separator used in this example is ';'

The file.csv file contains:

user0001;password0001;user0002;password0002
user0011;password0011;user0012;password0012
...

And the shell program is just:

 { while IFS=';' read  u1 p1 u2 p2; do 
	imapsync --user1 "$u1" --password1 "$p1" --user2 "$u2" --password2 "$p2" ...
 done ; } < file.csv

Welcome in shell programming !

=head1 Hacking

Feel free to hack imapsync as the GPL Licence permits it.

=head1 Links

Entries for imapsync:
  http://www.imap.org/products/showall.php


=head1 SIMILAR SOFTWARES

  imap_tools    : http://www.athensfbc.com/imap_tools
  offlineimap   : http://software.complete.org/offlineimap
  mailsync      : http://mailsync.sourceforge.net/
  imapxfer      : http://www.washington.edu/imap/
                   part of the imap-utils from UW.
  mailutil      : replace imapxfer in 
                   part of the imap-utils from UW.
                  http://www.gsp.com/cgi-bin/man.cgi?topic=mailutil
  imaprepl      : http://www.bl0rg.net/software/
                  http://freshmeat.net/projects/imap-repl/
  imap_migrate  : http://freshmeat.net/projects/imapmigration/
  imapcopy      : http://home.arcor.de/armin.diehl/imapcopy/imapcopy.html
  migrationtool : http://sourceforge.net/projects/migrationtool/
  imapmigrate   : http://sourceforge.net/projects/cyrus-utils/
  wonko_imapsync: http://wonko.com/article/554
                  see also tools/wonko_ruby_imapsync
  pop2imap      : http://www.linux-france.org/prj/pop2imap/


Feedback (good or bad) will always be welcome.

$Id: imapsync,v 1.286 2009/07/24 15:53:04 gilles Exp gilles $

=cut

use warnings;
++$|;
use strict;
use Carp;
use Getopt::Long;
use Mail::IMAPClient;
use Digest::MD5  qw(md5_base64);
use Term::ReadKey;
#use IO::Socket::SSL;
use MIME::Base64;
use English;
use POSIX qw(uname);
use Fcntl;

#use Test::Simple tests => 1;
use Test::More 'no_plan';

eval { require 'usr/include/sysexits.ph' };


my(
        $rcs, $debug, $debugimap, $error,
	$host1, $host2, $port1, $port2,
	$user1, $user2, $password1, $password2, $passfile1, $passfile2,
        @folder, @include, @exclude, @folderrec,
        $prefix1, $prefix2, 
        @regextrans2, @regexmess, @regexflag, 
        $sep1, $sep2,
	$syncinternaldates,
        $idatefromheader,
        $syncacls,
        $fastio1, $fastio2, 
	$maxsize, $maxage, $minage, 
        $skipheader, @useheader,
        $skipsize, $allowsizemismatch, $foldersizes, $buffersize,
	$delete, $delete2,
        $expunge, $expunge1, $expunge2, $uidexpunge2, $dry,
        $justfoldersizes,
        $authmd5,
        $subscribed, $subscribe,
	$version, $VERSION, $help, 
        $justconnect, $justfolders, $justbanner,
        $fast,
        $mess_size_total_trans,
        $mess_size_total_skipped,
        $mess_size_total_error,
        $mess_trans, $mess_skipped, $mess_skipped_dry, 
        $timeout,   # whr (ESS/PRW)
	$timestart, $timeend, $timediff,
        $timesize, $timebefore,
        $ssl1, $ssl2,
        $authuser1, $authuser2,
        $authmech1, $authmech2,
        $split1, $split2,
        $reconnectretry1, $reconnectretry2,
	$tests, $test_builder,
	$allow3xx, $justlogin,
);

use vars qw ($opt_G); # missing code for this will be option.


$rcs = '$Id: imapsync,v 1.286 2009/07/24 15:53:04 gilles Exp gilles $ ';
$rcs =~ m/,v (\d+\.\d+)/;
$VERSION = ($1) ? $1: "UNKNOWN";

my $VERSION_IMAPClient = $Mail::IMAPClient::VERSION;



$mess_size_total_trans   = 0;
$mess_size_total_skipped = 0;
$mess_size_total_error   = 0;
$mess_trans = $mess_skipped = $mess_skipped_dry = 0;


sub check_lib_version {
	$debug and print "VERSION_IMAPClient $VERSION_IMAPClient\n";
	if ($VERSION_IMAPClient eq '2.2.9') {
		override_imapclient();
		return(1);
	}
	else{
		# 3.x.x is no longer buggy with imapsync.
		if ($allow3xx) {
			return(1);

		}else{
			return(0);
		}
	}
}

$error=0;

sub modules_VERSION() {

no warnings 'uninitialized';
my $modules_releases = "
Mail::IMAPClient  $Mail::IMAPClient::VERSION
IO::Socket        $IO::Socket::VERSION
IO::Socket::SSL   $IO::Socket::SSL::VERSION
Digest::MD5       $Digest::MD5::VERSION
Digest::HMAC_MD5  $Digest::HMAC_MD5::VERSION
Term::ReadKey     $Term::ReadKey::VERSION
Date::Manip       $Date::Manip::VERSION
";	
    return($modules_releases);

}

my @argv_nopassord;
my @argv_copy = @ARGV;
while (@argv_copy) {
	my $arg = shift(@argv_copy);
	if ($arg =~ m/-password[12]/) {
		shift(@argv_copy);
		push(@argv_nopassord, $arg, "MASKED");
	}else{
		push(@argv_nopassord, $arg);
	}
}

my $banner = join("", 
		  '$RCSfile: imapsync,v $ ',
		  '$Revision: 1.286 $ ',
		  '$Date: 2009/07/24 15:53:04 $ ',
		  "\n",localhost_info(),
		  " and the module Mail::IMAPClient version used here is ",
		  $VERSION_IMAPClient,"\n",
		  "Command line used:\n",
		  "$0 @argv_nopassord\n",
		 );

unless(defined(&_SYSEXITS_H)) {
	# 64 on my linux box.
	eval 'sub EX_USAGE () {64;}' unless defined(&EX_USAGE);
}

get_options();

# allow Mail::IMAPClient 3.0.xx by default

$allow3xx = defined($allow3xx) ? $allow3xx : 1;

check_lib_version() or 
  die "imapsync needs perl lib Mail::IMAPClient release 2.2.9, or 3.0.19 or superior \n";


print $banner;

exit(0) if ($justbanner);

sub missing_option {
	my ($option) = @_;
	die "$option option must be used, run $0 --help for help\n";
}

# By default, 1000 at a time, not more.
$split1 ||= 1000;
$split2 ||= 1000;

$host1 || missing_option("--host1") ;
$port1 ||= defined $ssl1 ? 993 : 143;

$host2 || missing_option("--host2") ;
$port2 ||= defined $ssl2 ? 993 : 143;



sub connect_imap {
	my($host, $port, $debugimap, $ssl) = @_;
	my $imap = Mail::IMAPClient->new();
	$imap->Server($host);
	$imap->Port($port);
	$imap->Debug($debugimap);
	$imap->Ssl($ssl) if ($ssl);
	#$imap->connect()
	myconnect($imap)
	  or die "Can not open imap connection on [$host]: $@\n";	
}

sub localhost_info {
	
	my($infos) = join("", 
	    "Here is a [$OSNAME] system (", 
	    join(" ", 
	         uname(),
	         ),
                 ")\n",
	         "with perl ", 
	         sprintf("%vd", $PERL_VERSION),
	         modules_VERSION()
            );	  
	return($infos);

}

if ($justconnect) {
	my $from = ();
	my $to = ();
	
	$from = connect_imap($host1, $port1, $debugimap, $ssl1);
	print "From software: ", server_banner($from);
	print "From capability: ", join(" ", $from->capability()), "\n";
	$to   = connect_imap($host2, $port2, $debugimap, $ssl2);
	print "To   software: ", server_banner($to);
	print "To   capability: ", join(" ", $to->capability()), "\n";
	$from->logout();
	$to->logout();
	exit(0);
}

$user1 || missing_option("--user1");
$user2 || missing_option("--user2");

$syncinternaldates = defined($syncinternaldates) ? defined($syncinternaldates) : 1;

if($idatefromheader) {
	print "Turned ON idatefromheader, ",
	      "will set the internal dates on host2 from the 'Date:' header line.\n";
	$syncinternaldates = 0;

}
if ($syncinternaldates) {
	print "Turned ON syncinternaldates, ",
	      "will set the internal dates (arrival dates) on host2 same as host1.\n";
}else{
	print "Turned OFF syncinternaldates\n";
}

if ($syncinternaldates || $idatefromheader) {
	no warnings 'redefine';
	local *Carp::confess = sub { return undef; };
	require Date::Manip;
	Date::Manip->import(qw(ParseDate Date_Cmp UnixDate Date_Init Date_TimeZone));
	#print "Date_init: [", join(" ",Date_Init()), "]\n";
	print "TimeZone:[", Date_TimeZone(), "]\n";
	if (not (Date_TimeZone())) {
		warn "TimeZone not defined, setting it to GMT";
		Date_Init("TZ=GMT");
		print "TimeZone: [", Date_TimeZone(), "]\n";
	}
}


if(defined($authmd5) and not($authmd5)) {
	$authmech1 ||= 'LOGIN';
	$authmech2 ||= 'LOGIN';
}
else{
	$authmech1 ||= $authuser1 ? 'PLAIN' : 'CRAM-MD5';
	$authmech2 ||= $authuser2 ? 'PLAIN' : 'CRAM-MD5';
}

$authmech1 = uc($authmech1);
$authmech2 = uc($authmech2);

$authuser1 ||= $user1;
$authuser2 ||= $user2;

print "Will try to use $authmech1 authentication on host1\n";
print "Will try to use $authmech2 authentication on host2\n";

$syncacls = (defined($syncacls)) ? $syncacls : 0;
$foldersizes = (defined($foldersizes)) ? $foldersizes : 1;

$fastio1 = (defined($fastio1)) ? $fastio1 : 0;
$fastio2 = (defined($fastio2)) ? $fastio2 : 0;



@useheader = ("ALL") unless (@useheader);

print "From imap server [$host1] port [$port1] user [$user1]\n";
print "To   imap server [$host2] port [$port2] user [$user2]\n";


sub ask_for_password {
	my ($user, $host) = @_;
	print "What's the password for $user\@$host? ";
	Term::ReadKey::ReadMode(2);
	my $password = <>;
	chomp $password;
	printf "\n";
	Term::ReadKey::ReadMode(0);
	return $password;
}


$password1 || $passfile1 || do {
	$password1 = ask_for_password($authuser1 || $user1, $host1);
};

$password1 = (defined($passfile1)) ? firstline ($passfile1) : $password1;

$password2 || $passfile2 || do {
	$password2 = ask_for_password($authuser2 || $user2, $host2);
};

$password2 = (defined($passfile2)) ? firstline ($passfile2) : $password2;

my $from = ();
my $to = ();

$timestart = time();
$timebefore = $timestart;

$debugimap and print "From connection\n";
$from = login_imap($host1, $port1, $user1, $password1, 
		   $debugimap, $timeout, $fastio1, $ssl1, 
		   $authmech1, $authuser1, $reconnectretry1);

$debugimap and print "To  connection\n";
$to = login_imap($host2, $port2, $user2, $password2, 
		 $debugimap, $timeout, $fastio2, $ssl2, 
		 $authmech2, $authuser2, $reconnectretry2);

#  history

$debug and print "From Buffer I/O: ", $from->Buffer(), "\n";
$debug and print "To   Buffer I/O: ", $to->Buffer(), "\n";


sub login_imap {
	my($host, $port, $user, $password, 
	   $debugimap, $timeout, $fastio, 
	   $ssl, $authmech, $authuser, $reconnectretry) = @_;
	my ($imap);
	
	$imap = Mail::IMAPClient->new();
	
	$imap->Ssl($ssl) if ($ssl);
	$imap->Clear(5);
	$imap->Server($host);
	$imap->Port($port);
	$imap->Fast_io($fastio);
	$imap->Buffer($buffersize || 4096);
	$imap->Uid(1);
	$imap->Peek(1);
	$imap->Debug($debugimap);
	$timeout and $imap->Timeout($timeout);

	( Mail::IMAPClient->VERSION =~ /^2/ or !$imap->can("Reconnectretry"))
	  ? warn("--reconnectretry* requires IMAPClient >= 3.17\n")
	  : $imap->Reconnectretry($reconnectretry)
	  if ($reconnectretry);

	#$imap->connect()
	myconnect($imap)
	  or die "Can not open imap connection on [$host] with user [$user]: $@\n";
	
	print "Banner: ", server_banner($imap);
	
	if ($imap->has_capability("AUTH=$authmech")
	    or $imap->has_capability($authmech)
	   ) {
		printf("Host %s says it has CAPABILITY for AUTHENTICATE %s\n",
		       $imap->Server, $authmech);
	} 
	else {
		printf("Host %s says it has NO CAPABILITY for AUTHENTICATE %s\n",
		       $imap->Server, $authmech);
		if ($authmech eq 'PLAIN') {
			print "Frequently PLAIN is only supported with SSL, ",
			  "try --ssl1 or --ssl2 option\n";
		}
	}
	
	$imap->Authmechanism($authmech) unless ($authmech eq 'LOGIN');
	$imap->Authcallback(\&plainauth) if $authmech eq "PLAIN";

	$imap->User($user);
	$imap->Authuser($authuser);
	$imap->Password($password);
	unless ($imap->login()) {
		my $info  = "Error login: [$host] with user [$user] auth";
		my $einfo = $imap->LastError || @{$imap->History}[-1];
		chomp($einfo);
		my $error = "$info [$authmech]: $einfo\n";
		print $error; # note: duplicating error on stdout/stderr
		die $error if ($authmech eq 'LOGIN' or $imap->IsUnconnected() or $authuser);
		print "Trying LOGIN Auth mechanism on [$host] with user [$user]\n";
		$imap->Authmechanism("");
		$imap->login() or
		  die "$info [LOGIN]: ", $imap->LastError, "\n";
	}
	print "Success login on [$host] with user [$user] auth [$authmech]\n";
	return($imap);
}

sub plainauth() {
        my $code = shift;
        my $imap = shift;

        my $string = sprintf("%s\x00%s\x00%s", $imap->User,
                            $imap->Authuser, $imap->Password);
        return encode_base64("$string", "");
}


sub server_banner {
	my $imap = shift;
	for my $line ($imap->Results()) {
		#print "LR: $line";
		return $line if $line =~ /^\* (OK|NO|BAD)/;
        }
	return "No banner\n";
 }



$debug and print "From capability: ", join(" ", $from->capability()), "\n";
$debug and print "To   capability: ", join(" ", $to->capability()), "\n";

die unless $from->IsAuthenticated();
print "host1: state Authenticated\n";
die unless   $to->IsAuthenticated();
print "host2: state Authenticated\n";

exit(0) if ($justlogin);

$split1 and $from->Split($split1);
$split2 and $to->Split($split2);

# 
# Folder stuff
#

my (@f_folders, %requested_folder, @t_folders, @t_folders_list, %t_folders_list, %subscribed_folder, %t_folders);

sub tests_folder_routines {
	ok( !give_requested_folders()                ,"no requested folders"  );
	ok( !is_requested_folder('folder_foo')                                );
	ok(  add_to_requested_folders('folder_foo')                           );
	ok(  is_requested_folder('folder_foo')                                );
	ok( !is_requested_folder('folder_NO_EXIST')                           );
	ok( !remove_from_requested_folders('folder_foo'), "removed folder_foo");
	ok( !is_requested_folder('folder_foo')                                );
	my @f;
	ok(  @f = add_to_requested_folders('folder_bar', 'folder_toto'), "add result: @f");
	ok(  is_requested_folder('folder_bar')                                );
	ok(  is_requested_folder('folder_toto')                               );
	ok(  remove_from_requested_folders('folder_toto')                     );
	ok( !is_requested_folder('folder_toto')                               );
	ok( init_requested_folders()                 , 'empty requested folders');
	ok( !give_requested_folders()                , 'no requested folders'  );
}

sub give_requested_folders {
	return(keys(%requested_folder));
}

sub init_requested_folders {
	
	%requested_folder = ();
	return(1);
	
}

sub is_requested_folder {
	my ( $folder ) = @_;
	
	defined( $requested_folder{ $folder } );
}


sub add_to_requested_folders {
	my @wanted_folders = @_;
	
	foreach my $folder ( @wanted_folders ) {
	 	++$requested_folder{ $folder };
	}
	return( keys( %requested_folder ) );
}

sub remove_from_requested_folders {
	my @wanted_folders = @_;
	
	foreach my $folder (@wanted_folders) {
	 	delete $requested_folder{$folder};
	}
	return( keys(%requested_folder) );
}


# Make a hash of subscribed folders in source server.
map { $subscribed_folder{$_} = 1 } $from->subscribed();


my @all_source_folders = sort $from->folders();

if (scalar(@folder) or $subscribed or scalar(@folderrec)) {
	# folders given by option --folder
	if (scalar(@folder)) {
		add_to_requested_folders(@folder);
	}
	
	# option --subscribed
	if ($subscribed) {
		add_to_requested_folders(keys (%subscribed_folder));
	}
	
	# option --folderrec
	if (scalar(@folderrec)) {
		foreach my $folderrec (@folderrec) {
			add_to_requested_folders($from->folders($folderrec));
		}
	}
}
else {
	
	# no include, no folder/subscribed/folderrec options => all folders
	if (not scalar(@include)) {
		add_to_requested_folders(@all_source_folders);
	}
}


# consider (optional) includes and excludes
if (scalar(@include)) {
	foreach my $include (@include) {
		my @included_folders = grep /$include/, @all_source_folders;
		add_to_requested_folders(@included_folders);
		print "Including folders matching pattern '$include': @included_folders\n";
	}
}

if (scalar(@exclude)) {
	foreach my $exclude (@exclude) {
		my @requested_folder = sort(keys(%requested_folder));
		my @excluded_folders = grep /$exclude/, @requested_folder;
		remove_from_requested_folders(@excluded_folders);
		print "Excluding folders matching pattern '$exclude': @excluded_folders\n";
	}
}

# Remove no selectable folders

foreach my $folder (keys(%requested_folder)) {
        if ( not $from->selectable($folder)) {
		print "Warning: ignoring folder $folder because it is not selectable\n";
                remove_from_requested_folders($folder);
        }
}


my @requested_folder = sort(keys(%requested_folder));

@f_folders = @requested_folder;

sub compare_lists {
	my ($list_1_ref, $list_2_ref) = @_;
	
	return(-1) if ((not defined($list_1_ref)) and defined($list_2_ref));
	return(0)  if (! $list_1_ref); # end if no list
	return(1)  if (! $list_2_ref); # end if only one list
	
	if (not ref($list_1_ref)) {$list_1_ref = [$list_1_ref]};
	if (not ref($list_2_ref)) {$list_2_ref = [$list_2_ref]};


	my $last_used_indice = 0;
	ELEMENT:
	foreach my $indice ( 0 .. $#$list_1_ref ) {
		$last_used_indice = $indice;
		
		# End of list_2
		return 1 if ($indice > $#$list_2_ref);
		
		my $element_list_1 = $list_1_ref->[$indice];
		my $element_list_2 = $list_2_ref->[$indice];
		my $balance = $element_list_1 cmp $element_list_2 ;
		next ELEMENT if ($balance == 0) ;
		return $balance;
	}
	# each element equal until last indice of list_1
	return -1 if ($last_used_indice < $#$list_2_ref);
	
	# same size, each element equal
	return 0
}

sub tests_compare_lists {

	
	my $empty_list_ref = [];
	
	ok( 0 == compare_lists()               , 'compare_lists, no args');
	ok( 0 == compare_lists(undef)          , 'compare_lists, undef = nothing');
	ok( 0 == compare_lists(undef, undef)   , 'compare_lists, undef = undef');
	ok(-1 == compare_lists(undef , [])     , 'compare_lists, undef < []');
      	ok(+1 == compare_lists([])             , 'compare_lists, [] > nothing');
        ok(+1 == compare_lists([], undef)      , 'compare_lists, [] > undef');
	ok( 0 == compare_lists([] , [])        , 'compare_lists, [] = []');
	
	ok( 0 == compare_lists([1],  1 )          , "compare_lists, [1] =  1 ") ;
	ok( 0 == compare_lists( 1 , [1])          , "compare_lists,  1  = [1]") ;
	ok( 0 == compare_lists( 1 ,  1 )          , "compare_lists,  1  =  1 ") ;
	ok(-1 == compare_lists( 1 ,  2 )          , "compare_lists,  1  =  1 ") ;
	ok(+1 == compare_lists( 2 ,  1 )          , "compare_lists,  1  =  1 ") ;


	ok( 0 == compare_lists([1,2], [1,2])   , "compare_lists, [1,2] = [1,2]") ;
	ok(-1 == compare_lists([1], [1,2])     , "compare_lists, [1] < [1,2]") ;
	ok(-1 == compare_lists([1], [1,1])     , "compare_lists, [1] < [1,1]") ;
	ok(+1 == compare_lists([1, 1], [1])    , "compare_lists, [1, 1] > [1]") ;
	ok( 0 == compare_lists([1 .. 20_000] , [1 .. 20_000])
                                               , "compare_lists, [1..20_000] = [1..20_000]") ;
	ok(-1 == compare_lists([1], [3])       , 'compare_lists, [1] < [3]') ;
	ok( 0 == compare_lists([2], [2])       , 'compare_lists, [0] = [2]') ;
	ok(+1 == compare_lists([3], [1])       , 'compare_lists, [3] > [1]') ;
	
	ok(-1 == compare_lists(["a"], ["b"])   , 'compare_lists, ["a"] < ["b"]') ;
	ok( 0 == compare_lists(["a"], ["a"])   , 'compare_lists, ["a"] = ["a"]') ;
	ok( 0 == compare_lists(["ab"], ["ab"]) , 'compare_lists, ["ab"] = ["ab"]') ;
	ok(+1 == compare_lists(["b"], ["a"])   , 'compare_lists, ["b"] > ["a"]') ;
	ok(-1 == compare_lists(["a"], ["aa"])  , 'compare_lists, ["a"] < ["aa"]') ;
	ok(-1 == compare_lists(["a"], ["a", "a"]), 'compare_lists, ["a"] < ["a", "a"]') ;
}





my($f_sep,$t_sep); 
# what are the private folders separators for each server ?


$debug and print "Getting separators\n";
$f_sep = get_separator($from, $sep1, "--sep1");
$t_sep = get_separator($to, $sep2, "--sep2");

#my $f_namespace = $from->namespace();
#my $t_namespace = $to->namespace();
#$debug and print "From namespace:\n", Data::Dumper->Dump([$f_namespace]);
#$debug and print "To   namespace:\n", Data::Dumper->Dump([$t_namespace]);

my($f_prefix,$t_prefix); 
$f_prefix = get_prefix($from, $prefix1, "--prefix1");
$t_prefix = get_prefix($to, $prefix2, "--prefix2");

sub get_prefix {
	my($imap, $prefix_in, $prefix_opt) = @_;
	my($prefix_out);
	
	$debug and print "Getting prefix namespace\n";
	if (defined($prefix_in)) {
		print "Using [$prefix_in] given by $prefix_opt\n";
		$prefix_out = $prefix_in;
		return($prefix_out);
	}
	$debug and print "Calling namespace capability\n";
	if ($imap->has_capability("namespace")) {
		my $r_namespace = $imap->namespace();
		$prefix_out = $r_namespace->[0][0][0];
		return($prefix_out);
	}
	else{
		print 
		  "No NAMESPACE capability in imap server ", 
		    $imap->Server(),"\n",
		      "Give the prefix namespace with the $prefix_opt option\n";
		exit(1);
	}
}


sub get_separator {
	my($imap, $sep_in, $sep_opt) = @_;
	my($sep_out);
	
	
	if ($sep_in) {
		print "Using [$sep_in] given by $sep_opt\n";
		$sep_out = $sep_in;
		return($sep_out);
	}
	$debug and print "Calling namespace capability\n";
	if ($imap->has_capability("namespace")) {
		$sep_out = $imap->separator();
		return($sep_out) if defined $sep_out;
		warn 
		  "NAMESPACE request failed for ", 
		  $imap->Server(), ": ", $imap->LastError, "\n";
		exit(1);
	}
	else{
		warn
		  "No NAMESPACE capability in imap server ", 
		    $imap->Server(),"\n",
		      "Give the separator character with the $sep_opt option\n";
		exit(1);
	}
}


print "From separator and prefix: [$f_sep][$f_prefix]\n";
print "To   separator and prefix: [$t_sep][$t_prefix]\n";


sub foldersizes {

	my ($side, $imap, $folders_r) = @_;
	my $tot = 0;
	my $tmess = 0;
	my @folders = @{$folders_r};
	print "++++ Calculating sizes ++++\n";
	foreach my $folder (@folders)     {
		my $stot = 0;
		my $smess = 0;
		printf("$side Folder %-35s", "[$folder]");
		unless($imap->exists($folder)) {
			print("does not exist yet\n");
			next;
		}
		unless ($imap->select($folder)) {
			warn 
			  "$side Folder $folder: Could not select: ",
			    $imap->LastError,  "\n";
			$error++;
			next;
		}
		if (defined($maxage) or defined($minage)) {
			# The pb is fetch_hash() can only be applied on ALL messages
			my @msgs = select_msgs($imap);
			$smess = scalar(@msgs);
			foreach my $m (@msgs) {
				my $s = $imap->size($m)
				  or warn "Could not find size of message $m: $@\n";
				$stot += $s;
			}
		}
		else{
			my $hashref = {};
			$smess = $imap->message_count();
			unless ($smess == 0) {
				#$imap->Ranges(1);
				$imap->fetch_hash("RFC822.SIZE",$hashref) or die "$@";
				#$imap->Ranges(0);
				#print map {$hashref->{$_}->{"RFC822.SIZE"}, " "} keys %$hashref;
				map {$stot += $hashref->{$_}->{"RFC822.SIZE"}} keys %$hashref;
			}
		}
		printf(" Size: %9s", $stot);
		printf(" Messages: %5s\n", $smess);
		$tot += $stot;
		$tmess += $smess;
	}
	print "Total size: $tot\n";
	print "Total messages: $tmess\n";
	print "Time: ", timenext(), " s\n";
}


foreach my $f_fold (@f_folders) {
	my $t_fold;
	$t_fold = to_folder_name($f_fold);
	$t_folders{$t_fold}++;
}

@t_folders = sort keys(%t_folders);

if ($foldersizes) {
	foldersizes("From", $from, \@f_folders);
	foldersizes("To  ", $to,   \@t_folders);
}




sub timenext {
	my ($timenow, $timerel);
	# $timebefore is global, beurk !
	$timenow    = time;
	$timerel    = $timenow - $timebefore;
	$timebefore = $timenow;
	return($timerel);
}

exit if ($justfoldersizes);

# needed for setting flags
my $tohasuidplus = $to->has_capability("UIDPLUS");


@t_folders_list = sort @{$to->folders()};
foreach my $folder (@t_folders_list) {
	$t_folders_list{$folder}++;
}

print 
  "++++ Listing folders ++++\n",
  "From folders list: ", map("[$_] ",@f_folders),"\n",
  "To   folders list: ", map("[$_] ",@t_folders_list),"\n";

print 
  "From subscribed folders list: ", 
  map("[$_] ", sort keys(%subscribed_folder)), "\n" 
  if ($subscribed);

sub separator_invert {
	# The separator we hope we'll never encounter: 00000000
	my $o_sep="\000";

	my($f_fold, $f_sep, $t_sep) = @_;

	my $t_fold = $f_fold;
	$t_fold =~ s@\Q$t_sep@$o_sep@g;
	$t_fold =~ s@\Q$f_sep@$t_sep@g;
	$t_fold =~ s@\Q$o_sep@$f_sep@g;
	return($t_fold);
}

sub to_folder_name {
	my ($t_fold);
	my ($x_fold) = @_;
	# first we remove the prefix
	$x_fold =~ s/^\Q$f_prefix\E//;
	$debug and print "removed source prefix: [$x_fold]\n";
	$t_fold = separator_invert($x_fold,$f_sep, $t_sep);
	$debug and print "inverted   separators: [$t_fold]\n";
	# Adding the prefix supplied by namespace or the --prefix2 option
	$t_fold = $t_prefix . $t_fold 
	  unless(($t_prefix eq "INBOX" . $t_sep) and ($t_fold =~ m/^INBOX$/i));
	$debug and print "added   target prefix: [$t_fold]\n";

	# Transforming the folder name by the --regextrans2 option(s)
	foreach my $regextrans2 (@regextrans2) {
		$debug and print "eval \$t_fold =~ $regextrans2\n";
		eval("\$t_fold =~ $regextrans2");
		die("error: eval regextrans2 '$regextrans2': $@\n") if $@;
	}
	return($t_fold);
}

sub tests_flags_regex {
	
	my $string;
	ok('' eq flags_regex(''), "flags_regex, null string ''");
	ok('\Seen NonJunk $Spam' eq flags_regex('\Seen NonJunk $Spam'), 'flags_regex, nothing to do');
	ok('\Seen NonJunk $Spam' eq flags_regex('\Seen NonJunk $Spam'), 'flags_regex,');
	@regexflag = ('s/NonJunk//g');
	ok('\Seen  $Spam' eq flags_regex('\Seen NonJunk $Spam'), "flags_regex, remove NonJunk: 's/NonJunk//g'");
	@regexflag = ('s/\$Spam//g');
	ok('\Seen NonJunk ' eq flags_regex('\Seen NonJunk $Spam'), 'flags_regex, remove $Spam: '."'s/\$Spam//g'");
	
	@regexflag = ('s/\\\\Seen//g');
	
	ok(' NonJunk $Spam' eq flags_regex('\Seen NonJunk $Spam'), 'flags_regex, remove \Seen: '. "'s/\\\\\\\\Seen//g'");
	
	@regexflag = ('s/(\s|^)[^\\\\]\w+//g');
	ok('\Seen \Middle \End' eq flags_regex('\Seen NonJunk \Middle $Spam \End'), 'flags_regex, only \word [' . flags_regex('\Seen NonJunk \Middle $Spam \End'.']'));
	ok(' \Seen \Middle \End1' eq flags_regex('Begin \Seen NonJunk \Middle $Spam \End1 End'), 'flags_regex, only \word [' . flags_regex('Begin \Seen NonJunk \Middle $Spam \End1 End'.']'));

	
}

sub flags_regex {
	my ($flags_f) = @_;
	foreach my $regexflag (@regexflag) {
		$debug and print "eval \$flags_f =~ $regexflag\n";
		eval("\$flags_f =~ $regexflag");
		die("error: eval regexflag '$regexflag': $@\n") if $@;
	}
	return($flags_f);
}

sub acls_sync {
	my($f_fold, $t_fold) = @_;
	if ($syncacls) {
		my $f_hash = $from->getacl($f_fold)
		  or warn "Could not getacl for $f_fold: $@\n";
		my $t_hash = $to->getacl($t_fold)
		  or warn "Could not getacl for $t_fold: $@\n";
		my %users = map({ ($_, 1) } (keys(%$f_hash), keys(%$t_hash)));
		foreach my $user (sort(keys(%users))) {
			my $acl = $f_hash->{$user} || "none";
			print "acl $user: [$acl]\n";
			next if ($f_hash->{$user} && $t_hash->{$user} &&
				 $f_hash->{$user} eq $t_hash->{$user});
			unless ($dry) {
				print "setting acl $t_fold $user $acl\n";
				$to->setacl($t_fold, $user, $acl)
				  or warn "Could not set acl: $@\n";
			}
		}
	}
}


print "++++ Looping on each folder ++++\n";

FOLDER: foreach my $f_fold (@f_folders) {
	my $t_fold;
	print "From Folder [$f_fold]\n";
	$t_fold = to_folder_name($f_fold);
	print "To   Folder [$t_fold]\n";

	last FOLDER if $from->IsUnconnected();
	last FOLDER if   $to->IsUnconnected();

	unless ($from->select($f_fold)) {
		warn 
		"From Folder $f_fold: Could not select: ",
		$from->LastError,  "\n";
		$error++;
		next FOLDER;
	}
	if ( ! exists($t_folders_list{$t_fold})) {
		print "To   Folder $t_fold does not exist\n";
		print "Creating folder [$t_fold]\n";
		unless ($dry){
			unless ($to->create($t_fold)){
				#pondracek: AAPT Migration Special: Ignoring '.INBOX.INBOX.{something}' mailboxes as errors
				unless ($to->LastError =~ m/Mailbox already exists/) {
					warn "Couldn't create [$t_fold]: ",
					$to->LastError,"\n";
					$error++;
				} 
				next FOLDER;
			}
		}
		else{
			next FOLDER;
		}
	}
	
	acls_sync($f_fold, $t_fold);

	unless ($to->select($t_fold)) { 
		warn 
		"To   Folder $t_fold: Could not select: ",
		$to->LastError, "\n";
		$error++;
		next FOLDER;
	}
	
	if ($expunge){
		print "Expunging $f_fold and $t_fold\n";
		unless($dry) { $from->expunge() };
		#unless($dry) { $to->expunge() };
	}
	
	if ($subscribe and exists $subscribed_folder{$f_fold}) {
		print "Subscribing to folder $t_fold on destination server\n";
		unless($dry) { $to->subscribe($t_fold) };
	}
	
	next FOLDER if ($justfolders);

	last FOLDER if $from->IsUnconnected();
	last FOLDER if   $to->IsUnconnected();

	my @f_msgs = select_msgs($from);



	$debug and print "LIST FROM: ", scalar(@f_msgs), " messages [@f_msgs]\n";
	# internal dates on "TO" are after the ones on "FROM"
	# normally...
	my @t_msgs = select_msgs($to);
	
	$debug and print "LIST TO  : ", scalar(@t_msgs), " messages [@t_msgs]\n";

	my %f_hash = ();
	my %t_hash = ();
	
	print "++++ From [$f_fold] Parse 1 ++++\n";
	last FOLDER if $from->IsUnconnected();
	last FOLDER if   $to->IsUnconnected();

	my ($f_heads, $f_fir) = ({}, {});
	$f_heads = $from->parse_headers([@f_msgs], @useheader) if (@f_msgs);
	$debug and print "Time headers: ", timenext(), " s\n";
	last FOLDER if $from->IsUnconnected();

	$f_fir   = $from->fetch_hash("FLAGS", "INTERNALDATE", "RFC822.SIZE")
	  if (@f_msgs);
	$debug and print "Time fir: ", timenext(), " s\n";
	unless ($f_fir) {
		warn
		"From Folder $f_fold: Could not fetch_hash ",
		scalar(@f_msgs), " msgs: ", $from->LastError, "\n";
		$error++;
		next FOLDER;
	}
	last FOLDER if $from->IsUnconnected();

	foreach my $m (@f_msgs) {
		my $rc = parse_header_msg1($from, $m, $f_heads, $f_fir, "F", \%f_hash);
		if (!$rc) {
			my $reason = !defined($rc) ? "no header" : "duplicate";
			my $f_size = $f_fir->{$m}->{"RFC822.SIZE"} || 0;
			print "+ Skipping msg #$m:$f_size in folder $f_fold ($reason so we ignore this message)\n";
			$mess_size_total_skipped += $f_size;
			$mess_skipped += 1;
		}
	}
	$debug and print "Time headers: ", timenext(), " s\n";
	
	print "++++ To   [$t_fold] Parse 1 ++++\n";

	my ($t_heads, $t_fir) = ({}, {});
	$t_heads =   $to->parse_headers([@t_msgs], @useheader) if (@t_msgs);
	$debug and print "Time headers: ", timenext(), " s\n";
	last FOLDER if   $to->IsUnconnected();

	$t_fir   =   $to->fetch_hash("FLAGS", "INTERNALDATE", "RFC822.SIZE")
	  if (@t_msgs);
	$debug and print "Time fir: ", timenext(), " s\n";
	last FOLDER if   $to->IsUnconnected();
	foreach my $m (@t_msgs) {
		my $rc = parse_header_msg1($to, $m, $t_heads, $t_fir, "T", \%t_hash);
		if (!$rc) {
			my $reason = !defined($rc) ? "no header" : "duplicate";
			my $t_size = $t_fir->{$m}->{"RFC822.SIZE"} || 0;
			print "+ Skipping msg #$m:$t_size in 'to' folder $t_fold ($reason so we ignore this message)\n";
			#$mess_size_total_skipped += $msize;
			#$mess_skipped += 1;
		}
	}
	$debug and print "Time headers: ", timenext(), " s\n";

	print "++++ Verifying [$f_fold] -> [$t_fold] ++++\n";
	# messages in "from" that are not good in "to"
	
	my @f_hash_keys_sorted_by_uid 
	  = sort {$f_hash{$a}{'m'} <=> $f_hash{$b}{'m'}} keys(%f_hash);
	
	#print map { $f_hash{$_}{'m'} . " "} @f_hash_keys_sorted_by_uid;
	
	my @t_hash_keys_sorted_by_uid 
	  = sort {$t_hash{$a}{'m'} <=> $t_hash{$b}{'m'}} keys(%t_hash);

	
	if($delete2) {
		my @expunge;
		foreach my $m_id (@t_hash_keys_sorted_by_uid) {
			#print "$m_id ";
			unless (exists($f_hash{$m_id})) {
				my $t_msg  = $t_hash{$m_id}{'m'};
				my $flags  = $t_hash{$m_id}{'F'} || "";
				my $isdel  = $flags =~ /\B\\Deleted\b/ ? 1 : 0;
				print "deleting message $m_id  $t_msg\n"
				  if ! $isdel;
				push(@expunge,$t_msg) if $uidexpunge2;
				unless ($dry or $isdel) {
					$to->delete_message($t_msg);
					last FOLDER if $to->IsUnconnected();
				}
			}
		}

		my $cnt = scalar @expunge;
		if(@expunge and !$to->can("uidexpunge")) {
			warn "uidexpunge not supported (< IMAPClient 3.17)\n";
		}
		elsif(@expunge) {
			print "uidexpunge $cnt message(s)\n";
			$to->uidexpunge(\@expunge) if !$dry;
		}
	}

	MESS: foreach my $m_id (@f_hash_keys_sorted_by_uid) {
		my $f_size = $f_hash{$m_id}{'s'};
		my $f_msg = $f_hash{$m_id}{'m'};
		my $f_idate = $f_hash{$m_id}{'D'};
		
		if (defined $maxsize and $f_size > $maxsize) {
			print "+ Skipping msg #$f_msg:$f_size in folder $f_fold (exceeds maxsize limit $maxsize bytes)\n";
			$mess_size_total_skipped += $f_size;
			$mess_skipped += 1;
			next MESS;
		}
		$debug and print "+ key     $m_id #$f_msg\n";
		unless (exists($t_hash{$m_id})) {
			print "+ NO msg #$f_msg [$m_id] in $t_fold\n";
			# copy
			print "+ Copying msg #$f_msg:$f_size to folder $t_fold\n";
			last FOLDER if $from->IsUnconnected();
			last FOLDER if   $to->IsUnconnected();
			my $string;
			$string = $from->message_string($f_msg);
			unless (defined($string)) {
				warn
				"Could not fetch message #$f_msg from $f_fold: ",
				$from->LastError, "\n";
				$error++;
				$mess_size_total_error += $f_size;
				next MESS;
			}
			#print "AAAmessage_string[$string]ZZZ\n";
			#my $message_file = "tmp_imapsync_$$";
			#$from->select($f_fold);
			#unlink($message_file);
			#$from->message_to_file($message_file, $f_msg) or do {
			#	warn "Could not put message #$f_msg to file $message_file",
			#	$from->LastError;
			#	$error++;
			#	$mess_size_total_error += $f_size;
			#	next MESS;
			#};
			#$string = file_to_string($message_file);
			#print "AAA1[$string]ZZZ\n";
			#unlink($message_file);
			if (@regexmess) {
				$string = regexmess($string);
				
				#string_to_file($string, $message_file);
			}

			sub tests_regexmess {
				
				ok("blabla" eq regexmess("blabla"), "regexmess, nothing to do");
				@regexmess = ('s/p/Z/g');
				ok("ZoZoZo" eq regexmess("popopo"), "regexmess, s/p/Z/g");
				@regexmess = 's{c}{C}gxms';
				#print "RRR¤\n", regexmess("H1: abc\nH2: cde\n\nBody abc"), "\n";
				ok("H1: abC\nH2: Cde\n\nBody abC" 
					   eq regexmess("H1: abc\nH2: cde\n\nBody abc"), 
				   "regexmess, c->C");
				
			}

			sub regexmess {
				my ($string) = @_;
				foreach my $regexmess (@regexmess) {
					$debug and print "eval \$string =~ $regexmess\n";
					eval("\$string =~ $regexmess");
					die("error: eval regexmess '$regexmess': $@\n") if $@;
				}
				return($string);
			}

			$debug and print 
				"=" x80, "\n", 
				"F message content begin next line\n",
				$string,
				"F message content ended on previous line\n", "=" x 80, "\n";
			my $d = "";
			if ($syncinternaldates) {
				$d = $f_idate;
				$debug and print "internal date from 1: [$d]\n";
				$d = good_date($d);
				$debug and print "internal date from 1: [$d] (fixed)\n";
			}
			
			if ($idatefromheader) {
				
				$d = $from->get_header($f_msg,"Date");
				$debug and print "header date from 1: [$d]\n";
				$d = good_date($d);
				$debug and print "header date from 1: [$d] (fixed)\n";
			}

			sub good_date {
				my ($d) = @_;
				$d = UnixDate(ParseDate($d), "%d-%b-%Y %H:%M:%S %z");
				$d = "\"$d\"";
				return($d);
			}

			my $flags_f = $f_hash{$m_id}{'F'} || "";
			# RFC 2060: This flag can not be altered by any client
			$flags_f =~ s@\\Recent\s?@@gi;
			$flags_f = flags_regex($flags_f) if @regexflag;
			
			my $new_id;
			print "flags from: [$flags_f][$d]\n";
			last FOLDER if $from->IsUnconnected();
			last FOLDER if   $to->IsUnconnected();
			unless ($dry) {
				
				if ($OSNAME eq "MSWin32") {
					$new_id = $to->append_string($t_fold,$string, $flags_f, $d);
				}
				else {
					# just back to append_string since append_file 3.05 does not work. 
					#$new_id = $to->append_file($t_fold, $message_file, "", $flags_f, $d);
					# append_string 3.05 does not work too some times with $d unset.
					$new_id = $to->append_string($t_fold,$string, $flags_f, $d);
				}
				unless($new_id){
					no warnings 'uninitialized';
					warn "Couldn't append msg #$f_msg (Subject:[".
					  $from->subject($f_msg)."]) to folder $t_fold: ",
					  $to->LastError, "\n";
					$error++;
					$mess_size_total_error += $f_size;
					next MESS;
				}
				else{
					# good
					# $new_id is an id if the IMAP server has the 
					# UIDPLUS capability else just a ref
					print "Copied msg id [$f_msg] to folder $t_fold msg id [$new_id]\n";
					$mess_size_total_trans += $f_size;
					$mess_trans += 1;
					if($delete) {
						print "Deleting msg #$f_msg in folder $f_fold\n";
						unless($dry) {
							$from->delete_message($f_msg);
							last FOLDER if $from->IsUnconnected();
							$from->expunge() if ($expunge);
							last FOLDER if $from->IsUnconnected();
						}
					}
				}
			}
			else{
				$mess_skipped_dry += 1;
			}
			#unlink($message_file);
			next MESS;
		}
		else{
			$debug and print "Message id [$m_id] found in t:$t_fold\n";
			$mess_size_total_skipped += $f_size;
			$mess_skipped += 1;
		}
		
		$fast and next MESS;
		#$debug and print "MESSAGE $m_id\n";
		my $t_size = $t_hash{$m_id}{'s'};
		my $t_msg  = $t_hash{$m_id}{'m'};

		# used cached flag values for efficiency
		my $flags_f = $f_hash{$m_id}{'F'} || "";
		my $flags_t = $t_hash{$m_id}{'F'} || "";

		# RFC 2060: This flag can not be altered by any client
		$flags_f =~ s@\\Recent\s?@@gi;
		$flags_f = flags_regex($flags_f) if @regexflag;

		# compare flags - add missing flags
		my @ff = split(' ', $flags_f );
		my %ft = map { $_ => 1 } split(' ', $flags_t );
		my @flags_a = map { exists $ft{$_} ? () : $_ } @ff;

		$debug and print "Setting flags(@flags_a) ffrom($flags_f) fto($flags_t) on msg #$t_msg in $t_fold\n";

		# This adds or changes flags but no flag are removed with this
		if (!$dry and @flags_a and !$to->store($t_msg, "+FLAGS.SILENT (@flags_a)") ) {
			warn "Could not add flags '@flags_a' flagf '$flags_f'",
			  " flagt '$flags_t' on msg #$t_msg in $t_fold: ",
			  $to->LastError, "\n";
			#$error++;
		}
		last FOLDER if   $to->IsUnconnected();

		$debug and do {
			my @flags_t = @{ $to->flags($t_msg) || [] };
			last FOLDER if   $to->IsUnconnected();

			print "flags from: $flags_f\n",
			      "flags to  : @flags_t\n";

			print "Looking dates\n"; 
			#my $d_f = $from->internaldate($f_msg);
			#my $d_t = $to->internaldate($t_msg);
			my $d_f = $f_hash{$m_id}{'D'};
			my $d_t = $t_hash{$m_id}{'D'};
			print 
			  "idate from: $d_f\n",
			    "idate to  : $d_t\n";
			
			#unless ($d_f eq $d_t) {
			#	print "!!! Dates differ !!!\n";
			#}
		};
		unless (($f_size == $t_size) or $skipsize) {
			# Bad size
			print 
			"Message $m_id SZ_BAD  f:$f_msg:$f_size t:$t_msg:$t_size\n";
			# delete in to and recopy ?
			# NO recopy CODE HERE. to be written if needed.
			$error++;
			if ($opt_G){
				print "Deleting msg f:#$t_msg in folder $t_fold\n";
				$to->delete_message($t_msg) unless ($dry);
				last FOLDER if   $to->IsUnconnected();
			}
		}
		else {
	    		# Good 
			$debug and print
			"Message $m_id SZ_GOOD f:$f_msg:$f_size t:$t_msg:$t_size\n";
			if($delete) {
				print "Deleting msg #$f_msg in folder $f_fold\n";
				unless($dry) {
					$from->delete_message($f_msg);
					last FOLDER if $from->IsUnconnected();
					$from->expunge() if ($expunge);
					last FOLDER if $from->IsUnconnected();
				}
			}
		}
	}
	if ($expunge1){
		print "Expunging source folder $f_fold\n";
		unless($dry) { $from->expunge() };
	}
	if ($expunge2){
		print "Expunging target folder $t_fold\n";
		unless($dry) { $to->expunge() };
	}

print "Time: ", timenext(), " s\n";
}

print "++++ End looping on each folder ++++\n";


# FOLDER loop is exited any time a connection is lost be sure to log it!
# Example: 
# lost_connection($from,"(from) host1 [$host1]");
# 
# can be tested with a "killall /usr/bin/imapd" (or equivalent) in command line.
#
sub _filter {
	my $str = shift or return "";
	my $sz  = 64;
        my $len = length($str);
	if ( ! $debug and $len > $sz*2 ) {
		my $beg = substr($str, 0, $sz);
		my $end = substr($str, -$sz, $sz);
		$str = $beg . "..." . $end;
	}
	$str =~ s/\012?\015$//;
	return "(len=$len) " . $str;
}

sub lost_connection {
	my($imap, $error_message) = @_;
	if ( $imap->IsUnconnected() ) {
		$error++;
		my $lcomm = $imap->LastIMAPCommand || "";
		my $einfo = $imap->LastError || @{$imap->History}[-1] || "";

		# if string is long try reduce to a more reasonable size
		$lcomm = _filter($lcomm);
		$einfo = _filter($einfo);
		warn("error: last command: $lcomm\n") if ($debug && $lcomm);
		warn("error: lost connection $error_message", $einfo, "\n");
		return(1);
	}else{
		return(0);
	}
}

$from->logout() unless (lost_connection($from,"(from) host1 [$host1]"));
$to->logout()   unless (lost_connection($to,"(to) host2 [$host2]"));

$timeend = time();

$timediff = $timeend - $timestart;

stats();

exit(1) if($error);

sub select_msgs {
	my ($imap) = @_;
	my (@msgs,@max,@min,@union,@inter);
	
	unless (defined($maxage) or defined($minage)) {
		@msgs = $imap->search("ALL");
		return(@msgs);
	}
	if (defined($maxage)) {
		@max = $imap->sentsince(time - 86400 * $maxage);
	}
	if (defined($minage)) {
		@min = $imap->sentbefore(time - 86400 * $minage);
	}
      SWITCH: {
		unless(defined($minage)) {@msgs = @max; last SWITCH};
		unless(defined($maxage)) {@msgs = @min; last SWITCH};
		my (%union, %inter); 
		foreach my $m (@min, @max) {$union{$m}++ && $inter{$m}++}
		@inter = keys(%inter);
		@union = keys(%union);
		# normal case
		if ($minage <= $maxage)  {@msgs = @inter; last SWITCH};
		# just exclude messages between
		if ($minage > $maxage)  {@msgs = @union; last SWITCH};
		
	}
	return(@msgs);
}

sub stats {
	print "++++ Statistics ++++\n";
	print "Time                   : $timediff sec\n";
	print "Messages transferred   : $mess_trans ";
	print "(could be $mess_skipped_dry without dry mode)" if ($dry);
	print "\n";
	print "Messages skipped       : $mess_skipped\n";
	print "Total bytes transferred: $mess_size_total_trans\n";
	print "Total bytes skipped    : $mess_size_total_skipped\n";
	print "Total bytes error      : $mess_size_total_error\n";
	print "Detected $error errors\n\n";
	print thank_author();
}

sub thank_author {

	return(join("", "Happy with this free, open and gratis GPL software?\n",
	  "Please, thank the author (Gilles LAMIRAL) by giving him a book:\n",
	  "http://www.amazon.com/gp/registry/wishlist/1C9UNDIH3P7R7/\n",
          "or rate imapsync at http://freshmeat.net/projects/imapsync/\n"));
}

sub get_options {
	my $numopt = scalar(@ARGV);
	my $argv   = join("¤", @ARGV);
	
	$test_builder = Test::More->builder;
	$test_builder->no_ending(1);

	if($argv =~ m/-delete¤2/) {
		print "May be you mean --delete2 instead of --delete 2\n";
		exit 1;
	}
        my $opt_ret = GetOptions(
                                   "debug!"       => \$debug,
                                   "debugimap!"   => \$debugimap,
                                   "host1=s"     => \$host1,
                                   "host2=s"     => \$host2,
                                   "port1=i"     => \$port1,
                                   "port2=i"     => \$port2,
                                   "user1=s"     => \$user1,
                                   "user2=s"     => \$user2,
                                   "password1=s" => \$password1,
                                   "password2=s" => \$password2,
                                   "passfile1=s" => \$passfile1,
                                   "passfile2=s" => \$passfile2,
				   "authmd5!"    => \$authmd5,
                                   "sep1=s"      => \$sep1,
                                   "sep2=s"      => \$sep2,
				   "folder=s"    => \@folder,
				   "folderrec=s" => \@folderrec,
				   "include=s"   => \@include,
				   "exclude=s"   => \@exclude,
				   "prefix1=s"   => \$prefix1,
				   "prefix2=s"   => \$prefix2,
				   "regextrans2=s" => \@regextrans2,
				   "regexmess=s" => \@regexmess,
				   "regexflag=s" => \@regexflag,
                                   "delete!"     => \$delete,
                                   "delete2!"    => \$delete2,
                                   "syncinternaldates!" => \$syncinternaldates,
                                   "idatefromheader!" => \$idatefromheader,
                                   "syncacls!"   => \$syncacls,
				   "maxsize=i"   => \$maxsize,
				   "maxage=i"    => \$maxage,
				   "minage=i"    => \$minage,
				   "buffersize=i" => \$buffersize,
				   "foldersizes!" => \$foldersizes,
                                   "dry!"        => \$dry,
                                   "expunge!"    => \$expunge,
                                   "expunge1!"    => \$expunge1,
                                   "expunge2!"    => \$expunge2,
                                   "uidexpunge2!" => \$uidexpunge2,
                                   "subscribed!" => \$subscribed,
                                   "subscribe!"  => \$subscribe,
				   "justbanner!" => \$justbanner,
                                   "justconnect!"=> \$justconnect,
                                   "justfolders!"=> \$justfolders,
				   "justfoldersizes!" => \$justfoldersizes,
				   "fast!"       => \$fast,
                                   "version"     => \$version,
                                   "help"        => \$help,
                                   "timeout=i"   => \$timeout,
				   "skipheader=s" => \$skipheader,
				   "useheader=s" => \@useheader,
				   "skipsize!"   => \$skipsize,
				   "allowsizemismatch!" => \$allowsizemismatch,
				   "fastio1!"     => \$fastio1,
				   "fastio2!"     => \$fastio2,
				   "ssl1!"        => \$ssl1,
				   "ssl2!"        => \$ssl2,
				   "authmech1=s" => \$authmech1,
				   "authmech2=s" => \$authmech2,
				   "authuser1=s" => \$authuser1,
				   "authuser2=s" => \$authuser2,
				   "split1=i"    => \$split1,
				   "split2=i"    => \$split2,
				   "reconnectretry1=i" => \$reconnectretry1,
				   "reconnectretry2=i" => \$reconnectretry2,
                                   "tests"       => \$tests,
                                   "allow3xx!"   => \$allow3xx,
                                   "justlogin!"   => \$justlogin,
                                  );
	
        $debug and print "get options: [$opt_ret]\n";

	# just the version
        print "$VERSION\n" and exit if ($version) ;
	
	if ($tests) {
		$test_builder->no_ending(0);
		tests();
		exit;
	}


	load_modules();

	# exit with --help option or no option at all
        usage() and exit if ($help or ! $numopt) ;

	# don't go on if options are not all known.
        exit(EX_USAGE()) unless ($opt_ret) ;

}


sub load_modules {

	require IO::Socket::SSL if ($ssl1 or $ssl2);
	require Date::Manip if ($syncinternaldates || $idatefromheader) ;

#	require Term::ReadKey if (
#		(not($password1 or $passfile1)) 
#	     or (not($password2 or $passfile2))
#        or (not $help));

	#require Data::Dumper if ($debug);
}



sub parse_header_msg1 {
	my ($imap, $m_uid, $s_heads, $s_fir, $s, $s_hash) = @_;
	
	my $head = $s_heads->{$m_uid};
	my $headnum =  scalar(keys(%$head));
	$debug and print "Head NUM:", $headnum, "\n";
	unless($headnum) { print "Warning: no header used or found for message $m_uid\n"; }
	my $headstr;
	
	foreach my $h (sort keys(%$head)){
		foreach my $val (sort @{$head->{$h}}) {
			# no 8-bit data in headers !
			$val =~ s/[\x80-\xff]/X/g;
			
			# remove the first blanks (dbmail bug ?)
			# and uppercase  header keywords 
			# (dbmail and dovecot)
			$val =~ s/^\s*(.+)$/$1/;
			
			#my $H = uc($h);
			my $H = "$h: $val";
			# show stuff in debug mode
			$debug and print "${s}H $H:", $val, "\n";
			
			if ($skipheader and $H =~ m/$skipheader/i) {
				$debug and print "Skipping header $H\n";
				next;
			}
			#$headstr .= "$H:". $val;
			$headstr .= "$H";
		}
	}
	#return unless ($headstr);
	unless ($headstr){
		# taking everything is too heavy,
		# should take only 1 Ko
		#print "no header so taking everything\n";
		#$headstr = $imap->message_string($m_uid);
		
		print "no header so we ignore this message\n";
		return undef;
	}
	my $size  = $s_fir->{$m_uid}->{"RFC822.SIZE"};
	my $flags = $s_fir->{$m_uid}->{"FLAGS"};
	my $idate = $s_fir->{$m_uid}->{"INTERNALDATE"};
	$size = length($headstr) unless ($size);
	my $m_md5 = md5_base64($headstr);	
	$debug and print "$s msg $m_uid:$m_md5:$size\n";
	my $key;
        if ($skipsize) {
                $key = "$m_md5";
        }
	else {
                $key = "$m_md5:$size";
        }
	# 0 return code is used to identify duplicate message hash
	return 0 if exists $s_hash->{"$key"};
	$s_hash->{"$key"}{'5'} = $m_md5;
	$s_hash->{"$key"}{'s'} = $size;
	$s_hash->{"$key"}{'D'} = $idate;
	$s_hash->{"$key"}{'F'} = $flags;
	$s_hash->{"$key"}{'m'} = $m_uid;
}


sub  firstline {
        # extract the first line of a file (without \n)

        my($file) = @_;
        my $line  = "";
        
        open FILE, $file or die("error [$file]: $! ");
        chomp($line = <FILE>);
        close FILE;
        $line = ($line) ? $line: "error !EMPTY! [$file]";
        return $line;
}


sub file_to_string {
	my($file) = @_;
	my @string;
	open FILE, $file or die("error [$file]: $! ");
	@string = <FILE>;
	close FILE;
	return join("", @string);
}


sub string_to_file {
	my($string, $file) = @_;
	sysopen(FILE, $file,O_WRONLY|O_TRUNC|O_CREAT, 0600) or die("$! $file");
	print FILE $string;
	close FILE;
}



sub usage {
	my $localhost_info = localhost_info();
	my $thank = thank_author();
        print <<EOF;

usage: $0 [options]

Several options are mandatory. 

--host1       <string> : "from" imap server. Mandatory.
--port1       <int>    : port to connect on host1. Default is 143.
--user1       <string> : user to login on host1. Mandatory.
--authuser1   <string> : user to auth with on host1 (admin user). 
                         Avoid using --authmech1 SOMETHING with --authuser1.
--password1   <string> : password for the user1. Dangerous, use --passfile1
--passfile1   <string> : password file for the user1. Contains the password.
--host2       <string> : "destination" imap server. Mandatory.
--port2       <int>    : port to connect on host2. Default is 143.
--user2       <string> : user to login on host2. Mandatory.
--authuser2   <string> : user to auth with on host2 (admin user).
--password2   <string> : password for the user2. Dangerous, use --passfile2
--passfile2   <string> : password file for the user2. Contains the password.
--noauthmd5            : don't use MD5 authentification.
--authmech1   <string> : auth mechanism to use with host1:
                         PLAIN, LOGIN, CRAM-MD5 etc. Use UPPERCASE.
--authmech2   <string> : auth mechanism to use with host2. See --authmech1
--ssl1                 : use an SSL connection on host1.
--ssl2                 : use an SSL connection on host2.
--folder      <string> : sync this folder.
--folder      <string> : and this one, etc.
--folderrec   <string> : sync this folder recursively.
--folderrec   <string> : and this one, etc.
--include     <regex>  : sync folders matching this regular expression
--include     <regex>  : or this one, etc.
                         in case both --include --exclude options are
                         use, include is done before.
--exclude     <regex>  : skips folders matching this regular expression
                         Several folders to avoid:
			  --exclude 'fold1|fold2|f3' skips fold1, fold2 and f3.
--exclude     <regex>  : or this one, etc.
--prefix1     <string> : remove prefix to all destination folders 
                         (usually INBOX. for cyrus imap servers)
                         you can use --prefix1 if your source imap server 
                         does not have NAMESPACE capability.
--prefix2     <string> : add prefix to all destination folders 
                         (usually INBOX. for cyrus imap servers)
                         use --prefix2 if your target imap server does not
                         have NAMESPACE capability.
--regextrans2 <regex>  : Apply the whole regex to each destination folders.
--regextrans2 <regex>  : and this one. etc.
                         When you play with the --regextrans2 option, first
                         add also the safe options --dry --justfolders
                         Then, when happy, remove --dry, remove --justfolders
--regexmess   <regex>  : Apply the whole regex to each message before transfer.
                         Example: 's/\\000/ /g' # to replace null by space.
--regexmess   <regex>  : and this one.
--regexmess   <regex>  : and this one, etc.
--regexflag   <regex>  : Apply the whole regex to each flags list.
                         Example: 's/\"Junk"//g' # to remove "Junk" flag.
--regexflag   <regex>  : and this one, etc.
--sep1        <string> : separator in case namespace is not supported.
--sep2        <string> : idem.
--delete               : delete messages on source imap server after
                         a successful transfer. Useful in case you
                         want to migrate from one server to another one.
			 With imap, delete tags messages as deleted, they
			 are not really deleted. See expunge.
--delete2              : delete messages on the destination imap server that
                         are not on the source server.
--expunge              : expunge messages on source account.
                         expunge really deletes messages marked deleted.
                         expunge is made at the beginning on the 
                         source server only. newly transferred messages
                         are expunged if option --expunge is given.
                         no expunge is done on destination account but
                         it will change in future releases.
--expunge1             : expunge messages on source account.
--expunge2             : expunge messages on target account.
--uidexpunge2          : uidexpunge messages on the destination imap server
                         that are not on the source server, requires --delete2
--syncinternaldates    : sets the internal dates on host2 same as host1.
                         Turned on by default.
--idatefromheader      : sets the internal dates on host2 same as the 
                         "Date:" headers. 
--buffersize  <int>    : sets the size of a block of I/O.
--maxsize     <int>    : skip messages larger than <int> bytes
--maxage      <int>    : skip messages older than <int> days.
                         final stats (skipped) don't count older messages
			 see also --minage
--minage      <int>    : skip messages newer than <int> days.
                         final stats (skipped) don't count newer messages
                         You can do (+ are the messages selected):
                         past|----maxage+++++++++++++++>now
                         past|+++++++++++++++minage---->now
                         past|----maxage+++++minage---->now (intersection)
                         past|++++minage-----maxage++++>now (union)
--skipheader  <regex>  : Don't take into account header keyword 
                         matching <string> ex: --skipheader 'X.*'
--useheader   <string> : Use this header to compare messages on both sides.
                         Ex: Message-ID or Subject or Date.
--useheader   <string>   and this one, etc.
--skipsize             : Don't take message size into account.
--allowsizemismatch    : allow RFC822.SIZE != fetched msg size
                         consider --skipsize to avoid duplicate messages
                         when running syncs more than one time per mailbox
--dry                  : do nothing, just print what would be done.
--subscribed           : transfers subscribed folders.
--subscribe            : subscribe to the folders transferred on the 
                         "destination" server that are subscribed
                         on the "source" server.
--nofoldersizes        : Do not calculate the size of each folder in bytes
                         and message counts. Default is to calculate them.
--justfoldersizes      : exit after printed the folder sizes.
--syncacls             : Synchronises acls (Access Control Lists).
--nosyncacls           : Does not synchronise acls. This is the default.
--debug                : debug mode.
--debugimap            : imap debug mode.
--version              : print software version.
--justconnect          : just connect to both servers and print useful
                         information. Need only --host1 and --host2 options.
--justlogin            : just login to both servers with users credentials 
                         and exit.
--justfolders          : just do things about folders (ignore messages).
--fast                 : be faster (just does not sync flags).
--reconnectretry1 <int>: reconnect if connection is lost up to <int> times
--reconnectretry2 <int>: reconnect if connection is lost up to <int> times
--split1     <int>     : split the requests in several parts on source server.
                         <int> is the number of messages handled per request.
                         default is like --split1 1000
--split2     <int>     : same thing on the "destination" server.
--fastio1              : use fastio with the "from" server.
--fastio2              : use fastio with the "destination" server.
--timeout     <int>    : imap connect timeout.
--help                 : print this.

Example: to synchronise imap account "foo" on "imap.truc.org"
                    to  imap account "bar" on "imap.trac.org"
                    with foo password stored in /etc/secret1
                    and  bar password stored in /etc/secret2

$0 \\
   --host1 imap.truc.org --user1 foo --passfile1 /etc/secret1 \\
   --host2 imap.trac.org --user2 bar --passfile2 /etc/secret2

$localhost_info
$rcs

$thank
EOF
}



sub tests {
	
      SKIP: {
		skip "No test in normal run" if (not $tests);
		tests_folder_routines();
		tests_compare_lists();
		tests_regexmess();
		tests_flags_regex();
	}
}

sub override_imapclient {
no warnings 'redefine';
no strict 'subs';

use constant Unconnected => 0;
use constant Connected         => 1;            # connected; not logged in
use constant Authenticated => 2;                # logged in; no mailbox selected
use constant Selected => 3;                     # mailbox selected
use constant INDEX => 0;                        # Array index for output line number
use constant TYPE => 1;                         # Array index for line type 
                                                #    (either OUTPUT, INPUT, or LITERAL)
use constant DATA => 2;                         # Array index for output line data
use constant NonFolderArg => 1;                 # Value to pass to Massage to 
                                                # indicate non-folder argument


*Mail::IMAPClient::append_file = sub  {

        my $self        = shift;
        my $folder      = $self->Massage(shift);
        my $file        = shift; 
        my $control     = shift || undef;
        my $count       = $self->Count($self->Count+1);
	my $flags       = shift || undef;
	my $date        = shift || undef;
	
	if (defined($flags)) {
                $flags =~ s/^\s+//g;
                $flags =~ s/\s+$//g;
        }
	
        if (defined($date)) {
                $date =~ s/^\s+//g;
                $date =~ s/\s+$//g;
        }
	
        $flags = "($flags)"  if $flags and $flags !~ /^\(.*\)$/ ;
        $date  = qq/"$date"/ if $date  and $date  !~ /^"/       ;
	

        unless ( -f $file ) {
                $self->LastError("File $file not found.\n");
                return undef;
        }

        my $fh = IO::File->new($file) ;

        unless ($fh) {
                $self->LastError("Unable to open $file: $!\n");
                $@ = "Unable to open $file: $!" ;
                carp "unable to open $file: $!";
                return undef;
        }

        my $bare_nl_count = scalar grep { /^\x0a$|[^\x0d]\x0a$/} <$fh>;

        seek($fh,0,0);

        my $clear = $self->Clear;

        $self->Clear($clear)
                if $self->Count >= $clear and $clear > 0;

        my $length = ( -s $file ) + $bare_nl_count;

	my $string = "$count APPEND $folder " .
	             ( $flags ? "$flags " : ""       ) .
	             ( $date ? "$date " : ""         ) .
	             "{" . $length  . "}\x0d\x0a" ;
	
        $self->_record($count,[ $self->_next_index($count), "INPUT", "$string" ] );

        my $feedback = $self->_send_line("$string");

        unless ($feedback) {
                $self->LastError("Error sending '$string' to IMAP: $!\n");
                $fh->close;
                return undef;
        }

        my ($code, $output) = ("","");

        until ( $code ) {
                $output = $self->_read_line or $fh->close, return undef;
                foreach my $o (@$output) {
                        $self->_record($count,$o);              # $o is already an array ref
                      ($code) = $o->[DATA] =~ /(^\+|^\d+\sNO|^\d+\sBAD)/i; 
                      if ($o->[DATA] =~ /^\*\s+BYE/) {
                              carp $o->[DATA];
                                $self->State(Unconnected);
                                $fh->close;
                                return undef ;
                      } elsif ( $o->[DATA]=~ /^\d+\s+(NO|BAD)/i ) {
                              carp $o->[DATA];
                                $fh->close;
                                return undef;
                        }
                }
        }

        {       # Narrow scope
                # Slurp up headers: later we'll make this more efficient I guess
                local $/ = "\x0d\x0a\x0d\x0a"; 
                my $text = <$fh>;
                $text =~ s/\x0d?\x0a/\x0d\x0a/g;
                $self->_record($count,[ $self->_next_index($count), "INPUT", "{From file $file}" ] ) ;
                $feedback = $self->_send_line($text);

                unless ($feedback) {
                        $self->LastError("Error sending append msg text to IMAP: $!\n");
                        $fh->close;
                        return undef;
                }
                _debug($self, "control points to $$control\n") if ref($control) and $self->Debug;
                $/ =    ref($control) ?  "\x0a" : $control ? $control :         "\x0a";
                while (defined($text = <$fh>)) {
                        $text =~ s/\x0d?\x0a/\x0d\x0a/g;
                        $self->_record( $count,
                                        [ $self->_next_index($count), "INPUT", "{from $file}\x0d\x0a" ] 
                        );
                        $feedback = $self->_send_line($text,1);

                        unless ($feedback) {
                                $self->LastError("Error sending append msg text to IMAP: $!\n");
                                $fh->close;
                                return undef;
                        }
                }
                $feedback = $self->_send_line("\x0d\x0a");

                unless ($feedback) {
                        $self->LastError("Error sending append msg text to IMAP: $!\n");
                        $fh->close;
                        return undef;
                }
        } 

        # Now for the crucial test: Did the append work or not?
        ($code, $output) = ("","");

        my $uid = undef;
        until ( $code ) {
                $output = $self->_read_line or return undef;
                foreach my $o (@$output) {
                        $self->_record($count,$o);              # $o is already an array ref
                      $self->_debug("append_file: Deciding if " . $o->[DATA] . " has the code.\n") 
                                if $self->Debug;
                      ($code) = $o->[DATA]  =~ /^\d+\s(NO|BAD|OK)/i; 
                        # try to grab new msg's uid from o/p
                      $o->[DATA]  =~ m#UID\s+\d+\s+(\d+)\]# and $uid = $1; 
                      if ($o->[DATA] =~ /^\*\s+BYE/) {
                              carp $o->[DATA];
                                $self->State(Unconnected);
                                $fh->close;
                                return undef ;
                      } elsif ( $o->[DATA]=~ /^\d+\s+(NO|BAD)/i ) {
                              carp $o->[DATA];
                                $fh->close;
                                return undef;
                        }
                }
        }
        $fh->close;

        if ($code !~ /^OK/i) {
                return undef;
        }


        return defined($uid) ? $uid : $self;
};




*Mail::IMAPClient::fetch_hash = sub {
	# taken from original lib, 
	# just added split code.
        my $self = shift;
        my $hash = ref($_[-1]) ? pop @_ : {};
        my @words = @_;
        for (@words) { 
                s/([\( ])FAST([\) ])/${1}FLAGS INTERNALDATE RFC822\.SIZE$2/i  ;
                s/([\( ])FULL([\) ])/${1}FLAGS INTERNALDATE RFC822\.SIZE ENVELOPE BODY$2/i  ;
        }
        my $msgref_all = scalar($self->messages);
	my $split = $self->Split() || scalar(@$msgref_all);
	while(my @msgs = splice(@$msgref_all, 0, $split)) {
	#print "SPLIT: @msgs\n";
	my $msgref = \@msgs;
	my $output = scalar($self->fetch($msgref,"(" . join(" ",@_) . ")")) 
        ; #     unless grep(/\b(?:FAST|FULL)\b/i,@words);
        my $x;
        for ($x = 0;  $x <= $#$output ; $x++) {
                my $entry = {};
                my $l = $output->[$x];
                if ($self->Uid) {       
                        my($uid) = $l =~ /\((?:.* )?UID (\d+).*\)/i;
                        next unless $uid;
                        if ( exists $hash->{$uid} ) {
                                $entry = $hash->{$uid} ;
                        }
			else {
                                $hash->{$uid} ||= $entry;
                        }
                }
		else {
                        my($mid) = $l =~ /^\* (\d+) FETCH/i;
                        next unless $mid;
                        if ( exists $hash->{$mid} ) {
                                $entry = $hash->{$mid} ;
                        }
			else {
                                $hash->{$mid} ||= $entry;
                        }
                }
                        
                foreach my $w (@words) {
                   if ( $l =~ /\Q$w\E\s*$/i ) {
                        $entry->{$w} = $output->[$x+1];
                        $entry->{$w} =~ s/(?:\x0a?\x0d)+$//g;
                        chomp $entry->{$w};
                   }
		   else {
                        $l =~ /\(           # open paren followed by ... 
                                (?:.*\s)?   # ...optional stuff and a space
                                \Q$w\E\s    # escaped fetch field<sp>
                                (?:"        # then: a dbl-quote
                                  (\\.|   # then bslashed anychar(s) or ...
                                   [^"]+)   # ... nonquote char(s)
                                "|          # then closing quote; or ...
                                \(          # ...an open paren
                                  (\\.|     # then bslashed anychar or ...
                                   [^\)]+)  # ... non-close-paren char
                                \)|         # then closing paren; or ...
                                (\S+))      # unquoted string
                                (?:\s.*)?   # possibly followed by space-stuff
                                \)          # close paren
                        /xi;
                        $entry->{$w}=defined($1)?$1:defined($2)?$2:$3;
                   }
                }
        }
}
        return wantarray ? %$hash : $hash;
};



*Mail::IMAPClient::login = sub {
        my $self = shift;
        return $self->authenticate($self->Authmechanism,$self->Authcallback) 
                if $self->{Authmechanism};

        my $id   = $self->User;
        my $has_quotes = $id =~ /^".*"$/ ? 1 : 0;
        my $string =    "Login " . ( $has_quotes ? $id : qq("$id") ) . 
	                " " . $self->Password . "\r\n";
        $self->_imap_command($string) 
                and $self->State(Authenticated);
        # $self->folders and $self->separator unless $self->NoAutoList;
        unless ( $self->IsAuthenticated) {
                my($carp)       =  $self->LastError;
                $carp           =~ s/^[\S]+ ([^\x0d\x0a]*)\x0d?\x0a/$1/;
                carp $carp unless defined wantarray;
                return undef;
        };
        return $self;
};


*Mail::IMAPClient::get_header = sub {
        my($self , $msg, $header ) = @_;
        my $val;
        
	#eval { $val = $self->parse_headers([$msg],$header)->{$header}[0] };
	my $h = $self->parse_headers([$msg],$header);
	#require Data::Dumper;
	#print Data::Dumper->Dump([$h]);
        #$val = $self->parse_headers([$msg],$header)->{$header}[0];
	
	$val = $h->{$msg}{$header}[0];
        return defined($val)? $val : undef;
};


*Mail::IMAPClient::parse_headers = sub {
        my($self,$msgspec_all,@fields) = @_;
        my(%fieldmap) = map { ( lc($_),$_ )  } @fields;
        my $msg; my $string; my $field;
	#print ref($msgspec_all), "\n";
	#if(ref($msgspec_all) eq 'HASH') {
    #    print ref($msgspec_all), "\n";
		#$msgspec_all = [$msgspec_all];
	#}

	unless(ref($msgspec_all) eq 'ARRAY') {
		print "parse_headers want an ARRAY ref\n";
		#exit 1;
		return undef;
	}
	
	my $headers = {};       # hash from message ids to header hash
	my $split = $self->Split() || scalar(@$msgspec_all);
	while(my @msgs = splice(@$msgspec_all, 0, $split)) {
		$debug and print "SPLIT: @msgs\n";
		my $msgspec = \@msgs;

        # Make $msg a comma separated list, of messages we want
        $msg = $self->Range($msgspec);
		
        if ($fields[0]  =~      /^[Aa][Ll]{2}$/         ) { 

                $string =       "$msg body" . 
                # use ".peek" if Peek parameter is a) defined and true, 
                #       or b) undefined, but not if it's defined and untrue:

                (       defined($self->Peek)            ? 
                        ( $self->Peek ? ".peek" : "" )  : 
                        ".peek" 
                ) .  "[header]"                         ; 

        }else {
                $string =       "$msg body" .
                # use ".peek" if Peek parameter is a) defined and true, or 
                # b) undefined, but not if it's defined and untrue:

                ( defined($self->Peek)                  ? 
                        ( $self->Peek ? ".peek" : "" )  : 
                        ".peek" 
                ) .  "[header.fields (" . join(" ",@fields)     . ')]' ;
        }

        my @raw=$self->fetch(   $string ) or return undef;

        
        my $h = 0;              # reference to hash of current msgid, or 0 between msgs
        
        for my $header (map { split(/(?:\x0d\x0a)/,$_) } @raw) {
                
		no warnings;
                if ( $header =~ /^\*\s+\d+\s+FETCH\s+\(.*BODY\[HEADER(?:\]|\.FIELDS)/i) {
                        if ($self->Uid) {
                                if ( my($msgid) = $header =~ /UID\s+(\d+)/ ) {
                                        $h = {};
                                        $headers->{$msgid} = $h;
                                } 
				else {
                                        $h = {};
                                }
                        } 
			else {
                                if ( my($msgid) = $header =~ /^\*\s+(\d+)/ ) {
                                        #start of new message header:
                                        $h = {};
                                        $headers->{$msgid} = $h;
                                }
                        }
                }
                next if $header =~ /^\s+$/;

                # ( for vi
                if ($header =~ /^\)/) {           # end of this message
                        $h = 0;                   # set to be between messages
                        next;
                }
                # check for '<optional_white_space>UID<white_space><UID_number><optional_white_space>)'
                # when parsing headers by UID.
                if ($self->Uid and my($msgid) = $header =~ /^\s*UID\s+(\d+)\s*\)/) {
                        $headers->{$msgid} = $h;        # store in results against this message
                        $h = 0;                         # set to be between messages
                        next;
                }

                if ($h != 0) {                    # do we expect this to be a header?
                        my $hdr = $header;
                        chomp $hdr;
                        $hdr =~ s/\r$//;
			#print "W[$hdr]", ref($hdr), "!\n";
			#next if ( ! defined($hdr));
			#print "X[$hdr]\n";

                        if (defined($hdr) and ($hdr =~ s/^(\S+):\s*//)) {
			# if ($hdr =~ s/^(\S+):\s*//) {
				#print "X1\n";
				$field = exists $fieldmap{lc($1)} ? $fieldmap{lc($1)} : $1 ;
                                push @{$h->{$field}} , $hdr ;
                        } elsif ($hdr =~ s/^.*FETCH\s\(.*BODY\[HEADER\.FIELDS.*\)\]\s(\S+):\s*//) { 
				#print "X2\n";
                                $field = exists $fieldmap{lc($1)} ? $fieldmap{lc($1)} : $1 ;
                                push @{$h->{$field}} , $hdr ;
                        } elsif ( ref($h->{$field}) eq 'ARRAY') {
				#print "X3\n";
                                
                                        $hdr =~ s/^\s+/ /;
                                        $h->{$field}[-1] .= $hdr ;
                        }
                }
        }
	use warnings;
#       my $candump = 0;
#       if ($self->Debug) {
#                eval {
#                        require Data::Dumper;
#                        Data::Dumper->import;
#                };
#                $candump++ unless $@;
#        }

	}
        # if we asked for one message, just return its hash,
        # otherwise, return hash of numbers => header hash
        # if (ref($msgspec) eq 'ARRAY') {
        
	return $headers;
        
};


*Mail::IMAPClient::authenticate = sub {

        my $self        = shift;
        my $scheme      = shift;
        my $response    = shift;

        $scheme   ||= $self->Authmechanism;
        $response ||= $self->Authcallback;
        my $clear = $self->Clear;

        $self->Clear($clear)
                if $self->Count >= $clear and $clear > 0;

        my $count       = $self->Count($self->Count+1);


        my $string = "$count AUTHENTICATE $scheme";

        $self->_record($count,[ $self->_next_index($self->Transaction), 
                                "INPUT", "$string\x0d\x0a"] );

        my $feedback = $self->_send_line("$string");

        unless ($feedback) {
                $self->LastError("Error sending '$string' to IMAP: $!\n");
                return undef;
        }

        my ($code, $output);

        until ($code) {
                $output = $self->_read_line or return undef;
		
                foreach my $o (@$output) {
                        $self->_record($count,$o);      # $o is a ref
                        ($code) = $o->[DATA] =~ /^\+(.*)$/ ;
                        if ($o->[DATA] =~ /^\*\s+BYE/) {
                                $self->State(Unconnected);
                                return undef ;
                        }
                        if ($o->[DATA]=~ /^\d+\s+(NO|BAD)/i) {
                                return undef ;
			}
                }
        }

        if ('CRAM-MD5' eq $scheme && ! $response) {
          if ($Mail::IMAPClient::_CRAM_MD5_ERR) {
            $self->LastError($Mail::IMAPClient::_CRAM_MD5_ERR);
            carp $Mail::IMAPClient::_CRAM_MD5_ERR;
          } 
	  else {
            $response = \&Mail::IMAPClient::_cram_md5;
          }
        }

        $feedback = $self->_send_line($response->($code, $self));

        unless ($feedback) {
                $self->LastError("Error sending append msg text to IMAP: $!\n");
                return undef;
        }

        $code = "";     # clear code
        until ($code) {
                $output = $self->_read_line or return undef;
                foreach my $o (@$output) {
                        $self->_record($count,$o);      # $o is a ref
                        if ( ($code) = $o->[DATA] =~ /^\+ (.*)$/ ) {
                                $feedback = $self->_send_line($response->($code,$self));
                                unless ($feedback) {
                                        $self->LastError("Error sending append msg text to IMAP: $!\n");
                                        return undef;
                                }
                                $code = "" ;            # Clear code; we're still not finished
                        } else {
                                $o->[DATA] =~ /^$count (OK|NO|BAD)/ and $code = $1;
                                if ($o->[DATA] =~ /^\*\s+BYE/) {
                                        $self->State(Unconnected);
                                        return undef ;
                                }
                        }
                }
        }

        $code =~ /^OK/ and $self->State(Authenticated) ;
        return $code =~ /^OK/ ? $self : undef ;

};



*Mail::IMAPClient::_cram_md5 = sub  {
  my ($code, $client) = @_;
  my $hmac = Digest::HMAC_MD5::hmac_md5_hex(MIME::Base64::decode($code),
                                            $client->Password());
  return MIME::Base64::encode($client->User() . " $hmac", "");
};

*Mail::IMAPClient::message_string = sub {
        my $self = shift;
        my $msg  = shift;
        my $expected_size = $self->size($msg);
        return undef unless(defined $expected_size);    # unable to get size
        my $cmd  =      $self->has_capability('IMAP4REV1')                              ?
                                "BODY" . ( $self->Peek ? '.PEEK[]' : '[]' )             :
                                "RFC822" .  ( $self->Peek ? '.PEEK' : ''  )             ;

        $self->fetch($msg,$cmd) or return undef;

        my $string = "";

        foreach my $result  (@{$self->{"History"}{$self->Transaction}}) {
              $string .= $result->[DATA]
                if defined($result) and $self->_is_literal($result) ;
        }

        # BUG? should probably return undef if length != expected
	# No bug, somme servers are buggy.

        if ( length($string) != $expected_size ) {
                warn "message_string: " .
                        "expected $expected_size bytes but received " .
                        length($string) . "\n";
		$self->LastError("message_string: expected ".
                        "$expected_size bytes but received " .
                        length($string)."\n");
        }
        return $string;
};


{
no warnings 'once';

*Mail::IMAPClient::Ssl = sub {
	my $self = shift;
	
	if (@_) { $self->{SSL} = shift }
	return $self->{SSL};
};


*Mail::IMAPClient::Authuser = sub {
	my $self = shift;
	
	if (@_) { $self->{AUTHUSER} = shift }
	return $self->{AUTHUSER};
};

}

# End of sub override_imapclient (yes, very bad indentation)
}

sub myconnect {
	my $self = shift;
	
	$self->Port(143) 
		if 	defined ($IO::Socket::INET::VERSION) 
		and 	$IO::Socket::INET::VERSION eq '1.25' 
		and 	!$self->Port;
	%$self = (%$self, @_);

        my $sock = ($self->Ssl ? IO::Socket::SSL->new : IO::Socket::INET->new);
        my $dp = ($self->Ssl ? 'imaps(993)' : 'imap(143)');

	my $ret = $sock->configure({
		PeerAddr => $self->Server		,
                PeerPort => $self->Port||$dp	       	,
                Proto    => 'tcp' 			,
                Timeout  => $self->Timeout||0		,
		Debug	=> $self->Debug 		,
	});
	unless ( defined($ret) ) {
		$self->LastError( "$@\n");	  
		$@ 		= "$@";   
		carp 		  "$@" 
				unless defined wantarray;	
		return undef;
	}
	$self->Socket($sock);
	if ( $Mail::IMAPClient::VERSION =~ /^2/ ) {
	    return undef unless myconnect_v2($self);
	}
	else {
		$self->Ignoresizeerrors($allowsizemismatch);
	}
	if ($self->User and $self->Password) {
		return $self->login ;
	} 
	else {
		return $self;	
	}
}

	
sub myconnect_v2 {
	my $self = shift;
	$self->State(Connected);
	$self->Socket->autoflush(1);
	my ($code, $output);
        $output = "";
        until ( $code ) {
                $output = $self->_read_line or return undef;
                for my $o (@$output) {
			$self->_debug("Connect: Received this from readline: " . 
					join("/",@$o) . "\n");
                        $self->_record($self->Count,$o);	# $o is a ref
                      next unless $o->[TYPE] eq "OUTPUT";
                      ($code) = $o->[DATA] =~ /^\*\s+(OK|BAD|NO)/i  ;
                }

        }

	if ($code =~ /BYE|NO /) {
		$self->State(Unconnected);
		return undef ;
	}
	return $self;
}


package Mail::IMAPClient;


sub Split {
	my $self = shift;
	
	if (@_) { $self->{SPLIT} = shift }
	return $self->{SPLIT};
}