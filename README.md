# unify-opening

`unify-opening` make packages in Emacs use the same mechanism to open
files.

## Summary

Currently, `dired` has its mechanism, `org-mode` uses something
different (the `org-file-apps` variable), and `mu4e` something else (a
simple prompt). This package makes sure that each package uses the
mechanism of `dired`. I advise you to install the
[`runner`](https://github.com/thamer/runner) package to improve the
`dired` mechanism.

## Contributing

Yes, please do! See [CONTRIBUTING][] for guidelines.

## License

See [COPYING][]. Copyright (c) 2015 Damien Cassou.


[CONTRIBUTING]: ./CONTRIBUTING.md
[COPYING]: ./COPYING
