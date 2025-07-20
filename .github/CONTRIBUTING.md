# Contributing to DateUtils

Thank you for your interest in contributing to DateUtils! This project aims to provide a comprehensive date formatting solution for the 4D community.

## How to Contribute

### Reporting Issues
- Use the GitHub issue tracker to report bugs or request features
- Provide clear steps to reproduce any bugs
- Include your 4D version and environment details

### Contributing Code

1. **Fork the repository**
   - Click the "Fork" button on the GitHub repository page
   - Clone your fork locally

2. **Create a feature branch**
   ```bash
   git checkout -b feature/your-feature-name
   ```

3. **Make your changes**
   - Follow the existing code style and patterns
   - Add tests for new functionality
   - Update documentation as needed

4. **Test your changes**
   - Run the test suite: `DateFormatter_test.4dm`
   - Ensure all existing tests still pass
   - Test with different 4D environments if possible

5. **Submit a pull request**
   - Push your feature branch to your fork
   - Create a pull request against the main repository
   - Provide a clear description of your changes

### Code Style Guidelines

- Follow 4D naming conventions
- Use descriptive variable and method names
- Add comments for complex logic
- Maintain the singleton pattern for DateFormatter
- Ensure thread safety for all new code

### Testing

- All new features should include tests
- Tests should cover edge cases and error conditions
- Maintain the existing test structure in `DateFormatter_test.4dm`

## Code Review Process

- All contributions require code review
- The project maintainer (Kirk Brooks) will review all pull requests
- Changes may be requested before merging
- Only the maintainer can merge pull requests

## Questions?

If you have questions about contributing, please open an issue for discussion.

## License

By contributing to DateUtils, you agree that your contributions will be licensed under the MIT License.
