BEGIN{	
	FS = "|"
	RS = "\n"
}
{
	print $1
	i = 2
	while (i <= NF) {
        print "\t" $i
        i++
    }
}