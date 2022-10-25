#!/usr/bin/perl

use Math::Trig;

$name=$ARGV[0];
open(PDB,"${name}.pdb");
open(CFG,">${name}.cfg");
$i=1;
while($line=<PDB>){
  if($line=~/CRYST1/){
    @data=split(/ +/,$line);
    $la=$data[1];$lb=$data[2];$lc=$data[3];
    $alpha=$data[4]/180*pi();
    $beta=$data[5]/180*pi();
    $gamma=$data[6]/180*pi();
    $bx=cos($gamma)*$lb;
    $by=sin($gamma)*$lb;
    $cx=cos($beta)*$lc;
    $cy=(cos($alpha)-cos($beta)*cos($gamma))/(sin($gamma))*$lc;
    $cz=sqrt($lc*$lc-$cx*$cx-$cy*$cy);
    print CFG "Converting $name from PDB to DLPOLY\n";
    printf CFG "%10d%10d\n",0,2;
    printf CFG "%20.15f%20.15f%20.15f\n",$la,0.0,0.0;
    printf CFG "%20.15f%20.15f%20.15f\n",$bx,$by,0.0;
    printf CFG "%20.15f%20.15f%20.15f\n",$cx,$cy,$cz;
  }
  if($line=~/ATOM/){
    @data=split(/ +/,$line);
    $atomType=$data[2];
    if($data[4]=~/\d/){
      $atomX=$data[5];
      $atomY=$data[6];
      $atomZ=$data[7];
    }
    else{
      $atomX=$data[6];
      $atomY=$data[7];
      $atomZ=$data[8];
    }
    printf CFG "%-8s%10d\n",$atomType,$i;
    printf CFG "%20.15f%20.15f%20.15f\n",$atomX,$atomY,$atomZ;
    $i++;
  }
}
close(PDB);
close(CFG);


