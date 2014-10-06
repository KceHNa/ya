<?php
mb_internal_encoding("UTF-8");

$zond1src=$_POST['zond1src'];
$zond2dst=$_POST['zond2dst'];
$time_m=$_POST['time_m'];
$time_h=$_POST['time_h'];
$runtime=$_POST['runtime'];
$paszond1=$_POST['paszond1'];
$traffictype=$_POST['traffictype'];
$DIR_cron="/var/spool/cron/crontabs/root";

echo "<a href=index.html> <--Setting network </a><br/><br/>";
echo "$traffictype <br />";
//$command="sed -i '/opt/s/[^/]*/56\ 21\ \* \*\ \* /' /var/spool/cron/crontabs/root";
$command="sed -i '/opt/s/[^/]*/$time_m\ $time_h\ \* \*\ \* /; '/opt/s/-t/-$traffictype/'; '/opt/s/-v/-$traffictype/'; s/[0-9]\{1,3\}.[0-9]\{1,3\}.[0-9]\{1,3\}.[0-9]\{1,3\}/'$zond2dst'/g' $DIR_cron";

//sed 's/[0-9]\{1,3\}.[0-9]\{1,3\}.[0-9]\{1,3\}.[0-9]\{1,3\}/'$IP'/g' /var/spool/cron/crontabs/root
echo $zond1src.' --> '.$zond2dst.' in time '.$time_h.':'.$time_m;
echo "<br/>";
echo "<br/>";
echo $command;
echo "<br/>";


if (!function_exists("ssh2_connect")) {exit("ssh2_connect disable");}
if (!($con = ssh2_connect($zond1src, 22))){exit("could not connect to $server :22");}
if (!ssh2_auth_password($con, 'root', $paszond1)) {exit("login/password is incorrect");}
if (!($stream = ssh2_exec($con, $command )))
{
 exit("remove command failed");
} 
        else
        { 
         stream_set_blocking($stream, true);
         $stream_out = ssh2_fetch_stream($stream, SSH2_STREAM_STDIO);
         echo stream_get_contents($stream_out);
         echo '<br /> OK';
        }
              

?>
