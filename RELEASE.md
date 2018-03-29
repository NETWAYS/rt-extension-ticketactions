# Release Workflow

Specify the release version as shell variable.

```
VERSION=2.0.0
```

## Issues

Check remaining GitHub issues.

## Authors

Update the [.mailmap](.mailmap) and [AUTHORS](AUTHORS) files:

```
git checkout master
git log --use-mailmap | grep '^Author:' | cut -f2- -d' ' | sort | uniq > AUTHORS
```

## Version

Update the version in the module's `.pm` file and `META.yml`.

```
find lib/RT/ -type f -name '*.pm' -exec sed -i "s/our \$VERSION=.*/our \$VERSION='$VERSION';/g" {} \;
find . -type f -name 'META.yml' -exec sed -i "s/^version: .*/version: $VERSION/g" {} \;
```

## Changelog

Update the [CHANGELOG.md](CHANGELOG.md) file.

## Git Tag

Commit and push these changes to the "master" branch:

```
git commit -v -a -m "Release version $VERSION"
git push
```

Create a signed tag (tags/v<VERSION>) on the "master" branch (for major
releases).

```
git tag -s -m "Version $VERSION" v$VERSION
```

Push the tag:

```
git push --tags
```

# External Dependencies

## GitHub Release

Create a new release for the newly created Git tag.
Navigate to /releases and edit the tag, create a new release.

## Announcement

Coordinate with MH/MiF.

* Create a new blog post on https://blog.netways.de if sufficient.
* Social media: [Twitter](https://twitter.com/netways)

# After the release

* Close the released version on GitHub.
