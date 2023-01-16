package Text::ASCIITable::EasyTable;

use strict;
use warnings;

use Text::ASCIITable;
use Scalar::Util qw(reftype);
use List::Util qw(pairs);
use Data::Dumper;

use parent qw(Exporter);

our @EXPORT = qw(easy_table);

our $VERSION = '0.01';

########################################################################
sub is_array { push @_, 'ARRAY'; goto &_is_type; }
sub is_hash  { push @_, 'HASH';  goto &_is_type; }
########################################################################

########################################################################
sub _is_type { return ref $_[0] && reftype( $_[0] ) eq $_[1]; }
########################################################################

########################################################################
sub easy_table {
########################################################################
  my (%options) = @_;

  die "'data' must be ARRAY\n"
    if !is_array $options{data};

  my @data = @{ $options{data} };

  my $table_options = $options{table_options};
  $table_options //= {};

  die "'table_options' must be HASH\n"
    if !is_hash $table_options;

  $table_options->{headingText} //= 'Table';

  # build a table...
  my $t = Text::ASCIITable->new($table_options);

  my @columns;
  my %rows;

  if ( $options{columns} ) {
    die "'columns' must be an ARRAY\n"
      if !is_array $options{columns};

    @columns = @{ $options{columns} };
  }
  elsif ( $options{rows} ) {
    die "'rows' must be ARRAY\n"
      if !is_array $options{rows};

    die "'rows' must be key/value pairs\n"
      if @{ $options{rows} } % 2;

    %rows = @{ $options{rows} };

    @columns = map { $_->[0] } pairs @{ $options{rows} };
  }
  else {
    @columns = keys %{ $data[0] };
  }

  $t->setCols(@columns);

  my $sort_key = $options{sort_key};

  if ($sort_key) {
    if ( reftype($sort_key) eq 'CODE' ) {
      @data = $sort_key->(@data);
    }
    else {
      @data = sort { lc $a->{$sort_key} cmp lc $b->{$sort_key} } @data;
    }
  }

  for my $row (@data) {
    if ( $options{rows} ) {
      $t->addRow(
        map {
          ref $rows{$_}
            && reftype( $rows{$_} ) eq 'CODE' ? $rows{$_}->( $row, $_ )
            : $rows{$_}                       ? $row->{ $rows{$_} }
            : $row->{$_}
        } @columns
      );
    }
    else {
      $t->addRow( @{$row}{@columns} );
    }
  }

  return $t;
}

1;

__END__

## no critic (RequirePodSections)

__END__

=pod

=head1 NAME

Text::ASCIITable::EasyTable - create ASCII tables from hashes

=head1 SYNOPSIS

 use Text::ASCIITable::EasyTable;

 my $data = [
   { col1 => 'foo', col2 => 'bar' },
   { col1 => 'biz', col2 => 'buz' },
   { col1 => 'fuz', col2 => 'biz' },
 ];

 # easy
 my %index = ( ImageId => 'col1', Name => 'col2' );

 my $rows = [
   ImageId => sub { shift->{ $index{ shift() } } },
   Name    => sub { shift->{ $index{ shift() } } },
 ];
 
 print easy_table(
   data          => $data,
   rows          => $rows,
   table_options => { headerText => 'My Easy Table' },
 );

 # easier 
 print easy_table(
   data          => $data,
   columns       => [ sort keys %{ $data->[0] } ],
   table_options => { headerText => 'My Easy Table' },
 );
 
 # easiest 
 print easy_table( data => $data );

=head1 DESCRIPTION

L<Text::ASCIITable> is one of my favorite modules when I am writing
command line scripts that sometimes need to output data. It's so
useful that I wanted to encourage myself to use it more
often. Although, it is quite easy to use already I thought it could
easier.

Easily create ASCII tables using L<Text::ASCIITable> from arrays of
hashes.  Custom columns names can be sent to set the order of the data
to be displayed in the table. You can also setup an array of
subroutines that transform each element of the hash prior to insertion
into the table. Rows can be ordered by one of the keys in the hash or
you can provide a custom sort routine that will be called prior to
rendering the table.

Exports one method C<easy_table>. 

=head1 METHODS AND SUBROUTINES

=head2 easy_table

=over 5

=item rows

Array (not hash) of key/value pairs where the key is the name of one
of the columns in the table and the value is either a subroutine
reference that returns the value of for that column, an undefined value, or the
name of a key in the hash that contains the value for that column.

 my $rows = [
   ID   => 'InstanceId',
   Name => sub { uc shift->{ImageName} },
   ];

=over 5

=item * If the value provided for the column name key is a subroutine, it will
be called with the hash for the current row being rendered and the
column name.

=item * If the value is undefined then the value for that column
will be the value of the hash member using the column name as the key.

=item *  If the value is not a code reference, then that value is assumed to
be the key to retrieve the value from the hash that will be inserted
into table.

=back

I<C<rows> is an array, not a hash in order to preserve
the order of the columns.>

=item data

Array of hashes that contain the data for the table.

=item columns

Array of column names that represent both the keys that will be used to
extract data from the hash for each row and the labels for each column.

=item sort_key

Key in the hash to use for sorting the array prior to rendering.  If
C<sort_key> is a CODE reference, that method will be called prior to
rendering.

=item table_options

Same options as those supported by L<Text::ASCIITable>.

=back

I<If neither C<rows> or C<columns> is provided, the keys are assumed
to be the column names. In that case the order in which the columns
appear will be non-determistic. If you want a specific order, provide
the C<columns> or C<rows> parameters. If you just want to see some
data and don't care about order, you can just send the C<data>
parameter and the method will more or less DWIM.>

=head1 SEE ALSO

L<Text::ASCIITable>, L<Term::ANSIColor>

=head1 AUTHOR

Rob Lauer - <rlauer6@comcast.net>>

=cut
