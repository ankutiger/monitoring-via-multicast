#!/usr/bin/perl

die("$! : Cant fork") unless (defined($pid = fork)) ;

if($pid)
{
  #parent process
  system("sbin/prod_ics2_error_log-mc.pl") and die("stopped ics2 error monitoring\n") ;
}
else
{
  #child process
  system("sbin/prod_nta_error_log-mc.pl") and die("stopped nta error monitoring\n");
