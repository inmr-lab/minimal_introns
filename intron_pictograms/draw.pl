use Bio::Draw::Pictogram;
  use Bio::SeqIO;

  my $sio = Bio::SeqIO->new(-file=>$ARGV[0],-format=>'fasta');
  my @seq;
  while(my $seq = $sio->next_seq){
    push @seq, $seq;
  }

  my $picto = Bio::Draw::Pictogram->new(-width=>"900",
                                    -height=>"700",
                                    -fontsize=>"70",
                                    -plot_bits=>0,
                                    -background=>{
                                                  'A'=>0.25,
                                                  'C'=>0.25,
                                                  'T'=>0.25,
                                                  'G'=>0.25},
                                    -color=>{'A'=>'red',
                                             'G'=>'blue',
                                             'C'=>'green',
                                             'T'=>'magenta'},
                                    -normalize=>1);

  my $svg = $picto->make_svg(\@seq);

  print $svg->xmlify."\n";
