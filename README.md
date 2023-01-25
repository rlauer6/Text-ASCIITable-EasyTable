# NAME

Text::ASCIITable::EasyTable - create ASCII tables from hashes

# SYNOPSIS

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

# DESCRIPTION

[Text::ASCIITable](https://metacpan.org/pod/Text%3A%3AASCIITable) is one of my favorite modules when I am writing
command line scripts that sometimes need to output data. It's so
useful that I wanted to encourage myself to use it more
often. Although, it is quite easy to use already I thought it could
easier.

Easily create ASCII tables using [Text::ASCIITable](https://metacpan.org/pod/Text%3A%3AASCIITable) from arrays of
hashes.  Custom columns names (instead of the key names) can be
defined that allow you to set the order of the data to be displayed in
the table. Use an array of subroutines to transform each element of
the hash prior to insertion into the table. Rows can be sorted by one
of the keys in the hash or you can provide a custom sort routine that
will be called prior to rendering the table.

Instead of rendering a table, `easy_table` can apply the same type of
transformations to arrays of hashes and subsequently output JSON.

Exports one method `easy_table`. 

# METHODS AND SUBROUTINES

## easy\_table

- rows

    Array (not hash) of key/value pairs where the key is the name of one
    of the columns in the table and the value is either a subroutine
    reference that returns the value of for that column, an undefined value, or the
    name of a key in the hash that contains the value for that column.

        my $rows = [
          ID   => 'InstanceId',
          Name => sub { uc shift->{ImageName} },
          ];

    - If the value provided for the column name key is a subroutine, it will
    be called with the hash for the current row being rendered and the
    column name.
    - If the value is undefined then the value for that column
    will be the value of the hash member using the column name as the key.
    - If the value is not a code reference, then that value is assumed to
    be the key to retrieve the value from the hash that will be inserted
    into table.

    _`rows` is an array, not a hash in order to preserve
    the order of the columns._

- columns

    Array of column names that represent both the keys that will be used to
    extract data from the hash for each row and the labels for each column.

- data

    Array of hashes that contain the data for the table.

- json

    Instead of a table, return a JSON representation. The point here, is
    to use the transformation capabilities but rather than rendering a
    table, output JSON. Using this option you can transform the keys or
    the values of arrays of hashes using the same techniques you would use
    to transform the column names and column values in a table.

        my $data = [
          { col1 => 'foo', col2 => 'bar' },
          { col1 => 'biz', col2 => 'buz' },
          { col1 => 'fuz', col2 => 'biz' },
        ];
        
        my %index = ( ImageId => 'col1', Name => 'col2' );

        # dumb example, but the point is to transform 'some' of the data
        # in a non-trivial way
        my $rows = [
          ImageId => sub { uc shift->{ $index{ shift() } } },
          Name    => sub { uc shift->{ $index{ shift() } } },
        ];
        
        print easy_table(
          json => 1,
          data => $data,
          rows => $rows,
        );

        [
           {
              "ImageId" : "foo",
              "Name" : "bar"
           },
           {
              "Name" : "buz",
              "ImageId" : "biz"
           },
           {
              "ImageId" : "fuz",
              "Name" : "biz"
           }
        ]

    - _`easy_table()` is meant to be used on small data sets and may not
    be efficient when larger data sets are used._

- max\_rows

    Maximum number of rows to render.

- sort\_key

    Key in the hash to use for sorting the array prior to rendering.  If
    `sort_key` is a CODE reference, that method will be called prior to
    rendering.

- table\_options

    Same options as those supported by [Text::ASCIITable](https://metacpan.org/pod/Text%3A%3AASCIITable).

_If neither `rows` or `columns` is provided, the keys are assumed
to be the column names. In that case the order in which the columns
appear will be non-deterministic. If you want a specific order, provide
the `columns` or `rows` parameters. If you just want to see some
data and don't care about order, you can just send the `data`
parameter and the method will more or less DWIM._

# SEE ALSO

[Text::ASCIITable](https://metacpan.org/pod/Text%3A%3AASCIITable), [Term::ANSIColor](https://metacpan.org/pod/Term%3A%3AANSIColor)

# AUTHOR

Rob Lauer - <rlauer6@comcast.net>>

# LICENSE AND COPYRIGHT

This module is free software. It may be used, redistributed and/or
modified under the same terms as Perl itself.
