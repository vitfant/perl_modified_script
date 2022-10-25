#converts pdb file into DL_POLY config file
#!/usr/bin/perl

$name=$ARGV[0];
open(PDB,"${name}.pdb");
open(CFG,">${name}.cfg");
$i=1;
while($line=<PDB>){
  if($line=~/CRYST1/){
    @data=split(/ +/,$line);
    $la=$data[1];$lb=$data[2];$lc=$data[3];
    print CFG "Conveting $name from PDB to DLPOLY\n";
    printf CFG "%10d%10d\n",0,2;
    printf CFG "%20.15f%20.15f%20.15f\n",$la,0.0,0.0;
    printf CFG "%20.15f%20.15f%20.15f\n",0.0,$lb,0.0;
    printf CFG "%20.15f%20.15f%20.15f\n",0.0,0.0,$lc;
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


