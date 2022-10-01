# CI/CD Toolkits
`seedee` is an open-source iOS CI/CD toolkit. While many projects use Fastlane, this toolkit provides a convenient way to write configuration files; that is, `seedee` config can use with Swift, the most familiar and loved language in the iOS world

![GitHub Workflow Status (branch)](https://github.com/ldakhoa/seedee/workflows/test/badge.svg)
![Lines of code](https://img.shields.io/tokei/lines/github/ldakhoa/seedee?style=flat-square)
![GitHub code size in bytes](https://img.shields.io/github/languages/code-size/ldakhoa/seedee?style=flat-square)
![GitHub](https://img.shields.io/github/license/ldakhoa/seedee?style=flat-square)

## Developments

To install and work on `seedee` locally:

1. Clone the project
```
git clone git@github.com:ldakhoa/seedee.git
cd seedee
xed . # That will open the Package.swift in Xcode
```

2. Build:
```
swift build
```

3. Make changes

4. Run tests
```
make test.integration.ios
```

5. Commit changes and creat pull requests

## License

[MIT](https://github.com/ldakhoa/seedee/blob/main/LICENSE)