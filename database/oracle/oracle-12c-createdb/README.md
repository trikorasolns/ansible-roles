Role Name
=========

Deploy Oracle databases

k. From the Initialization Parameters panel, on the Memory tab, select Custom Settings and provide the following values (measured in Mb): Memory Management Set this value to Manual Shared Memory Management.
Shared Pool Set this value to 152.

```oracle-sql
alter system set SHARED_POOL_SIZE = 152;
```
Buffer Cache Set this value to 36.
Java Pool Set this value to 32.
Large Pool Set this value to 8.
PGA Size Set this value to 36.

nls_length_semantics Change this value to CHAR.
open_cursors Change this value to 1000.
cursor_sharing Set this value to FORCE.

Requirements
------------

Any pre-requisites that may not be covered by Ansible itself or the role should be mentioned here. For instance, if the role uses the EC2 module, it may be a good idea to mention in this section that the boto package is required.

After installation change the root password.

Get installation password.

```bash
$ grep "temporary password is generated" /var/log/mysqld.log

1970-01-01T00:00:00.000000Z 1 [Note] A temporary password is generated for root@localhost: <a generated password>
```

Change the password.

```bash
$ mysqladmin -u root password newPassword -p

Enter password: <a generated password>
mysqladmin: [Warning] Using a password on the command line interface can be insecure.
Warning: Since password will be sent to server in plain text, use ssl connection to ensure password safety.
```

Role Variables
--------------

A description of the settable variables for this role should go here, including any variables that are in defaults/main.yml, vars/main.yml, and any variables that can/should be set via parameters to the role. Any variables that are read from other roles and/or the global scope (ie. hostvars, group vars, etc.) should be mentioned here as well.

Dependencies
------------

A list of other roles hosted on Galaxy should go here, plus any details in regards to parameters that may need to be set for other roles, or variables that are used from other roles.

Example Playbook
----------------

Including an example of how to use your role (for instance, with variables passed in as parameters) is always nice for users too:

    - hosts: servers
      roles:
         - { role: username.rolename, x: 42 }

License
-------

BSD

Author Information
------------------

Trikora Solutions (AJC).


Misc
----


DBAORA
oracle expert presents
DBAORA
Search
Main menu
Skip to primary content

    Home
    About me
    Installations
    Learnings
    New features 11g
    New features 12c
    New features 13c
    New features 18C
    New features 19C

Post navigation
← Previous Next →
Install Oracle in silent mode 12C Release 1 (12.1) on OEL6
Posted on February 7, 2015

This article presents how to install Oracle 12C Release 1 in silent mode.

Silent mode installation allows to configure necessary Oracle components without using graphical interface nor any interaction with end user. It’s very useful method especially when you want to prepare standard installation using shell scripts.

Read following article to install OEL6 Linux: Install Oracle Linux 6 64 bit(for comfort set 4G memory for your virtual machine). During OEL6 installation I drop user oracle and both group dba and oinstall.

Software

Software for 12CR1 is available on OTN or edelivery

    OTN: Oracle Database 12c Release 1 (12.1.0.2) Software (64-bit).
    edelivery: Oracle Database 12c Release 1 (12.1.0.2) Software (64-bit)

Database software

linuxamd64_12102_database_1of2.zip
linuxamd64_12102_database_2of2.zip

Requirements

Be sure you fulfil following:

    Oracle Linux 6 with the Unbreakable Enterprise kernel: 2.6.39-200.24.1.el6uek.x86_64 or later
    Oracle Linux 6 with the Red Hat Compatible kernel: 2.6.32-71.el6.x86_64 or later

OS configuration and preparation

OS configuration is executed as root. To login as root just execute following command in terminal.

su - root

It’s recommended to update your OEL6 kernel to latest version as root

yum update

The “/etc/hosts” file must contain a fully qualified name for the server.

<IP-address>  <fully-qualified-machine-name>  <machine-name>

For example.

127.0.0.1 oel6.dbaora.com oel6 localhost.localdomain localhost

Add groups

#groups for database management
groupadd -g 54321 oinstall
groupadd -g 54322 dba
groupadd -g 54323 oper
groupadd -g 54324 backupdba
groupadd -g 54325 dgdba
groupadd -g 54326 kmdba
groupadd -g 54327 asmdba
groupadd -g 54328 asmoper
groupadd -g 54329 asmadmin

Add user Oracle for database software

useradd -u 54321 -g oinstall -G dba,oper,backupdba,dgdba,kmdba oracle

Change password for user Oracle

passwd oracle

OS configuration

Check which packages are installed and which are missing

rpm -q --qf '%{NAME}-%{VERSION}-%{RELEASE}(%{ARCH})\n' binutils \
compat-libcap1 \
compat-libstdc++-33 \
elfutils-libelf \
elfutils-libelf-devel \
gcc \
gcc-c++ \
glibc \
glibc-common \
glibc-devel \
glibc-headers \
ksh \
libaio \
libaio-devel \
libgcc \
libstdc++ \
libstdc++-devel \
make \
libXext \
libXtst \
libX11 \
libXau \
libxcb \
libXi \
sysstat \
unixODBC \
unixODBC-devel

Install missing packages. It’s just example:

#directory with mounted Oracle Enterprise Linux 6 install disk

cd /media/<OEL6>/Server/Packages

#install missed packages (example for package unixODBC*)

rpm -Uvh unixODBC*

Add kernel parameters to /etc/sysctl.conf

--kernel parameters for 12gR1 installation

fs.file-max = 6815744
kernel.sem = 250 32000 100 128
kernel.shmmni = 4096
kernel.shmall = 1073741824
kernel.shmmax = 43980{{ smtp_port }}11104
net.core.rmem_default = 262144
net.core.rmem_max = 4194304
net.core.wmem_default = 262144
net.core.wmem_max = 1048576
fs.aio-max-nr = 1048576
net.ipv4.ip_local_port_range = 9000 65500

Apply kernel parameters

/sbin/sysctl -p

Add following lines to set shell limits for user oracle in file /etc/security/limits.conf

--shell limits for users oracle 12gR1

oracle   soft   nofile   1024
oracle   hard   nofile   65536
oracle   soft   nproc    2047
oracle   hard   nproc    16384
oracle   soft   stack    10240
oracle   hard   stack    32768

Additional steps

Create .bash_profile for user oracle

# Oracle Settings
export TMP=/tmp

export ORACLE_HOSTNAME=oel6.dbaora.com
export ORACLE_UNQNAME=ORA12C
export ORACLE_BASE=/ora01/app/oracle
export ORACLE_HOME=$ORACLE_BASE/product/12.1.0/db_1
export ORACLE_SID=ORA12C

PATH=/usr/sbin:$PATH:$ORACLE_HOME/bin

export LD_LIBRARY_PATH=$ORACLE_HOME/lib:/lib:/usr/lib;
export CLASSPATH=$ORACLE_HOME/jlib:$ORACLE_HOME/rdbms/jlib;

alias cdob='cd $ORACLE_BASE'
alias cdoh='cd $ORACLE_HOME'
alias tns='cd $ORACLE_HOME/network/admin'
alias envo='env | grep ORACLE'

umask 022

envo

Create directory structure

ORACLE_BASE – /ora01/app/oracle

ORACLE_HOME – /ora01/app/oracle/product/12.1.0/db_1

mkdir -p /ora01/app/oracle/product/12.1.0/db_1
chown oracle:oinstall -R /ora01

Secure Linux

Disable secure linux by editing the /etc/selinux/config file, making sure the SELINUX flag is set as follows.

SELINUX=permissive

and enforce it

setenforce Permissive

Disable firewall

service iptables stop
chkconfig iptables off

Install database software

As Oracle user unzip software

su - oracle

cd /home/oracle

--unzip software 12.1.0.2
unizp linuxamd64_12102_database_1of2.zip
unzip linuxamd64_12102_database_1of2.zip

It should unzip it to one directory “database”

[oracle@oel6 ~]$ ls
database
linuxamd64_12102_database_1of2.zip
linuxamd64_12102_database_2of2.zip

Check directories and aliases for user oracle

--I defined 4 aliases in .bash_profile of user oracle to make
--administration easier :)

[oracle@oel6 ~]$ alias envo cdob cdoh tns
alias envo='env | grep ORACLE'
alias cdob='cd $ORACLE_BASE'
alias cdoh='cd $ORACLE_HOME'
alias tns='cd $ORACLE_HOME/network/admin'

--run alias command envo to display environment settings
envo
ORACLE_UNQNAME=ORA12C
ORACLE_SID=ORA12C
ORACLE_BASE=/ora01/app/oracle
ORACLE_HOSTNAME=oel6.dbaora.com
ORACLE_HOME=/ora01/app/oracle/product/12.1.0/db_1

--run alias command cdob and cdoh to check ORACLE_BASE, ORACLE_HOME
[oracle@oel6 ~]$ cdob
[oracle@oel6 oracle]$ pwd
/ora01/app/oracle

[oracle@oel6 db_1]$ cdoh
[oracle@oel6 db_1]$ pwd
/ora01/app/oracle/product/12.1.0/db_1

Response files

Once Oracle 12CR1 binaries are unzipped you can find in directory /home/oracle/database/response dedicated files called “response files” used for silent mode installations.

The response files store parameters necessary to install Oracle components:

    db_install.rsp – used to install oracle binaries, install/upgrade a database in silent mode
    dbca.rsp – used to install/configure/delete a database in silent mode
    netca.rsp – used to configure simple network for oracle database in silent mode

cd /home/oracle/database/response

[oracle@oel6 response]$ ls
dbca.rsp  db_install.rsp  netca.rsp

Install Oracle binaries

It’s the best to preserve original response file db_install.rsp before editing it

[oracle@oel6 response]$ cp db_install.rsp db_install.rsp.bck

Edit file db_install.rsp to set parameters required to install binaries. This is just example and in next releases parameters can be different. Each of presented parameter is very well described in db_install.rsp. I just give here brief explanations.

--------------------------------------------
-- force to install only database software
--------------------------------------------
oracle.install.option=INSTALL_DB_SWONLY

--------------------------------------------
-- set your hostname
--------------------------------------------
ORACLE_HOSTNAME=oel6.dbaora.com

--------------------------------------------
-- set unix group for oracle inventory
--------------------------------------------
UNIX_GROUP_NAME=oinstall

--------------------------------------------
-- set directory for oracle inventory
--------------------------------------------
INVENTORY_LOCATION=/ora01/app/oraInventory

--------------------------------------------
-- set oracle home for binaries
--------------------------------------------
ORACLE_HOME=/ora01/app/oracle/product/12.1.0/db_1

--------------------------------------------
-- set oracle home for binaries
--------------------------------------------
ORACLE_BASE=/ora01/app/oracle

--------------------------------------------
-- set version of binaries to install
-- EE - enterprise edition
--------------------------------------------
oracle.install.db.InstallEdition=EE

--------------------------------------------
-- specify extra groups for database management
--------------------------------------------
oracle.install.db.DBA_GROUP=dba
oracle.install.db.OPER_GROUP=oper
oracle.install.db.BACKUPDBA_GROUP=backupdba
oracle.install.db.DGDBA_GROUP=dgdba
oracle.install.db.KMDBA_GROUP=kmdba

once edition is completed. Start binaries installation

cd /home/oracle/database
./runInstaller -silent \
-responseFile /home/oracle/database/response/db_install.rsp

output is following

[oracle@oel6 database]$ ./runInstaller -silent \
> -responseFile /home/oracle/database/response/db_install.rsp
Starting Oracle Universal Installer...

Checking Temp space: must be greater than 500 MB.
Actual 41876 MB    Passed
Checking swap space: must be greater than 150 MB.
Actual 4095 MB    Passed
Preparing to launch Oracle Universal Installer from
/tmp/OraInstall2015-02-07_02-47-58PM. Please wait ...
[oracle@oel6 database]$ No protocol specified
[WARNING] - My Oracle Support Username/Email Address Not Specified
[SEVERE] - The product will be registered anonymously
using the specified email address.
You can find the log of this install session at:
 /ora01/app/oraInventory/logs/installActions2015-02-07_02-47-58PM.log
The installation of Oracle Database 12c was successful.
Please check
'/ora01/app/oraInventory/logs/silentInstall2015-02-07_02-47-58PM.log'
for more details.

As a root user, execute the following script(s):
    1. /ora01/app/oraInventory/orainstRoot.sh
    2. /ora01/app/oracle/product/12.1.0/db_1/root.sh

Successfully Setup Software.

you are asked to run two scripts as user root. Once it’s done binaries are installed

[root@oel6 /]#

/ora01/app/oraInventory/orainstRoot.sh
/ora01/app/oracle/product/12.1.0/db_1/root.sh

quick binary verification

[oracle@oel6 database]$ sqlplus / as sysdba
SQL*Plus: Release 12.1.0.2.0 Production on Sat Feb 7 14:53:44 2015
Copyright (c) 1982, 2014, Oracle.  All rights reserved.
Connected to an idle instance.
SQL>

Configure Oracle Net

Again based on response file Oracle Net will be configured

cd /home/oracle/database/response
cp netca.rsp netca.rsp.bck

You can edit netca.rsp to set own parameters. I didn’t changed anything here. So just start standard configuration. It will configure LISTENER with standard settings.

netca -silent -responseFile /home/oracle/database/response/netca.rsp

example output

[oracle@oel6 response]$ netca -silent \
-responseFile /home/oracle/database/response/netca.rsp

Parsing command line arguments:
  Parameter "silent" = true
  Parameter "responsefile" = /home/oracle/database/response/netca.rsp
Done parsing command line arguments.
Oracle Net Services Configuration:
Profile configuration complete.
Oracle Net Listener Startup:
  Running Listener Control:
    /ora01/app/oracle/product/12.1.0/db_1/bin/lsnrctl start LISTENER
  Listener Control complete.
  Listener started successfully.
Listener configuration complete.
Oracle Net Services configuration successful. The exit code is 0

Check LISTENER status

lsnrctl status

LSNRCTL for Linux: Version 12.1.0.2.0
Production on 07-FEB-2015 14:56:21
Copyright (c) 1991, 2014, Oracle.  All rights reserved.

Connecting to
(DESCRIPTION=(ADDRESS=(PROTOCOL=TCP)
                      (HOST=oel6.dbaora.com)(PORT=1521)))
STATUS of the LISTENER
------------------------
Alias           LISTENER
Version         TNSLSNR for Linux: Version 12.1.0.2.0 - Production
Start Date      07-FEB-2015 14:55:18
Uptime          0 days 0 hr. 1 min. 3 sec
Trace Level     off
Security        ON: Local OS Authentication
SNMP            OFF
Listener Parameter File
/ora01/app/oracle/product/12.1.0/db_1/network/admin/listener.ora
Listener Log File
/ora01/app/oracle/diag/tnslsnr/oel6/listener/alert/log.xml
Listening Endpoints Summary...
  (DESCRIPTION=(ADDRESS=(PROTOCOL=tcp)
                        (HOST=oel6.dbaora.com)(PORT=1521)))
  (DESCRIPTION=(ADDRESS=(PROTOCOL=ipc)(KEY=EXTPROC1521)))
The listener supports no services
The command completed successfully

Configure database

The last setup is to create new container database ORA12C.dbaora.com with one pluggable database PORA12C1 and configure and enable oracle db express

Prepare directories for database datafiles and flash recovery area

mkdir /ora01/app/oracle/oradata
mkdir /ora01/app/oracle/flash_recovery_area

backup original response file for dbca

cd /home/oracle/database/response

cp dbca.rsp dbca.rsp.bck
vi dbca.rsp

set own parameters

--------------------------------------------
-- global database name
--------------------------------------------
GDBNAME = "ORA12C.dbaora.com"

--------------------------------------------
-- instance database name
--------------------------------------------
SID = "ORA12C"

CREATEASCONTAINERDATABASE = true
NUMBEROFPDBS = 1
PDBNAME = PORA12C1
PDBADMINPASSWORD = "oracle"

--------------------------------------------
-- template name used to create database
--------------------------------------------
TEMPLATENAME = "General_Purpose.dbc"

--------------------------------------------
-- password for user sys
--------------------------------------------
SYSPASSWORD = "oracle"

--------------------------------------------
-- password for user system
--------------------------------------------
SYSTEMPASSWORD = "oracle"

--------------------------------------------
-- configure dbexpress with port 5500
--------------------------------------------
EMCONFIGURATION = "DBEXPRESS"
EMEXPRESSPORT = "5500"

--------------------------------------------
-- password for sysman user
--------------------------------------------
SYSMANPASSWORD = "oracle"

--------------------------------------------
-- password for dbsnmp user
--------------------------------------------
DBSNMPPASSWORD = "oracle"

--------------------------------------------
-- default directory for oracle database datafiles
--------------------------------------------
DATAFILEDESTINATION = /ora01/app/oracle/oradata

--------------------------------------------
-- default directory for flashback data
--------------------------------------------
RECOVERYAREADESTINATION = /ora01/app/oracle/flash_recovery_area

--------------------------------------------
-- storage used for database installation
-- FS - OS filesystem
--------------------------------------------
STORAGETYPE = FS

--------------------------------------------
-- database character set
--------------------------------------------
CHARACTERSET = "AL32UTF8"

--------------------------------------------
-- national database character set
--------------------------------------------
NATIONALCHARACTERSET = "AL16UTF16"

--------------------------------------------
-- listener name to register database to
--------------------------------------------
LISTENERS = "LISTENER"

--------------------------------------------
-- force to install sample schemas on the database
--------------------------------------------
SAMPLESCHEMA=TRUE

--------------------------------------------
--specify database type
--has influence on some instance parameters
--------------------------------------------
DATABASETYPE = "OLTP"

--------------------------------------------
-- force to use autmatic mamory management
--------------------------------------------
AUTOMATICMEMORYMANAGEMENT = "TRUE"

--------------------------------------------
-- defines size of memory used by the database
--------------------------------------------
TOTALMEMORY = "1024"

run database installation

dbca -silent -responseFile /home/oracle/database/response/dbca.rsp

Example output

dbca -silent -responseFile /home/oracle/database/response/dbca.rsp
Copying database files
1% complete
2% complete
27% complete
Creating and starting Oracle instance
29% complete
32% complete
33% complete
34% complete
38% complete
42% complete
43% complete
45% complete
Completing Database Creation
48% complete
51% complete
53% complete
62% complete
64% complete
72% complete
Creating Pluggable Databases
78% complete
100% complete
Look at the log file
"/ora01/app/oracle/cfgtoollogs/dbca/ORA12C/ORA12C.log"
for further details.

Verify connection

[oracle@oel6 ~]$ sqlplus / as sysdba
SQL*Plus: Release 12.1.0.2.0 Production on Sat Feb 7 15:49:59 2015
Copyright (c) 1982, 2014, Oracle.  All rights reserved.
Connected to:
Oracle Database 12c Enterprise Edition
Release 12.1.0.2.0 - 64bit Production
With the Partitioning, OLAP,
Advanced Analytics and Real Application Testing options
SQL> show parameter db_name
NAME      TYPE    VALUE
--------- ------- -------
db_name   string  ORA12C

SQL> alter session set container=PORA12C1;
Session altered.

SQL> show con_id
CON_ID
------------------------------
3

SQL> show con_name
CON_NAME
------------------------------
PORA12C1

Check port status of db express

SQL> select DBMS_XDB_CONFIG.GETHTTPSPORT
from dual;

GETHTTPSPORT
------------
    5500

Edit the “/etc/oratab” file to set restart flag for ORA12C to ‘Y’.

ORA12C:/ora01/app/oracle/product/12.1.0/db_1:Y

Have a fun 🙂

Tomasz
This entry was posted in Installations, Oracle 12C New Features by joda3008. Bookmark the permalink.
6 thoughts on “Install Oracle in silent mode 12C Release 1 (12.1) on OEL6”

    Ruben Jonkers on June 12, 2015 at 10:37 am said:

    Thanks for this wonderfull post! It helped me a great deal. Though now with the installation of the listenere I have a problem. The error log states that HA server is not configured. Do you know how to resolve this error?

    Thanks in advance!
    Reply ↓
    Bob on June 6, 2016 at 1:17 am said:

    Great Job.
    Reply ↓
    Musa Aliyev on September 19, 2016 at 7:35 am said:

    I am trying install all 11g and 12c version but I am failing on installing process. After this step “cd /home/oracle/database
    ./runInstaller -silent \
    -responseFile /home/oracle/database/response/db_install.rsp”. In log I can’t determine the reason.
    Reply ↓
        joda3008 on September 21, 2016 at 8:33 am said:

        You should get some error status

        Tomasz
        Reply ↓
        otinanai on February 7, 2018 at 10:54 am said:

        Set the following in your db_install.rsp:
        SECURITY_UPDATES_VIA_MYORACLESUPPORT=false DECLINE_SECURITY_UPDATES=true

        That was the problem for me.
        Reply ↓
    karishma on March 2, 2018 at 3:50 pm said:

    Hi,

    Thank you for wonderful notes. I did oracle silent installation but then i’m not able to do dbca silent it gives error like TNS lost connection.
    like
    / has enough space. Required space is 6140 MB , available space is 80484 MB.
    File Validations Successful.
    Cleaning up failed steps
    DBCA_PROGRESS : 5%
    Copying database files
    DBCA_PROGRESS : 7%
    DBCA_PROGRESS : 8%
    ORA-12547: TNS:lost contact

    DBCA_PROGRESS : 9%
    Error while cataloging RMAN Backups
    DBCA_PROGRESS : DBCA Operation failed.

    then i tried to do netca silent installation but listener is not running
    when i do lsnrctl status
    it does not give any output.

    Please help me.
    Reply ↓

Leave a Reply

Your email address will not be published. Required fields are marked *

Comment

Name *

Email *

Website

This site uses Akismet to reduce spam. Learn how your comment data is processed.
Proudly powered by WordPress


```bash
# Oracle Settings
export TMP=/tmp

export ORACLE_HOSTNAME=oel6.dbaora.com
export ORACLE_UNQNAME=ORA12C
export ORACLE_BASE=/ora01/app/oracle
export ORACLE_HOME=$ORACLE_BASE/product/12.1.0/db_1
export ORACLE_SID=ORA12C

PATH=/usr/sbin:$PATH:$ORACLE_HOME/bin

export LD_LIBRARY_PATH=$ORACLE_HOME/lib:/lib:/usr/lib;
export CLASSPATH=$ORACLE_HOME/jlib:$ORACLE_HOME/rdbms/jlib;

alias cdob='cd $ORACLE_BASE'
alias cdoh='cd $ORACLE_HOME'
alias tns='cd $ORACLE_HOME/network/admin'
alias envo='env | grep ORACLE'

umask 022

envo
```