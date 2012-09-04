#!/shared/perl/bin/perl

use strict;

my $request_file = '/Users/rfox2/Development/griffin/script/fall_2012_video_requests_conv.csv';

open(my $fh, "<", $request_file)
    or die "cannot open file $request_file: $!";

my $i = 1;
foreach my $line (<$fh>) {
    chomp($line);
    # print "$line\n";
    my ($date,$netid,$course,$title,$file_name,$call_num,$order,$na,$status,$date_needed,$language,$subtitles,$library_owned,$prior_use,$na2,$note,$accept_toggle,$cms,$subtitle_language) = split(/\|/,$line);
    unless ($i == 1) {
        if ($title =~ /\w+/) {
            print "$date, $netid, $course, $title, $file_name, $date_needed, $language, $subtitles, $library_owned, $prior_use, $note, $cms, $subtitle_language\n";
        }
    }
    $i++;
}
