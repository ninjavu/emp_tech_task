module.exports = {
    "env": {
        "browser": true,
        "es2021": true
    },
    "extends": "plugin:react/recommended",
    "overrides": [
    ],
    "parserOptions": {
        "ecmaVersion": "latest",
        "sourceType": "module"
    },
    "plugins": [
        "react"
    ],
    "rules": {
        "react/prop-types": 0,
        "indent": ["error", 2],
        "linebreak-style": 1,
        "quotes": ["error", "single"],
        "semi": ["error", "never"],
        "object-curly-spacing": ["error", "always"],
        "array-bracket-spacing": ["error", "never"],
        "space-infix-ops": "error",
        "space-in-parens": ["error", "never"],
        "comma-spacing": ["error", { "before": false, "after": true }],
        "key-spacing": ["error", { "beforeColon": false }],
        "no-multi-spaces": "error",
        "eol-last": ["error", "always"],
        "no-multiple-empty-lines": ["error", { "max": 1, "maxEOF": 0 }],
        "arrow-spacing": "error"
    },
    "settings": {
        "react": {
            "version": "detect"
        }
    }
}
