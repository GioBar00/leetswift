export default {
  extends: ['@commitlint/config-conventional'],
  rules: {
    // Enforce all standard conventional commit types
    'type-enum': [
      2,
      'always',
      ['feat', 'fix', 'docs', 'chore', 'refactor', 'test', 'perf', 'revert', 'ci', 'build']
    ],
    // Subject line must not end with a period
    'subject-full-stop': [2, 'never', '.'],
    // Subject line must be lowercase
    'subject-case': [2, 'always', 'lower-case'],
    // Header line max length
    'header-max-length': [2, 'always', 100],
  }
};
