#!/usr/bin/perl -w

$Cols=80;
$Lines=37;

# script/mandelprint.pl -0.620931440443213 0.455505540166205 0.007271468144044

my ($center_real, $center_imaginary, $width) = @ARGV;
my @chars = reverse(' ','.','-','~','=',':','+','O','%','@','#');
$MaxIter=scalar(@chars)-1;

unless ($center_real && $center_imaginary && $width) {
	$center_real = -0.5;
	$center_imaginary = 0;
	$width = 1.5;
}
print "cr: $center_real  ci: $center_imaginary  w: $width\n";

$MinRe = $center_real - $width; 
$MaxRe = $center_real + $width;

$MinIm = $center_imaginary - $width; 
$MaxIm = $center_imaginary + $width;


for ($Im=$MinIm;$Im<=$MaxIm;$Im+=($MaxIm-$MinIm)/$Lines) {
	for ($Re=$MinRe;$Re<=$MaxRe;$Re+=($MaxRe-$MinRe)/$Cols) {
		$zr=$Re; 
		$zi=$Im;
		for ($n=0;$n<$MaxIter;$n++) {
			$a=$zr*$zr; $b=$zi*$zi;
			if($a+$b>4.0) {
				last;
			}
			$zi=2*$zr*$zi+$Im; $zr=$a-$b+$Re;
		}
		print $chars[$n];
	}
	print "\n";
}