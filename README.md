# NAME

Text::ASCIITable::EasyTable - create ASCII tables from an array of hashes

# SYNOPSIS

    use Text::ASCIITable::EasyTable;

    my $data = [
      { col1 => 'foo', col2 => 'bar' },
      { col1 => 'biz', col2 => 'buz' },
      { col1 => 'fuz', col2 => 'biz' },
    ];

    # easy
    my @index = ( ImageId => 'col1', Name => 'col2' );
    
    print easy_table(
      data          => $data,
      rows          => $rows,
      table_options => { headingText => 'My Easy Table' },
    );

    # easier 
    print easy_table(
      data          => $data,
      columns       => [ sort keys %{ $data->[0] } ],
      table_options => { headingText => 'My Easy Table' },
    );
    
    # easiest 
    print easy_table( data => $data );

# DESCRIPTION

[Text::ASCIITable](https://metacpan.org/pod/Text%3A%3AASCIITable) is one of my favorite modules when I'm writing
command line scripts that sometimes need to output data in tabular
format. It's so useful that I wanted to encourage myself to use it
more often. Although, it is quite easy to use already I thought it
could be easier.

## Features

- Easily create ASCII tables using [Text::ASCIITable](https://metacpan.org/pod/Text%3A%3AASCIITable) from
arrays of hashes.
- Define custom columns names (instead of the key names) that
also allow you to set the order of the data to be displayed in the table.
- Transform each element of the hash prior to insertion into the table.
- Sort rows by individual columns in the hashes
- Output JSON instead of a tableInstead of rendering a table,
`easy_table` can apply the same type of transformations to arrays of
hashes and subsequently output JSON.

Exports one method `easy_table`. 

# METHODS AND SUBROUTINES

## easy\_table

    easy_table(key => value, ...)

Returns a `Text::ASCIITable` object that you can print. Accepts a list
of key/value pairs described below.

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

    Array of column names that can represent both the keys that will be used to
    extract data from the hash for each row and the labels for each column.

- data

    Array of hashes that contain the data for the table.

- index

    An array (not a hash) of key/value pairs that define the column name (key)
    for a key (value) in a hash.

    Suppose your data looks like this:

        [
          { Subnet    => "subnet-12345678",
            VpcId     => "vpc-12345678",
            CidrBlock => "10.1.4.0/24"
          }
          ...
        ]

        print easy_table(
          table_options => { headingText => 'Subnets' },
          data          => $data,
          index         => [ Subnet => 'Subnet', VPC => 'VpcId', IP => 'CidrBlock' ]
        );

        .----------------------------------------------.
        |                    Subnets                   |
        +-----------------+--------------+-------------+
        | Subnet          | VPC          | IP          |
        +-----------------+--------------+-------------+
        | subnet-12345678 | vpc-12345678 | 10.1.4.0/24 |
        '-----------------+--------------+-------------'

- json

    Boolean that determines if a table or a JSON object should be returned.

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

- max\_rows

    Maximum number of rows to render.

- fix\_headings

    Many data sets will contain hash keys composed of lower case letters
    in what is termed _snake case_ (words separated by '\_') or _camel
    case_ (first letter of words in upper case). Set this to true to turn
    snake and camel case into space separated 'ucfirst'ed words.

    Example:

        creation_date => Creation Date
        IsTruncated   => Is Truncated

    default: false

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

# HINTS AND TIPS

- _`easy_table()` is meant to be used on small data sets and may not
be efficient when larger data sets are used._
- Add undef element to the array of data to create a horizontal line.

# SEE ALSO

[Text::ASCIITable](https://metacpan.org/pod/Text%3A%3AASCIITable), [Term::ANSIColor](https://metacpan.org/pod/Term%3A%3AANSIColor)

# AUTHOR

Rob Lauer - <rlauer6@comcast.net>>

# LICENSE AND COPYRIGHT

This module is free software. It may be used, redistributed and/or
modified under the same terms as Perl itself.
