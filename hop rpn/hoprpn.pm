#!
package hoprpn;
use Exporter;
use v5.10;
our @EXPORT_OK = qw( evaluate);

sub new
{

my @stack;

#rpn-table 

my $actions = {
'+' => sub { push @stack, pop(@stack) + pop(@stack) },
'*' => sub { push @stack, pop(@stack) * pop(@stack) },
'-' => sub { my $s = pop(@stack); push @stack, pop(@stack) - $s },
'/' => sub { my $s = pop(@stack); push @stack, pop(@stack) / $s },
'NUMBER' => sub { push @stack, $_[0] },
'_DEFAULT_' => sub { die "Unrecognized token '$_[0]'; aborting" }
};

#my $result = evaluate($ARGV[0], $actions);
#my $result = evaluate(@ARGV);
say "Result: $result";
}

sub evaluate {
my (@expr) = @_;

my $line = join(",",@expr);  
my $expr1 = join(" ",@expr);

say "expr: $expr[0]";

say "line: $line";

#my @tokens = split /\s+/, $expr;

my @stack;

#rpn-table 

my $actions = {
'+' => sub { push @stack, pop(@stack) + pop(@stack) },
'*' => sub { push @stack, pop(@stack) * pop(@stack) },
'-' => sub { my $s = pop(@stack); push @stack, pop(@stack) - $s },
'/' => sub { my $s = pop(@stack); push @stack, pop(@stack) / $s },
'sqrt' => sub { push @stack, sqrt(pop(@stack)) },
'mn' => sub { push @stack, mean(@stack) },
'md' =>sub {push @stack, median(@stack)},
'std' =>sub {push @stack, stdev(@stack)},
'NUMBER' => sub { push @stack, $_[0] },
'_DEFAULT_' => sub { die "Unrecognized token '$_[0]'; aborting" }
};




my @tokens = split /\s+/, $expr1;

my $i = 0;
for my $token (@tokens) {
 
 say "$i:$token";
 $i++;
 
my $type;
# if ($token =˜ /?\d+$/) learning perl p. 83 - chapt 2 programming perl
my $t = 0;

if ($token =~ /^\d+$/)
 { # It’s a number
$type = 'NUMBER';
$t = length($type);
}
say "type len: $t";
my $swt = 0;
if ($t > 0)
{
my $action = $actions->{$type};
$swt = 1; 
say ":one";
$action->($token);
}
elsif (length ($token) > 0)
{
 my $action =  $actions->{$token};
 $swt = 2;
  say ":two";
  if (defined($action))
  {
     $action->();
  }
  else
  {
      @stack = ();
      last;
  }
}
if ($swt==0)
{
 my $action = $actions->{_DEFAULT_};
 say ":three";
 
}
say " token: $token " if defined $token;
say "- type: $type" if defined $type;
say " - actions: $actions" if defined $actions; 
say "- swt: $swt" if defined $swt;
#say "act:$action";
#$action->($token, $type, $actions);

}
return pop(@stack);
}

sub sqrt
{
    my $n = shift;
    my $g = $n;
    until (close_enough($g*$g, $n)) {
         $g = ($g*$g + $n) / (2*$g);
        }
        return $g;
}
sub close_enough
{
    my ($a, $b) = @_;
    return($a - $b) < 1e-12;
}

sub mean {
    my(@data) = @_;
    my $sum;
    $sum += $_ foreach(@data);
    return @data ? ($sum / @data) : 0;
}

sub median {
    my(@data) = sort { $a <=> $b } @_;
    if (scalar(@data) % 2) {
        return($data[@data / 2]);
    }
    return (mean($data[@data / 2],
                  $data[@data / 2 - 1]));
}

sub stdev{
        my(@data) = @_;
        if(@$data == 1){
                return 0;
        }
        my $average = &mean(@data);
         say "avg: $average";
        my $sqtotal = 0;
        foreach(@$data) {
                $sqtotal += ($average-$_) ** 2;
        }
        my $std = ($sqtotal / (@$data-1)) ** 0.5;
        return $std;
}
1;
