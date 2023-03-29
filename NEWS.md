# NEWS

This is the `NEWS` file for the `Text::ASCIITable::EasyTable`
project. This file contains information on changes since the last
release of the package, as well as a running list of changes from
previous versions.  If critical bugs are found in any of the software,
notice of such bugs and the versions in which they were fixed will be
noted here, as well.

# Text-ASCIITable-EasyTable 1.003 (2023-03-29)

This version fixes some errors in pod and introduces a new
`fix_headings` option to convert snake and camel case keys used as
column names in phrases.

## Enhancements

* `fix_headings` option

## Fixes

* pod correction

# Text-ASCIITable-EasyTable 1.002 (2023-02-04)

This version fixes version the unit test which did not import `output_from()`.

## Enhancements

* None

## Fixes

* `t/00-easy-table.t` patched to import `output_from()`

# Text-ASCIITable-EasyTable 1.001 (2023-01-26)

This version fixes version numbering and some minor tweaks to the
documentation.

## Enhancements

* pod tweaks for clarity

## Fixes

* fix module versioning

# Text-ASCIITable-EasyTable 0.03 (2023-01-25)

This version introduces a `max_rows` option.

## Enhancements

* new `max_rows` option to limit number of rows rendered

## Fixes

* requires JSON

# Text-ASCIITable-EasyTable 0.02 (2023-01-17)

Fixes unit tests on platforms that have older versions of
`List::Util`. Adds a JSON output option.

## Enhancements

* Added ability to output JSON only.
* Some refactoring to support above capability.

## Fixes

* Requires `List::Util` >= 1.29 for `pairs`

# Text-ASCIITable-EasyTable 0.01 (2023-01-16)

This is the first release of the project.

## Enhancements

None

## Fixes

None

