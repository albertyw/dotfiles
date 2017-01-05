#!/usr/bin/perl
print "Size  Hash                                     Lines\n";
foreach my $rev (`git rev-list --all --pretty=oneline`) {
  my $tot = 0;
  ($sha = $rev) =~ s/\s.*$//;
  foreach my $blob (`git diff-tree -r -c -M -C --no-commit-id $sha`) {
    $blob = (split /\s/, $blob)[3];
    next if $blob == "0000000000000000000000000000000000000000"; # Deleted
    my $size = `echo $blob | git cat-file --batch-check`;
    $size = (split /\s/, $size)[2];
    $tot += int($size);
  }
  my $revn = substr($rev, 0, 40);
  $tot = `numfmt --to=si -z --padding 5 $tot`;
  print "$tot $revn " . `git show --pretty="format:" --name-only $revn | wc -l`  ;
}
