# 🚀 Pocketa GitHub Workflows Documentation

This document provides comprehensive information about all GitHub workflows configured for the Pocketa project.

## 📋 Table of Contents

- [Overview](#overview)
- [Workflow List](#workflow-list)
- [CI Pipeline](#ci-pipeline)
- [Security Pipeline](#security-pipeline)
- [PR Automation](#pr-automation)
- [Code Quality](#code-quality)
- [Release Pipeline](#release-pipeline)
- [Dependabot Configuration](#dependabot-configuration)
- [Templates](#templates)
- [Troubleshooting](#troubleshooting)

## 🎯 Overview

Pocketa uses a comprehensive set of GitHub workflows to ensure code quality, security, and reliable deployments. All workflows are designed to work together to provide a robust CI/CD pipeline.

### Key Features
- ✅ **Multi-platform builds** (Android, iOS, Web, Desktop)
- ✅ **Comprehensive testing** (Unit, Widget, Integration)
- ✅ **Security scanning** (Dependencies, Secrets, Code)
- ✅ **Code quality checks** (Linting, Formatting, Complexity)
- ✅ **Automated releases** with proper versioning
- ✅ **PR automation** with validation and labeling
- ✅ **Dependency management** with Dependabot

## 🔄 Workflow List

| Workflow | Trigger | Purpose | Duration |
|----------|---------|---------|----------|
| [CI Pipeline](.github/workflows/ci.yml) | Push/PR | Main CI/CD pipeline | ~15-30 min |
| [Security Pipeline](.github/workflows/security.yml) | Push/PR/Schedule | Security scanning | ~10-15 min |
| [PR Automation](.github/workflows/pr-automation.yml) | PR events | PR validation & automation | ~5-10 min |
| [Code Quality](.github/workflows/code-quality.yml) | Push/PR/Schedule | Code quality analysis | ~10-15 min |
| [Release Pipeline](.github/workflows/release.yml) | Tags/Manual | Release management | ~30-45 min |

## 🚀 CI Pipeline

**File**: `.github/workflows/ci.yml`  
**Trigger**: Push to main/develop/feature branches, PRs

### Jobs

#### 1. Code Analysis
- **Purpose**: Static code analysis and formatting checks
- **Duration**: ~10 minutes
- **Checks**:
  - Flutter analyze with fatal infos
  - Code formatting verification
  - Unused dependencies detection
  - Missing dependencies detection

#### 2. Security Scan
- **Purpose**: Security vulnerability scanning
- **Duration**: ~15 minutes
- **Checks**:
  - Flutter pub audit
  - Hardcoded secrets detection
  - Debug prints in production code
  - Sensitive files detection

#### 3. Testing
- **Purpose**: Comprehensive test execution
- **Duration**: ~20 minutes
- **Matrix Strategy**:
  - Unit tests
  - Widget tests
  - Integration tests
- **Coverage**: Code coverage reporting with Codecov

#### 4. Build Verification
- **Purpose**: Multi-platform build verification
- **Duration**: ~30 minutes
- **Platforms**:
  - Android (APK + App Bundle)
  - iOS (Archive)
  - macOS (App)
  - Windows (Executable)
  - Web (Static files)

#### 5. Performance Testing
- **Purpose**: Performance analysis and optimization
- **Duration**: ~25 minutes
- **Checks**:
  - Performance anti-patterns
  - setState usage analysis
  - Const constructor usage
  - Widget optimization

#### 6. Localization Check
- **Purpose**: Internationalization validation
- **Duration**: ~10 minutes
- **Checks**:
  - ARB file consistency
  - Missing translations
  - Key completeness

#### 7. Dependency Audit
- **Purpose**: Dependency management
- **Duration**: ~10 minutes
- **Checks**:
  - Outdated dependencies
  - Version conflicts
  - Security vulnerabilities

## 🔒 Security Pipeline

**File**: `.github/workflows/security.yml`  
**Trigger**: Push to main/develop, PRs, Daily schedule

### Jobs

#### 1. Dependency Vulnerability Scan
- **Purpose**: Scan for known vulnerabilities
- **Tools**: Flutter pub audit
- **Checks**:
  - Known vulnerable packages
  - Outdated dependencies
  - Security advisories

#### 2. Secrets Detection
- **Purpose**: Prevent secret leakage
- **Tools**: TruffleHog, Manual patterns
- **Checks**:
  - Hardcoded secrets
  - API keys
  - Passwords
  - Tokens
  - Sensitive files

#### 3. Code Security Analysis
- **Purpose**: Static security analysis
- **Checks**:
  - SQL injection patterns
  - XSS vulnerabilities
  - Insecure random generation
  - Hardcoded cryptographic keys
  - Debug prints in production

#### 4. Container Security
- **Purpose**: Container vulnerability scanning
- **Tools**: Trivy
- **Checks**: Container image vulnerabilities

#### 5. License Compliance
- **Purpose**: License compatibility checking
- **Checks**:
  - Problematic licenses (GPL, AGPL)
  - License file presence
  - Dependency license conflicts

## 🤖 PR Automation

**File**: `.github/workflows/pr-automation.yml`  
**Trigger**: PR events (opened, synchronized, reopened, ready_for_review)

### Jobs

#### 1. PR Validation
- **Purpose**: Validate PR format and content
- **Checks**:
  - Conventional commit title format
  - PR description adequacy
  - Breaking changes documentation
  - File change analysis

#### 2. Code Quality Gate
- **Purpose**: Quick quality checks
- **Checks**:
  - Static analysis
  - Code formatting
  - TODO/FIXME count

#### 3. Test Coverage Check
- **Purpose**: Ensure adequate test coverage
- **Threshold**: 80% minimum coverage

#### 4. PR Labels & Assignments
- **Purpose**: Automatic labeling and assignment
- **Features**:
  - Auto-label based on PR title
  - Size-based labeling
  - Automatic assignment

## 🔍 Code Quality

**File**: `.github/workflows/code-quality.yml`  
**Trigger**: Push to main/develop/feature branches, PRs, Daily schedule

### Jobs

#### 1. Static Analysis
- **Purpose**: Comprehensive static analysis
- **Checks**:
  - Flutter analyze
  - Code formatting
  - Custom linting rules
  - Missing const constructors
  - Unused imports

#### 2. Complexity Analysis
- **Purpose**: Code complexity assessment
- **Checks**:
  - Long methods (>50 lines)
  - Deep nesting (>5 levels)
  - Large classes (>200 lines)

#### 3. Dependency Analysis
- **Purpose**: Dependency health check
- **Checks**:
  - Unused dependencies
  - Outdated dependencies
  - Version conflicts

#### 4. Performance Analysis
- **Purpose**: Performance pattern analysis
- **Checks**:
  - setState usage
  - Const constructor usage
  - Heavy build operations
  - Missing widget keys

#### 5. Documentation Analysis
- **Purpose**: Documentation quality check
- **Checks**:
  - Documentation coverage
  - README completeness
  - Code comments

## 🚀 Release Pipeline

**File**: `.github/workflows/release.yml`  
**Trigger**: Git tags, Manual dispatch

### Jobs

#### 1. Pre-Release Validation
- **Purpose**: Comprehensive pre-release checks
- **Checks**:
  - Full test suite
  - Security audit
  - Static analysis
  - Version consistency

#### 2. Build Release Artifacts
- **Purpose**: Multi-platform builds
- **Platforms**:
  - Android (APK + App Bundle)
  - iOS (Archive)
  - Web (Static files)
  - Desktop (macOS, Windows, Linux)

#### 3. Create GitHub Release
- **Purpose**: Automated release creation
- **Features**:
  - Automatic changelog generation
  - Artifact upload
  - Release notes
  - Pre-release support

#### 4. Deploy Web (Optional)
- **Purpose**: Automatic web deployment
- **Trigger**: Main branch releases only
- **Target**: GitHub Pages

## 🔄 Dependabot Configuration

**File**: `.github/dependabot.yml`

### Features
- **Weekly Updates**: Every Monday at 9 AM UTC
- **Grouped Updates**: Related dependencies updated together
- **Smart Grouping**:
  - Flutter minor/patch updates
  - UI/UX dependencies
  - State management libraries
  - Testing frameworks
- **Safety Measures**:
  - Major version updates ignored for critical deps
  - Specific problematic versions blocked
  - Automatic labeling and assignment

## 📝 Templates

### Issue Templates
- **Bug Report**: Structured bug reporting with severity levels
- **Feature Request**: Comprehensive feature request form
- **Config**: Contact links and issue routing

### PR Template
- **Comprehensive Checklist**: Covers all aspects of code review
- **Type Classification**: Clear change categorization
- **Testing Requirements**: Mandatory testing verification
- **Documentation**: Required documentation updates

## 🛠️ Troubleshooting

### Common Issues

#### 1. Workflow Failures
```bash
# Check workflow logs
gh run list --workflow=ci.yml
gh run view <run-id> --log
```

#### 2. Build Failures
- **Android**: Check Java version compatibility
- **iOS**: Verify Xcode version and signing
- **Web**: Check Node.js version
- **Desktop**: Verify platform-specific dependencies

#### 3. Test Failures
- **Unit Tests**: Check test isolation and mocking
- **Widget Tests**: Verify widget tree structure
- **Integration Tests**: Check device/emulator availability

#### 4. Security Failures
- **Secrets**: Remove hardcoded secrets
- **Dependencies**: Update vulnerable packages
- **Code**: Fix security anti-patterns

### Debug Commands

```bash
# Local Flutter analysis
flutter analyze --fatal-infos

# Local testing
flutter test --coverage

# Local security audit
flutter pub audit

# Local formatting check
dart format --output=none --set-exit-if-changed .
```

### Performance Optimization

1. **Workflow Optimization**:
   - Use caching for dependencies
   - Parallel job execution
   - Conditional job execution

2. **Build Optimization**:
   - Incremental builds
   - Artifact caching
   - Platform-specific optimizations

3. **Test Optimization**:
   - Test sharding
   - Parallel test execution
   - Smart test selection

## 📊 Metrics and Monitoring

### Key Metrics
- **Build Success Rate**: Target >95%
- **Test Coverage**: Target >80%
- **Security Score**: Target A+
- **Deployment Time**: Target <45 minutes

### Monitoring Tools
- **GitHub Actions**: Built-in workflow monitoring
- **Codecov**: Test coverage tracking
- **Dependabot**: Dependency monitoring
- **Security Advisories**: Vulnerability tracking

## 🔧 Customization

### Adding New Workflows
1. Create new workflow file in `.github/workflows/`
2. Follow existing naming conventions
3. Add appropriate triggers and permissions
4. Update this documentation

### Modifying Existing Workflows
1. Test changes in feature branch
2. Update documentation
3. Consider backward compatibility
4. Notify team of changes

### Environment Variables
- `FLUTTER_VERSION`: Flutter SDK version
- `JAVA_VERSION`: Java version for Android builds
- `NODE_VERSION`: Node.js version for web builds

## 📚 Additional Resources

- [GitHub Actions Documentation](https://docs.github.com/en/actions)
- [Flutter CI/CD Best Practices](https://docs.flutter.dev/deployment/ci)
- [Dependabot Configuration](https://docs.github.com/en/code-security/dependabot)
- [Security Best Practices](https://docs.github.com/en/code-security)

---

**Last Updated**: $(date)  
**Maintainer**: @rakibulislammehedi  
**Version**: 1.0.0
